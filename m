Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7E73D0903;
	Sat, 17 Oct 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259557; cv=none; b=CdujjvGsXLLrHLwfX9HT/342tIld8Ra62XfuqQkqzCa86Sa7ZLLUAB/nZLJR+b5TyEgQongV64K0H4IXocZfyO3GQ3t4ZDOUCnQ2dcNNbQHXxpBUCWD6v9dqVVZzHekVvk84/v/A+ykGwxRIyO4qO5Sai1nXtAyRmcJ97U9e4/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259557; c=relaxed/simple;
	bh=mUQteCOcMyZsPzyFQiC+ovIXxMvIbeg0JDX8m01nsiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwLX8qCtRT5MhcxgZIdOJDM7SpT0b+TUqsBQUu6eMRBnTtF2hMfRT3Aoq4neH7cuTgmc7FCfgb9bT75ozWhSLb51OdGyLKqS34WwuczDoUxsQrUqQrjjmyUdI6DzCyvYjqBHf86BUAVxGHTL+or9V8InQIfvqraEbLHvyhJoP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qebUf1ex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qebUf1ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9A61F000C4;
	Sat, 17 Oct 2026 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259556;
	bh=p4QBDkZutWVf+p7JDy6ab94ySntXl2zekEoHUz0N2nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qebUf1exYA9++6G69bhUvolnPknJVMvofHAK6Xw4c4vi1Q6LxUUTPmqlsiJoX2bwE
	 DyCo0fuVjpPlhilk9Mt2LCI93vmROlOhobA+TpAA+XsxWTzd57iikGp3yeWPT9pw4Z
	 Pa3gd1GaqrjYQ0+5Lzx9j2lYyno03ZF8oy+iu/5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1253/1674] tap: Keep hdr_len in tap_get_user()
Date: Sat, 17 Oct 2026 17:58:45 +0200
Message-ID: <20261017160503.304800317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akihiko Odaki <akihiko.odaki@daynix.com>

[ Upstream commit 74212f20f366db41dd3148b951284ac38ef9bb10 ]

hdr_len is repeatedly used so keep it in a local variable.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250207-tun-v6-6-fb49cf8b103e@daynix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbb35cbe8db2 ("net: tap: fix wrong transport_header when sending VLAN-tagged frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index d8bcb34236267..63210367cef17 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -645,6 +645,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int err;
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int vnet_hdr_len = 0;
+	int hdr_len = 0;
 	int copylen = 0;
 	int depth;
 	bool zerocopy = false;
@@ -663,13 +664,13 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		if (!copy_from_iter_full(&vnet_hdr, sizeof(vnet_hdr), from))
 			goto err;
 		iov_iter_advance(from, vnet_hdr_len - sizeof(vnet_hdr));
-		if ((vnet_hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-		     tap16_to_cpu(q, vnet_hdr.csum_start) +
-		     tap16_to_cpu(q, vnet_hdr.csum_offset) + 2 >
-			     tap16_to_cpu(q, vnet_hdr.hdr_len))
-			vnet_hdr.hdr_len = cpu_to_tap16(q,
-				 tap16_to_cpu(q, vnet_hdr.csum_start) +
-				 tap16_to_cpu(q, vnet_hdr.csum_offset) + 2);
+		hdr_len = tap16_to_cpu(q, vnet_hdr.hdr_len);
+		if (vnet_hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
+			hdr_len = max(tap16_to_cpu(q, vnet_hdr.csum_start) +
+				      tap16_to_cpu(q, vnet_hdr.csum_offset) + 2,
+				      hdr_len);
+			vnet_hdr.hdr_len = cpu_to_tap16(q, hdr_len);
+		}
 		err = -EINVAL;
 		if (tap16_to_cpu(q, vnet_hdr.hdr_len) > len)
 			goto err;
@@ -682,12 +683,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
 		struct iov_iter i;
 
-		copylen = vnet_hdr.hdr_len ?
-			tap16_to_cpu(q, vnet_hdr.hdr_len) : GOODCOPY_LEN;
-		if (copylen > good_linear)
-			copylen = good_linear;
-		else if (copylen < ETH_HLEN)
-			copylen = ETH_HLEN;
+		copylen = clamp(hdr_len ?: GOODCOPY_LEN, ETH_HLEN, good_linear);
 		linear = copylen;
 		i = *from;
 		iov_iter_advance(&i, copylen);
@@ -697,11 +693,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 
 	if (!zerocopy) {
 		copylen = len;
-		linear = tap16_to_cpu(q, vnet_hdr.hdr_len);
-		if (linear > good_linear)
-			linear = good_linear;
-		else if (linear < ETH_HLEN)
-			linear = ETH_HLEN;
+		linear = clamp(hdr_len, ETH_HLEN, good_linear);
 	}
 
 	skb = tap_alloc_skb(&q->sk, TAP_RESERVE, copylen,
-- 
2.53.0



