Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA881A76A5;
	Tue, 30 Jul 2024 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360672; cv=none; b=lfj4Q7h6fizvtSZVesIcy2CujQFUS65r/756mgLZoo67qHktEWoblwoNpN/G+rFBW1zp6W7dxHxSKYap4vcf5cHN0d//PzwBBA6WLWOAuEZTOJJbpz7cyuVrvCk/YrmUwOCwVMRO5ugXo4t4BaCOu7XneG0rImAcwq7vUfBgoA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360672; c=relaxed/simple;
	bh=ZwUqdnhGuaM0RMZ0wDU5po8he5SH3ZdN96ocPz++W/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksQEwlHIcQhugtLTqllJ12eta9mujo9iSrNYeSiBuXQ0T2e0FxxZaZbU8ZTwHs759yuVWjbjkU9vUegWchJJ/Jf5ug+McPNV75PCwozTSNxssgWBlqcBc87v8AWST7EeFa633kB+I1wniSKX5UEuwp7t3EFSntYFVxReLDBXBWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CK9qqvat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CK9qqvat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A801C32782;
	Tue, 30 Jul 2024 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360672;
	bh=ZwUqdnhGuaM0RMZ0wDU5po8he5SH3ZdN96ocPz++W/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CK9qqvat5OVFwCdUOUxsdfPdyOWcZ+hREzkJFQf32JHkSlgvmiXh2oGXZqKo18wDH
	 MettctjIUqLlmdMKOQO895t+vPYQadKXs4QcLii9Mmzv6MWk8eUg4lu7+b1HzYx18R
	 t8DEiQGTsr58OYjIuWDxuiQfnMUUlIx5UdgjKXak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Schindel <mail@arctic-alpaca.de>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 772/809] xsk: Require XDP_UMEM_TX_METADATA_LEN to actuate tx_metadata_len
Date: Tue, 30 Jul 2024 17:50:48 +0200
Message-ID: <20240730151755.459830192@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit d5e726d9143c5624135f5dc9e4069799adeef734 ]

Julian reports that commit 341ac980eab9 ("xsk: Support tx_metadata_len")
can break existing use cases which don't zero-initialize xdp_umem_reg
padding. Introduce new XDP_UMEM_TX_METADATA_LEN to make sure we
interpret the padding as tx_metadata_len only when being explicitly
asked.

Fixes: 341ac980eab9 ("xsk: Support tx_metadata_len")
Reported-by: Julian Schindel <mail@arctic-alpaca.de>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/20240713015253.121248-2-sdf@fomichev.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/xsk-tx-metadata.rst | 16 ++++++++++------
 include/uapi/linux/if_xdp.h                  |  4 ++++
 net/xdp/xdp_umem.c                           |  9 ++++++---
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/xsk-tx-metadata.rst b/Documentation/networking/xsk-tx-metadata.rst
index bd033fe95cca5..e76b0cfc32f7d 100644
--- a/Documentation/networking/xsk-tx-metadata.rst
+++ b/Documentation/networking/xsk-tx-metadata.rst
@@ -11,12 +11,16 @@ metadata on the receive side.
 General Design
 ==============
 
-The headroom for the metadata is reserved via ``tx_metadata_len`` in
-``struct xdp_umem_reg``. The metadata length is therefore the same for
-every socket that shares the same umem. The metadata layout is a fixed UAPI,
-refer to ``union xsk_tx_metadata`` in ``include/uapi/linux/if_xdp.h``.
-Thus, generally, the ``tx_metadata_len`` field above should contain
-``sizeof(union xsk_tx_metadata)``.
+The headroom for the metadata is reserved via ``tx_metadata_len`` and
+``XDP_UMEM_TX_METADATA_LEN`` flag in ``struct xdp_umem_reg``. The metadata
+length is therefore the same for every socket that shares the same umem.
+The metadata layout is a fixed UAPI, refer to ``union xsk_tx_metadata`` in
+``include/uapi/linux/if_xdp.h``. Thus, generally, the ``tx_metadata_len``
+field above should contain ``sizeof(union xsk_tx_metadata)``.
+
+Note that in the original implementation the ``XDP_UMEM_TX_METADATA_LEN``
+flag was not required. Applications might attempt to create a umem
+with a flag first and if it fails, do another attempt without a flag.
 
 The headroom and the metadata itself should be located right before
 ``xdp_desc->addr`` in the umem frame. Within a frame, the metadata
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index d316984104107..42ec5ddaab8dc 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -41,6 +41,10 @@
  */
 #define XDP_UMEM_TX_SW_CSUM		(1 << 1)
 
+/* Request to reserve tx_metadata_len bytes of per-chunk metadata.
+ */
+#define XDP_UMEM_TX_METADATA_LEN	(1 << 2)
+
 struct sockaddr_xdp {
 	__u16 sxdp_family;
 	__u16 sxdp_flags;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index caa340134b0e1..9f76ca591d54f 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -151,6 +151,7 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 #define XDP_UMEM_FLAGS_VALID ( \
 		XDP_UMEM_UNALIGNED_CHUNK_FLAG | \
 		XDP_UMEM_TX_SW_CSUM | \
+		XDP_UMEM_TX_METADATA_LEN | \
 	0)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
@@ -204,8 +205,11 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;
 
-	if (mr->tx_metadata_len >= 256 || mr->tx_metadata_len % 8)
-		return -EINVAL;
+	if (mr->flags & XDP_UMEM_TX_METADATA_LEN) {
+		if (mr->tx_metadata_len >= 256 || mr->tx_metadata_len % 8)
+			return -EINVAL;
+		umem->tx_metadata_len = mr->tx_metadata_len;
+	}
 
 	umem->size = size;
 	umem->headroom = headroom;
@@ -215,7 +219,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->pgs = NULL;
 	umem->user = NULL;
 	umem->flags = mr->flags;
-	umem->tx_metadata_len = mr->tx_metadata_len;
 
 	INIT_LIST_HEAD(&umem->xsk_dma_list);
 	refcount_set(&umem->users, 1);
-- 
2.43.0



