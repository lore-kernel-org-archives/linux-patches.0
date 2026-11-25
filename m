Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621370;
	b=i1bdOw+18Et/zuC+jltdIjaKDUukAC9NMEdflxwCH31cVwVi6/Nu2mhwpnAU1EIphbd/
	 dSB/iQkweLZJaJsxU/gPZY1cX3R7bObfZVnMBwpY/EdexV/N9hYyC9OvdcrhTapxWEAUT
	 dZlVlgKDmZnJqgk0r9hKHBPv9SnqOqB2W4U00bWwfozX684vqF/lhlFBmgpIubbaffO2Z
	 L8Dcc69HXPiFZ3iZfbmvoWWgoXKXhnqzI86TtxGefZjsmhoEpR+CLb8CbC/mUXyo6sb8A
	 /M1hfXEFBoUL7TFVJWKQE+RLNp2wwgE2CAWWeW7c2vyM9V+fTC4TpkE0KvEOmbyyGuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fxx3P5v/DGqaWAcP4lW4GpXM5ozUbCvf+FlB5pfJGmg=;
	b=jrVc3Z43ZWIBkeWk+oZgYmxYmF66hYT4h6ieZgJD0amUokU5OdomHZkkmf4E+5DqQ/YW
	 C7Ukx1JZQ9g/BwAzb1T6YRprg4RmqiTowZZXpVvRK+5osAPPKfzXTJE3uEFfTSDTRwRd9
	 7L20ew9R9BxcWhU90kDRW0GNfr1XoNb7GIC68eDkmvkmili7oiRZRUfN+AXV/dtee0GrO
	 00tSAo5mHHiMvb90GZoIuC2MSdJ25LljCsxd4Uid4dWDw467+mkeEUd6rbC3clAW9UL8g
	 gYjbX4M3kjQSCeln0ha0bufqqDi272ddHTFGxVO2xAIl+zpp9p7dwm2ABityDjsEuwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLaSshcZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B225C606A68C;
	Wed, 25 Nov 2026 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLaSshcZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C781F000ED;
	Wed, 25 Nov 2026 15:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621370;
	bh=Fxx3P5v/DGqaWAcP4lW4GpXM5ozUbCvf+FlB5pfJGmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLaSshcZ2Pbte8xaxV/i2mObfEsza1L2LlTaCEmZ44WOCWu5wL1hPGuoOMZ24adwE
	 O/q9vBt5OuVaqx8S0uKqUDM5r9Eaf3DUvOPzX9xgMrQkJ+UUpXOYu/nnSJ/CD2DACw
	 jmYVjpxLAVnqVlftruohGfhFvFIZLjppWESyOWDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangdongchuan <zhangdongchuan@eswincomputing.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/990] virtio_ring: code cleanup in detach_buf_split
Date: Wed, 25 Nov 2026 15:26:09 +0100
Message-ID: <20261125143826.824979436@linuxfoundation.org>
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

From: zhangdongchuan@eswincomputing.com <zhangdongchuan@eswincomputing.com>

[ Upstream commit 4b7bf8d5503287ed3bd661207b9d061999ac494e ]

Since the return value of vring_unmap_one_split() is exactly
vq->split.desc_extra[i].next, 'i = vq->split.desc_extra[i].next' is
redundant. Assign vring_unmap_one_split() to i instead.

Since vq->split.desc_extra is assigned to extra, use extra[i].next
instead of vq->split.desc_extra[i].next to improve readability.

No change in functionality.

Signed-off-by: zhangdongchuan <zhangdongchuan@eswincomputing.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <202511261140162936986@eswincomputing.com>
Stable-dep-of: e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5c0139f3b9811..c51a6fc187f26 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -764,13 +764,12 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	i = head;
 
 	while (vq->split.vring.desc[i].flags & nextflag) {
-		vring_unmap_one_split(vq, &extra[i]);
-		i = vq->split.desc_extra[i].next;
+		i = vring_unmap_one_split(vq, &extra[i]);
 		vq->vq.num_free++;
 	}
 
 	vring_unmap_one_split(vq, &extra[i]);
-	vq->split.desc_extra[i].next = vq->free_head;
+	extra[i].next = vq->free_head;
 	vq->free_head = head;
 
 	/* Plus final descriptor */
-- 
2.53.0



