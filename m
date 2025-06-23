Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A0416419;
	Mon, 23 Jun 2025 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685986; cv=none; b=Bno3EeiClmJGjcIj0xQmzBLjYjbuQvAzMl90mdYXCoY6TnwdrFrIyhBjnoNWPLaokdqKyzCIjKxKLmbE9UXAeu7CFGGIzRMoF7JjOezqhwQt6NuKd8lrDvugoce7BgS+kLI7f4pO4yhQ4fPdGE/LFdEpljcrE+5dv0ZTv2Av+vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685986; c=relaxed/simple;
	bh=Lj7QYC67anznBAgT7PNaChcPOtF+N0pCEtuYE3qLt9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8y9ekyZqz1ci48w9NBtsLym1WwVScDeaoAyG7MDzh3suFKn1WIrY5fh7VwSnsdS6x327HUbnD8P1EYwhltw3Aeh5Ip3wVY5kFRQwQlG6XsQRhDvY9ZJDkPBTdvqXjavg4Y7tYEAtD8d0ZkUW/B5u06oGnyzyGCvLU31hms1DLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oysd/dcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oysd/dcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B5AC4CEEA;
	Mon, 23 Jun 2025 13:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685986;
	bh=Lj7QYC67anznBAgT7PNaChcPOtF+N0pCEtuYE3qLt9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oysd/dcWA+KoJ38b8uO0MUqczSF9DMyu5SucxrDmUzdiH8XbBDmB2CiK3HxEQun39
	 424Sw9xrbVfU6Il5riXt9J4WDg4IkxBw657DsM20xoqyQr+lNk1VvNdzy7l04kRNRo
	 muG13NhcM3i8iMLDuOI7wiehlaomj7dzB+qJzOkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/411] vfio/type1: Fix error unwind in migration dirty bitmap allocation
Date: Mon, 23 Jun 2025 15:03:28 +0200
Message-ID: <20250623130634.922621630@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 4518e5a60c7fbf0cdff393c2681db39d77b4f87e ]

When setting up dirty page tracking at the vfio IOMMU backend for
device migration, if an error is encountered allocating a tracking
bitmap, the unwind loop fails to free previously allocated tracking
bitmaps.  This occurs because the wrong loop index is used to
generate the tracking object.  This results in unintended memory
usage for the life of the current DMA mappings where bitmaps were
successfully allocated.

Use the correct loop index to derive the tracking object for
freeing during unwind.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://lore.kernel.org/r/20250521034647.2877-1-lirongqing@baidu.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 66bbb125d7615..6a89bbec738f6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -303,7 +303,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 			struct rb_node *p;
 
 			for (p = rb_prev(n); p; p = rb_prev(p)) {
-				struct vfio_dma *dma = rb_entry(n,
+				struct vfio_dma *dma = rb_entry(p,
 							struct vfio_dma, node);
 
 				vfio_dma_bitmap_free(dma);
-- 
2.39.5



