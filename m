Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3533633CE8A;
	Thu, 28 May 2026 20:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999142; cv=none; b=O/H/ZPAND9XSvUFNnqC+3U7taCGzbxo80d1VkkPFcbpBES5nFC6imdQR5BpqMiECLOYjvtzDBTO3nelDk7al0fMjIjMpFkpOJQlvo5KXy5KQCtmOzZuHfTk46/EywQpDrXnlIQFb7yH2djvwU2VUVo6tEK6Gi9LkNtU7JJhKcxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999142; c=relaxed/simple;
	bh=IK2iQtbnzdWm4Dq+Hsk3YciSN6Qlt2MYE58u9xg5Mmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOj+vkjunaYKCfcH7pALFUL4q4lVwxW4dS2pKXzC2EnM/CXdWoDVXAoCnX1YxkrBJ+hZSQsua/1QN5ffO3NFWvRgZKQgpzHxPygZ/eQ+R6Fb+h0OHbX10p6pOZStkdmBAtTKikobaY6zrdwiltSM26UIWJBX8R+wfnEvZwKL3Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsgMnOKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsgMnOKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DCE1F000E9;
	Thu, 28 May 2026 20:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999141;
	bh=3OZSCG1EXtf6+qZJs7Sxb5NecFhGtOcSK0Th0usTASo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsgMnOKcbee78+ei4rFzM51n/YLESZ920tw4rs/C6a/U9w7J67G1y6lXQf34dnFhT
	 W4ir5wVGwYXKnNIMKjdp3PizZmRkPwDaILpY3VXsHwpf04K4Oqre6DVkfnCmIc3knk
	 9mryzMcB0M9T9C2Os+H/hWeyYFJdxkGfmlE4w7BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemb@google.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 422/461] udp: gso: Fix handling checksum in __udp_gso_segment
Date: Thu, 28 May 2026 21:49:11 +0200
Message-ID: <20260528194659.717906814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 5f17ae0f595aeb560155ce98edbe44d3eacc7e40 ]

The cited commit started using msslen for uh->len, but still uses newlen
to adjust uh->check. Although the checksum is ignored in most cases due
to the hardware offload, __udp_gso_segment attempts to maintain the
correct one. Fix uh->check and adjust it by the right value.

Additionally, after the fix, newlen becomes assigned and unused before
the loop. The code can be simplified a bit if mss adjustment is dropped,
so that newlen becomes equal to msslen before the loop, and msslen can
be also dropped, saving a few lines of code.

This brings us back to one variable, drops an unneeded arithmetic for
mss, and fixes the UDP checksum.

Fixes: b10b446ce7ad ("udp: gso: Use single MSS length in UDP header for GSO_PARTIAL")
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20260518062250.3019914-2-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 6b1654c1ad4ac..e831234326c41 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -483,11 +483,11 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	struct sock *sk = gso_skb->sk;
 	unsigned int sum_truesize = 0;
 	struct sk_buff *segs, *seg;
-	__be16 newlen, msslen;
 	struct udphdr *uh;
 	unsigned int mss;
 	bool copy_dtor;
 	__sum16 check;
+	__be16 newlen;
 	int ret = 0;
 
 	mss = skb_shinfo(gso_skb)->gso_size;
@@ -556,15 +556,6 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		return segs;
 	}
 
-	msslen = htons(sizeof(*uh) + mss);
-
-	/* GSO partial and frag_list segmentation only requires splitting
-	 * the frame into an MSS multiple and possibly a remainder, both
-	 * cases return a GSO skb. So update the mss now.
-	 */
-	if (skb_is_gso(segs))
-		mss *= skb_shinfo(segs)->gso_segs;
-
 	seg = segs;
 	uh = udp_hdr(seg);
 
@@ -587,7 +578,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		if (!seg->next)
 			break;
 
-		uh->len = msslen;
+		uh->len = newlen;
 		uh->check = check;
 
 		if (seg->ip_summed == CHECKSUM_PARTIAL)
-- 
2.53.0



