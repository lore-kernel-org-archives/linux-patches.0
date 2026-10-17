Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F10A39B4A5;
	Sat, 17 Oct 2026 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254798; cv=none; b=SRWZcr5gFDhNjeNLS1SUAzaqVz00rjC3nMKZk5F16UdWxCHPO7hjHNw5hfDHzBL/r8gaiYKVLK4oEPvf2/kMqoWvfcm+yejvI4I9D5N0F7z/DKTfSPOIRItNbyhSKBbE9pkVes2CWerDOs2grrbbaI09f4QOyqH3f+y4jJuFt+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254798; c=relaxed/simple;
	bh=fL9wiEk9lyVa84I54PF16WwP6F6mygaXv4fCoHK32Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJND5MAq/xVYoILIT4EZK2THEC8pC/2HT8Gaj3gPM09N4lzRGP9dzld6ppNT9xYsHLb4v7/2sI9B6mPk2ENIlgXIyeTeo3W2814+Qz5gOEk/KjkPF/b7hu4Qb3i6aRjsAW7YHWE+d4hrClQcWJ/hLtDLDrQTCoEx5XET8rslgZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPoTkvYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPoTkvYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C04D1F000C4;
	Sat, 17 Oct 2026 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254797;
	bh=T0RBsl/mbkHrLlZjQPK66d1Mo/6nTuVncWIcjP9n/Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPoTkvYQ1loW93W8q2SMrZ+QNzIQyHe+v/p3g3ty/5ayKEeD4TWKA/wHQlzK2QqhA
	 z/0kPQbesB7nA76JcvGb8CXYLTasYGECYu4+m9RerLwMKlSNqThvC7mqVim7HY+jsi
	 6QKuFyhJf7TesduGX1EJbeQ1gZbB39jJ/jVsBfZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 558/869] tap: Keep hdr_len in tap_get_user()
Date: Sat, 17 Oct 2026 17:56:39 +0200
Message-ID: <20261017160051.386927646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 018bc2941a967..d5a1ab9b2a37d 100644
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



