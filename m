Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5F74A3850;
	Wed, 23 Sep 2026 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172610; cv=none; b=RXCRqYiMEZUYLSx6pKUda7dEMoJT4iGKMoe9yfkM+pASd1plq/nQbDHeXoeI7NilsQr58Z4Ai/h+UmwBjMgT/C/ei7sJ5TkdlWlrkOgSceNpCeI6OSjeZw7oQP6aHqrma7W+fVB/dY8L56o2mXJJfE6W0wv+jX6DI8Go9Pd7WOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172610; c=relaxed/simple;
	bh=+4KBdo6NB5/LqzVsqcmQK6SEDR3fzSS/uoVonszmTjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsvXc1C9LSk8xgEk6OpxwiAjD+3ZucJI+EmCK47bjb0rTIi2R4xpcCCsk1x1XmiX2UE2qTBFDLrt2Mcw/ug2Fo3tfQpChJ9QWMn7Z0Tj/w2JYjQ12+a8e668fGU1b72A6a/XUiBuJ1K554wW1PLJ1nkKF0wk8z2txrLjG1gkzfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClY6BoVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClY6BoVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF69D1F000FF;
	Wed, 23 Sep 2026 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172609;
	bh=nXsNC8ADAR+qQus8gNz/qlvDNe0luOu/7Fvd6B67JHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClY6BoVcy9mnCEhopt3PPhTRs6a0mGH283wgoXZ9Ar6egaoNFj1Ot32b8C8oiVcPT
	 wTLt6yYa+r4nOtJzAD9XniIaSHlsKRmQo8gyOqwf0OHqYQa1fb10EZMtWkuE5JQ56K
	 y8JWsIBuz06ATdbBOgOyjhxIWAet7Vf+Y3gR5aVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roshan Kumar <roshaen09@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 005/438] xfrm: iptfs: fix stack OOB read in iptfs_skb_reset_frag_walk()
Date: Wed, 23 Sep 2026 16:00:26 +0200
Message-ID: <20260923140644.902839362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roshan Kumar <roshaen09@gmail.com>

[ Upstream commit d042487dc118e494db2e2c1382310255c90ff544 ]

iptfs_skb_reset_frag_walk() advances to the fragment containing @offset
with an unbounded loop:

	while (offset >= walk->past + walk->frags[walk->fragi].len)
		walk->past += walk->frags[walk->fragi++].len;

walk->fragi is advanced and walk->frags[walk->fragi] is dereferenced
without ever checking fragi against walk->nr_frags. When the requested
offset is at or beyond the total length spanned by the walk's fragments,
fragi runs past nr_frags and off the end of the fixed-size on-stack
frags[MAX_SKB_FRAGS + 1] array, reading out-of-bounds stack memory.

The two callers behave differently: iptfs_skb_add_frags() already guards
against this with

	if (!walk->nr_frags ||
	    offset >= walk->total + walk->initial_offset)
		return len;

but iptfs_skb_can_add_frags() has no such guard and calls
iptfs_skb_reset_frag_walk() unconditionally, so it performs the
out-of-range walk. Its own "fragi < walk->nr_frags" bound check runs only
afterwards, too late to prevent the read.

This is reachable from the receive path: a crafted IP-TFS (AGGFRAG)
payload delivered to an IPTFS SA drives iptfs_reassem_cont() ->
iptfs_skb_can_add_frags() with an offset past the fragment total, e.g.:

  BUG: KASAN: stack-out-of-bounds in iptfs_skb_reset_frag_walk+0x235/0x250
  Read of size 4 at addr ffff888008ad7210 by task repro/345
   iptfs_skb_reset_frag_walk+0x235/0x250 net/xfrm/xfrm_iptfs.c:392
   iptfs_skb_can_add_frags+0x155/0x310  net/xfrm/xfrm_iptfs.c:420
   iptfs_reassem_cont+0xcf8/0x1140      net/xfrm/xfrm_iptfs.c:902
   iptfs_input_ordered+0x552/0x670      net/xfrm/xfrm_iptfs.c:1280
   iptfs_input+0x3d6/0xde0              net/xfrm/xfrm_iptfs.c:1741
   xfrm_input+0x282f/0x6140             net/xfrm/xfrm_input.c:700
   xfrm4_esp_rcv+0x93/0x120             net/ipv4/xfrm4_protocol.c:104
   ip_rcv+0x278/0x2d0                   net/ipv4/ip_input.c:612

Give iptfs_skb_can_add_frags() the same up-front guard that
iptfs_skb_add_frags() already has, so the walk is never entered with an
out-of-range offset. When it triggers, the caller falls back to the
existing linearize-and-copy path, which is safe.

Fixes: 5f2b6a909574 ("xfrm: iptfs: add skb-fragment sharing code")
Reported-by: Roshan Kumar <roshaen09@gmail.com>
Signed-off-by: Roshan Kumar <roshaen09@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_iptfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 597aedeac26eb..2ce15c472cc4d 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -416,6 +416,14 @@ static bool iptfs_skb_can_add_frags(const struct sk_buff *skb,
 	if (skb_has_frag_list(skb) || skb->pp_recycle != walk->pp_recycle)
 		return false;
 
+	/* Reject an @offset that is at or beyond the end of the walk's data
+	 * before calling iptfs_skb_reset_frag_walk(), whose fragment-advance
+	 * loop is otherwise unbounded and would index past walk->frags[].
+	 * This mirrors the guard already present in iptfs_skb_add_frags().
+	 */
+	if (!walk->nr_frags || offset >= walk->total + walk->initial_offset)
+		return false;
+
 	/* Make offset relative to current frag after setting that */
 	offset = iptfs_skb_reset_frag_walk(walk, offset);
 
-- 
2.53.0



