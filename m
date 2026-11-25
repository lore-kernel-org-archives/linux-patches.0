Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621376;
	b=Taps0AMq4CXNb6o4bsIS6kMYSlKwSFGsEiYdPPcgbkpf2MwK6Vyr+JRttLhtolwF65R3
	 BbjocSH3nsXG3AYe2332r3gq+6YqXlGJlfo7DF18l5UDOkVdYyxObnZZFYvq3vFDF9OrR
	 3YgvpVlXMYsLtUZnTOcQUldduZrNtNCrvCehM2bfgVk5W8ld37Q4gOrc272iAk80Bm/eq
	 6ZXFkwHhL4ASRG01+VAirFk+RlDPds7rL6QidVOVuAyZrEx424OXItLgayuG2ymb4wwlG
	 syXpG+NSVW172TskDkBxqpDYvjEHTe0rgG1STCiGiL4lqY2oLZOvul4qMs08elDI97A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aY+BKjv/UQpElXEgx4EBZrh/oUZfqtPFsahyRY/Fgmk=;
	b=BMSfEgJ+hRI69MItINPwwgBHFYeMGOL+19e6hrNDXNhKU2IvnQXQBSoVaJ6bz1adywZD
	 8t4ekYVbFdJSmBFgVNm5Hy0+BVNwsVKNKmWXCLGgEuYk+z21Z6f8+zubmGplNrBPRaPnu
	 YS3J30ND71kSGPXwPYlKtB8/5MMnLgcFsaHRxY0qeNoqpkpBN62mA+JHl+7322ht5BXdb
	 Z3mDsK9icb50t0R03gQPHyb+0NzOtApGyZFZfVs9FBaabREAEOOX7l8aJLxsDhwvMfaHR
	 dp3vzUTNskAlAsUIDCMvReK9hgd6dLaiRx9ZBVc09Jv3HxoqT3F8a8kEpkQZwOovTcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhov1oTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AE0606BF6A;
	Wed, 25 Nov 2026 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhov1oTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E664F1F000E1;
	Wed, 25 Nov 2026 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621376;
	bh=aY+BKjv/UQpElXEgx4EBZrh/oUZfqtPFsahyRY/Fgmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhov1oTBsel32p/5mNK/6mNXxtWNJXzNSGtpuR0fIA4vH77tNWpCy1U4v43W+4Mxv
	 mMrlhBa8D5qj1VBlQBd/5W27C7Q1780lTlN5SzxKtMnNYYjGoyIeaQFPsxIpG3gYCz
	 /Mf+eyawnnPu9vqWPH6slAUl2hCTxupG2bwGG/d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	sungbyeongchan <tjdqudcks0424@naver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/990] virtio_ring: use shadow flags when detaching split descriptors
Date: Wed, 25 Nov 2026 15:26:11 +0100
Message-ID: <20261125143826.872138684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sungbyeongchan <tjdqudcks0424@naver.com>

[ Upstream commit e498eb93f961db1a1dfdabd373500f0d4019c9a4 ]

Split virtqueues save descriptor flags and next indexes in desc_extra
before publishing descriptors to the device. The detach path uses the
shadow next index, but decides whether to continue by rereading the NEXT
flag from the shared descriptor.

Use the shadow flags for the continuation decision as well. This keeps
all detach metadata in the same driver-owned snapshot and avoids an
unnecessary shared-ring read.

Fixes: 72b5e8958738 ("virtio-ring: store DMA metadata in desc_extra for split virtqueue")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
Signed-off-by: sungbyeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261008050423.32221-1-tjdqudcks0424@naver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 09b9b6a17f5f0..089a3dc2e626f 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -783,7 +783,6 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 {
 	struct vring_desc_extra *extra;
 	unsigned int i;
-	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
 
 	/* Clear data ptr. */
 	vq->split.desc_state[head].data = NULL;
@@ -793,7 +792,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	/* Put back on free list: unmap first-level descriptors and find end */
 	i = head;
 
-	while (vq->split.vring.desc[i].flags & nextflag) {
+	while (extra[i].flags & VRING_DESC_F_NEXT) {
 		i = vring_unmap_one_split(vq, &extra[i]);
 		vq->vq.num_free++;
 	}
-- 
2.53.0



