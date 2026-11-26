Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704121;
	b=WEXtoSEHIT5qaeN55QPQmz7Y1BCDKtykAnaPvSKhUviFDuMQwCDhZjPRaB3fWgaa0I52
	 +15qRXyFE5VjZe3N79CELxYqgdcbXNVdhIcCo5OIN5Cb4Y10hzI/ZzIVugTHkKNAwBa7t
	 gM+jZKcUsnuEyoaPX0queAsmsAEuYRvY4DrsBqgQ9pHltX/yjITgR+G7Ifnn+HPy0MHMA
	 ssxHH9zB9tBkT7lBsWnL1PR65joPmoqmatPj663IbJtfeUj6NX2vPhyKk8QP9cg6qSPRp
	 776RMsQ+5GzgqyzaXHiM8WMv9vDzEGlzw9tpV520R+QPip1pLvasxpJ+5HhP9aCReLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B7qHvX5WCOxKu6d/QG4iMmIEXmurH0pWk+i1prjE1vc=;
	b=DuuNhOAsqmhJw+PWOaf72+zIlHel2CwvFrk3ToCZlyZSS/GnL/ZB+FogXiqc8jETRF+8
	 Cy0a4qLDMm3eAAKVpLmDTYf1gw1Tv1RXZxm8CZRnmuzwNCNkwODRgpILvQp7+3fa4absa
	 +kXqcrTIAf17RW4r7Bq8jMA8Ae4YAa0ONsyTFZac3aRzT8DwNoNCab17qzJq1T0haDMfA
	 TBLhNaQNgwlfW3JRFnHUnIZ9nS1bfv0p2CPLtlWHGlkgmq4CPnYZ8UI4v1mjKVKp9QgDL
	 qouhsRalcY+YN4RWLxQi0+Oyd6Y8iKVTzAvkdrbQ3oMtkK96FmMOxXOWDPKYjj9GRog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z1iKmPU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414FC606A32D;
	Thu, 26 Nov 2026 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1iKmPU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA361F000E0;
	Thu, 26 Nov 2026 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704121;
	bh=B7qHvX5WCOxKu6d/QG4iMmIEXmurH0pWk+i1prjE1vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1iKmPU/PmwKm0YJLGmHCK10W4BfcKeud94YTF2x+BnPwJzsWcpJJFX7dYNoMWUM5
	 CSy+B+CNcAeGjEI8mZN3KBJM0dt1nJ+kp/5cnPUoptj8Hp/Qe9uHgZ0RcMpjKp1Q3A
	 NNBvDtOKKwcBXxZQzX60hVEcaE/+rBRL11SfSTeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhenwei pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/265] virtio-blk: fix implicit overflow on virtio_max_dma_size
Date: Thu, 26 Nov 2026 15:35:44 +0100
Message-ID: <20261126143606.074594701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhenwei pi <pizhenwei@bytedance.com>

commit fafb51a67fb883eb2dde352539df939a251851be upstream.

The following codes have an implicit conversion from size_t to u32:
(u32)max_size = (size_t)virtio_max_dma_size(vdev);

This may lead overflow, Ex (size_t)4G -> (u32)0. Once
virtio_max_dma_size() has a larger size than U32_MAX, use U32_MAX
instead.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Message-Id: <20230904061045.510460-1-pizhenwei@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 8a492dd94fa11..288aeeefb6b3d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -706,6 +706,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	u32 v, blk_size, max_size, sg_elems, opt_io_size;
 	u16 min_io_size;
 	u8 physical_block_exp, alignment_offset;
+	size_t max_dma_size;
 
 	if (!vdev->config->get) {
 		dev_err(&vdev->dev, "%s failure: config access disabled\n",
@@ -810,7 +811,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 	/* No real sector limit. */
 	blk_queue_max_hw_sectors(q, -1U);
 
-	max_size = virtio_max_dma_size(vdev);
+	max_dma_size = virtio_max_dma_size(vdev);
+	max_size = max_dma_size > U32_MAX ? U32_MAX : max_dma_size;
 
 	/* Host can optionally specify maximum segment size and number of
 	 * segments. */
-- 
2.53.0



