Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47081EA8F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AD2C433C8;
	Tue,  1 Aug 2023 09:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883446;
	bh=Z/quAPdbPq9ut+BE9T7MZZjmWh6JfpZ2WFydCUkmnwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuQdownuI5A2kfERKoSrfUHRaD+GSTkC5vbgYYeH7sI56ww9b8kaPwM8qEKyoxuNe
	 DGwL5m6tfYwkVG0OBV8hciS9jP3/YCyxMcuKdSjTV8S1X7cYZnogHoHd10Z2kV1uSA
	 gCe2wyxGEWHyV0h74ta7DrgkRIsk3OZVDYyL4x88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Jindong Yue <jindong.yue@nxp.com>
Subject: [PATCH 6.4 239/239] dma-buf: fix an error pointer vs NULL bug
Date: Tue,  1 Aug 2023 11:21:43 +0200
Message-ID: <20230801091934.678895830@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 00ae1491f970acc454be0df63f50942d94825860 upstream.

Smatch detected potential error pointer dereference.

    drivers/gpu/drm/drm_syncobj.c:888 drm_syncobj_transfer_to_timeline()
    error: 'fence' dereferencing possible ERR_PTR()

The error pointer comes from dma_fence_allocate_private_stub().  One
caller expected error pointers and one expected NULL pointers.  Change
it to return NULL and update the caller which expected error pointers,
drm_syncobj_assign_null_handle(), to check for NULL instead.

Fixes: f781f661e8c9 ("dma-buf: keep the signaling time of merged fences v3")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/b09f1996-3838-4fa2-9193-832b68262e43@moroto.mountain
Cc: Jindong Yue <jindong.yue@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence.c   |    2 +-
 drivers/gpu/drm/drm_syncobj.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -160,7 +160,7 @@ struct dma_fence *dma_fence_allocate_pri
 
 	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
 	if (fence == NULL)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	dma_fence_init(fence,
 		       &dma_fence_stub_ops,
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -355,8 +355,8 @@ static int drm_syncobj_assign_null_handl
 {
 	struct dma_fence *fence = dma_fence_allocate_private_stub(ktime_get());
 
-	if (IS_ERR(fence))
-		return PTR_ERR(fence);
+	if (!fence)
+		return -ENOMEM;
 
 	drm_syncobj_replace_fence(syncobj, fence);
 	dma_fence_put(fence);


