Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A35334D4D6;
	Thu, 28 May 2026 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998046; cv=none; b=q+VyZxbLG/YRvQVQDFTVLF2HpE2k1j5kscA82cNjDZ3LdVymCwSfuV2tnAFi1jnsdoa5TI5HvmD1YShIiGnK3DH/4vkM9/LID3gOCcKCHcjT/EdpnaoIS+M/mSlPI+RRXXDkQlJWqvUzzEvz/l04VZKvPCkpDFbBkXxSPzqwiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998046; c=relaxed/simple;
	bh=+QjueiJ/jXbteXXhOPPe0YPIfsVd5MW5mW1psTrkDJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPl7N0HZtMl33bai+vcUdtcbqpezMpSQ6AmFsrIuR44HYi0QYvKexs4xKBBd+PVl6e6XVbMmqwFSyy4CVTpJaRlsbz8ZzhxIfeIK2oC2gllKADp2uIZJA8T4SKqRs8lWLSDY+UfDsWzyEdHkFdAxj9SOPpDag8KnZeMgdI5IRsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig/gMwTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig/gMwTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229B71F00A3E;
	Thu, 28 May 2026 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998043;
	bh=MlxoBDSAStuJQZjgpq/0eNtdWAV4h9ogWbXtdDsm9PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig/gMwTGm+mLpllmx9LFYCKdLQyPX2wLv3nbBkRRI+punx9V2o35mUD7A2Z1qOPmQ
	 dMUidvjv9jZRbflL7tdjhu6pm3N2GEfJ12AsKq1Ev6sBDdYVmJI/eyl3o3/pMsLM/1
	 pBbtv3O8jklCy8QYoVNUcsSRYvYlIXzYm14Jy1JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 032/461] ipv6: ioam: refresh hdr pointer before ioam6_event()
Date: Thu, 28 May 2026 21:42:41 +0200
Message-ID: <20260528194647.826544434@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@gmail.com>

commit e46e6bc97fb1f339730ff1ba74267fbf48e7a422 upstream.

Reported by Sashiko:

In ipv6_hop_ioam(), the hdr pointer is initialized to point into the
skb's linear data buffer. Later, the code calls skb_ensure_writable(),
which might reallocate the buffer:

	if (skb_ensure_writable(skb, optoff + 2 + hdr->opt_len))
		goto drop;

	/* Trace pointer may have changed */
	trace = (struct ioam6_trace_hdr *)(skb_network_header(skb)
					   + optoff + sizeof(*hdr));

	ioam6_fill_trace_data(skb, ns, trace, true);

	ioam6_event(IOAM6_EVENT_TRACE, dev_net(skb->dev),
		    GFP_ATOMIC, (void *)trace, hdr->opt_len - 2);

If the skb is cloned or lacks sufficient linear headroom,
skb_ensure_writable() will invoke pskb_expand_head(), which reallocates
the skb's data buffer and frees the old one, invalidating pointers to
it. While the code recalculates the trace pointer immediately after the
call to skb_ensure_writable(), it fails to recalculate the hdr pointer.

This patch fixes the above by recalculating the hdr pointer before
passing hdr->opt_len to ioam6_event(), so that we avoid any UaF.

Fixes: f655c78d6225 ("net: exthdrs: ioam6: send trace event")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260520124242.32320-1-justin.iurman@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -955,9 +955,9 @@ static bool ipv6_hop_ioam(struct sk_buff
 		if (skb_ensure_writable(skb, optoff + 2 + hdr->opt_len))
 			goto drop;
 
-		/* Trace pointer may have changed */
-		trace = (struct ioam6_trace_hdr *)(skb_network_header(skb)
-						   + optoff + sizeof(*hdr));
+		/* Trace and hdr pointers may have changed */
+		hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
+		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
 
 		ioam6_fill_trace_data(skb, ns, trace, true);
 


