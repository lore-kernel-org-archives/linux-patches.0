Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CAB471D0B;
	Thu, 20 Aug 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247774; cv=none; b=fC+Ti4a0ROija/PtHiVLY+e+UD7x/OtpvPxS7qwFqowtUkS6TchbOQgs+5hQNfb2xnw6+A3ugJuerUJd1cpuXq6+1M3sya6+7BW49Uth/sFGHCvs/Z4uOwf25I2omNiPrFhfqbrzhh9TSdJhKtwSnaXMTfzczqwI6yDhV4xWh4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247774; c=relaxed/simple;
	bh=wBvkCNihcQ54gRcGgxOieI1qdvq5kRWg/r2S3k8FvdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJfF8NNkx9vcM4YolkUuQL7bW9ySd7LwukixsKNiyHcCZ+CCoYJdyIls4e8UYQPe3ipbdOJ/2/ANwvf4QSIpO+A1VyvxYvCex9USfoiMOVrU7IO7uuAU/wW4XnhqaVlfoUsY7n9jliItJyvRMbQWmwn39AEygIOFD1FglkIv4yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtMFLeIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtMFLeIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22AE1F000E9;
	Thu, 20 Aug 2026 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247773;
	bh=Nexh8REUQeed2RWLAnmFnaxadtRE4unNDJFAULpPPOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qtMFLeIsl2J7RtJ/x76I9BKrjS5LJhI4E8uX8J3TnjB5SMj/oRWTxWwRhzQ/QlTfT
	 GUVeSFc/pZvL8wWMvOkxfyX/eDc3lpAsW1snZIVf9kyGNa9UE2kiLEKD6/R+nP2vsq
	 3zeyNFUT8yKLObpXgGB39GWkQq7Ae9n6ax4EYjiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/166] veth: convert frag_list skbs before running XDP
Date: Thu, 20 Aug 2026 16:56:14 +0200
Message-ID: <20260820145214.624047830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit d0d6415963040c401e7a7e4e482a698ba52448cb ]

A frag_list skb can reach veth with data_len set but nr_frags zero.
veth_convert_skb_to_xdp_buff() only converts skbs that are shared,
locked, have frags[], or do not have enough headroom. It later uses
skb_is_nonlinear() to decide whether to set XDP_FLAGS_HAS_FRAGS and
xdp_frags_size.

That exposes frag_list data to XDP as if it were stored in frags[], but
frags[] is empty. AF_XDP copy mode can then trust the bogus XDP fragment
metadata, walk an empty fragment entry, and crash in memcpy() from
__xsk_rcv().

Route non-linear skbs through skb_pp_cow_data() before exposing them to
XDP, and only advertise XDP frags when the resulting skb has frags[].
skb_copy_bits() already handles frag_list input, and skb_pp_cow_data()
builds frags[] output with skb_add_rx_frag(), which is the
representation XDP multi-buffer expects.

Fixes: 718a18a0c8a6 ("veth: Rework veth_xdp_rcv_skb in order to accept non-linear skb")
Cc: stable@vger.kernel.org
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260722191925.2192070-1-matt@readmodwrite.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/veth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -731,7 +731,7 @@ static int veth_convert_skb_to_xdp_buff(
 	u32 frame_sz;
 
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
-	    skb_shinfo(skb)->nr_frags ||
+	    skb_is_nonlinear(skb) ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
 		u32 size, len, max_head_size, off;
 		struct sk_buff *nskb;
@@ -808,7 +808,7 @@ static int veth_convert_skb_to_xdp_buff(
 	xdp_prepare_buff(xdp, skb->head, skb_headroom(skb),
 			 skb_headlen(skb), true);
 
-	if (skb_is_nonlinear(skb)) {
+	if (skb_shinfo(skb)->nr_frags) {
 		skb_shinfo(skb)->xdp_frags_size = skb->data_len;
 		xdp_buff_set_frags_flag(xdp);
 	} else {


