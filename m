Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195454C3D4;
	Mon,  8 Jan 2024 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPnkK6kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813F8C433C8;
	Mon,  8 Jan 2024 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726587;
	bh=Mk9hxKhZp79Kp1gJXmjwwqgqOBa2rCl9A3I+vZ9HIBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPnkK6khWXa+krKNQJeD9dYYt0iitc0TRonTG8yd1owuIaEM4LMOP4ohQS/n4wgat
	 fY42V0qVFmpmGgvnmTmYVGctSlmBZRY2R4oFdKX+BqTGMV1ECzJPDQAAotv3OZvksF
	 OyPgcQq4HfXUIaPQy60ebZ3hS3431Vvkf3PHouxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/124] accel/qaic: Fix GEM import path code
Date: Mon,  8 Jan 2024 16:07:21 +0100
Message-ID: <20240108150603.674272143@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>

[ Upstream commit c8b6f4ad2ff9c6d88cdeb9acf16d0c4a323dd499 ]

Do not modify the size of dmabuf as it is immutable.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Signed-off-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231208163101.1295769-2-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index f4b06792c6f1c..ed1a5af434f24 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -766,7 +766,6 @@ struct drm_gem_object *qaic_gem_prime_import(struct drm_device *dev, struct dma_
 	struct dma_buf_attachment *attach;
 	struct drm_gem_object *obj;
 	struct qaic_bo *bo;
-	size_t size;
 	int ret;
 
 	bo = qaic_alloc_init_bo();
@@ -784,13 +783,12 @@ struct drm_gem_object *qaic_gem_prime_import(struct drm_device *dev, struct dma_
 		goto attach_fail;
 	}
 
-	size = PAGE_ALIGN(attach->dmabuf->size);
-	if (size == 0) {
+	if (!attach->dmabuf->size) {
 		ret = -EINVAL;
 		goto size_align_fail;
 	}
 
-	drm_gem_private_object_init(dev, obj, size);
+	drm_gem_private_object_init(dev, obj, attach->dmabuf->size);
 	/*
 	 * skipping dma_buf_map_attachment() as we do not know the direction
 	 * just yet. Once the direction is known in the subsequent IOCTL to
-- 
2.43.0



