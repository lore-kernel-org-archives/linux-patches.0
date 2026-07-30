Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1D407597;
	Thu, 30 Jul 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423086; cv=none; b=V0WTwoo8bx6rnn+s7MJt4wkbJP1rb092Nyn0srcojMMuSEBGuor+jpYDSaQz9OLNJWFAri8dyIkccRPiNMl24Wir7Q/S2/cnqujYMiPRJUJ033WCpPphUAKPuTonqPGjCIo17xhsv5UnA5dME+L1b6CD2RKWO/U8KrETsKjfh/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423086; c=relaxed/simple;
	bh=bMQSUD2OxyqRipJVocgnAPAgpxdfaxQRHTdp6gFwdow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0r0VKNAh4hfk1iFsB/DvULpDHu/tF+S3fZVKWqy/KwBhnQ+hEnogBpAyUzHkdcLFfWYUL8COYSQXMbDpwHu2G3CwEnrKZSNQDkhaMAAKH90XHXgmGUas2T1F7JBFO/zLNm5ERMRKyl/nOvTNqL/aLuqG0LMy6/dghJKWQMhLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcngUis/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcngUis/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F911F000E9;
	Thu, 30 Jul 2026 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423085;
	bh=wa54eBIsh3BPLx9AKZTXQMxDNtYzSFmYS6nmErDkMiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcngUis/axToYX0IFZDNNQGAIJDDWMFVwwn3DW9pXmtJIlVhfpcKiiUn/zVYcr408
	 4TH6q1EHlz66xECgVEcNtAvmmF/nSdqBzb/WTiaxm8vFbRDVXS3I5dfIXSYZpL7jHw
	 MoPaVSCW9JBjPKUNnK7EfaXhxgQAzwRAoitwlRRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiming Cheng <shiming.cheng@mediatek.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 662/744] net: gro: fix double aggregation of flush-marked skbs
Date: Thu, 30 Jul 2026 16:15:35 +0200
Message-ID: <20260730141458.337152178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiming Cheng <shiming.cheng@mediatek.com>

commit e751256486d0ded20f5a9f9863467f1dce65142f upstream.

Commit 0ab03f353d36 ("net-gro: Fix GRO flush when receiving a GSO
packet.") added a flush check to skb_gro_receive(), but
skb_gro_receive_list() lacks the same validation.

As a result, packets marked with NAPI_GRO_CB(skb)->flush may still be
re-aggregated.

This allows already-GRO'd packets with existing frag_list to be
re-aggregated into a new GRO session, corrupting the frag_list chain
structure. When skb_segment() attempts to unpack these malformed packets,
it encounters invalid state and triggers a kernel panic.

Scenario (Tethering/Device forwarding):
  1. Driver: Generated aggregated packet P1 via LRO with frag_list
  2. Dev A: Receives aggregated fraglist packet and flush flag set
  3. Dev A: Re-enters GRO, skb_gro_receive_list() is called
  4. Missing flush check allows re-aggregation despite flush flag
  5. Frag_list chain becomes corrupted (loops or dangling refs)
  6. Dev B: TX path calls skb_segment(), crashes on corrupted frag_list

Root cause in skb_segment():
  The check at line ~4891:
    if (hsize <= 0 && i >= nfrags && skb_headlen(list_skb) &&
        (skb_headlen(list_skb) == len || sg)) {

  When frag_list is corrupted by double aggregation, when list_skb is
  a NULL pointer from skb->next, skb_headlen(list_skb) dereference
  NULL/corrupted pointers occurs.

Call Trace:
 skb_headlen(NULL skb)
 skb_segment
 tcp_gso_segment
 tcp4_gso_segment
 inet_gso_segment
 skb_mac_gso_segment
 __skb_gso_segment
 skb_gso_segment
 validate_xmit_skb
 validate_xmit_skb_list
 sch_direct_xmit
 qdisc_restart
 __qdisc_run
 qdisc_run
 net_tx_action

Fix: Add NAPI_GRO_CB(skb)->flush validation to the early-return check in
skb_gro_receive_list(), matching the defensive programming pattern of
skb_gro_receive().

Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Cc: stable@vger.kernel.org
Signed-off-by: Shiming Cheng <shiming.cheng@mediatek.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260709014704.3625-1-shiming.cheng@mediatek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/gro.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -229,7 +229,9 @@ done:
 
 int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
 {
-	if (unlikely(p->len + skb->len >= 65536))
+	/* make sure to check flush flag and to not merge */
+	if (unlikely(p->len + skb->len >= 65536 ||
+		     NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
 
 	if (!pskb_may_pull(skb, skb_gro_offset(skb))) {


