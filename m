Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ABF20320
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arWoONe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08799C433C9;
	Mon,  6 Nov 2023 13:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276615;
	bh=AJzdowyFu+Y/qtH/Eb8B7P3qDIfnM1Wku+BEnGJn5wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arWoONe/0ZV30/jg5+0QM7nzKBFJZyM91n2i2L2U8kGZkNIC8OvcIyKJuNB0+5GOD
	 6vrp8KhJyUrucwX+9Oc9G27uv/GinqYwaLfPwIk5Qa6XBAcYbVxscobaLdb/Z81rkn
	 xK+knH4MvLCSzjBwh4rZvfGL4rfkASLvfZV47ON4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karolina Stolarek <karolina.stolarek@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 39/88] drm/ttm: Reorder sys manager cleanup step
Date: Mon,  6 Nov 2023 14:03:33 +0100
Message-ID: <20231106130307.251041108@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karolina Stolarek <karolina.stolarek@intel.com>

[ Upstream commit 3b401e30c249849d803de6c332dad2a595a58658 ]

With the current cleanup flow, we could trigger a NULL pointer
dereference if there is a delayed destruction of a BO with a
system resource that gets executed on drain_workqueue() call,
as we attempt to free a resource using an already released
resource manager.

Remove the device from the device list and drain its workqueue
before releasing the system domain manager in ttm_device_fini().

Signed-off-by: Karolina Stolarek <karolina.stolarek@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231016121525.2237838-1-karolina.stolarek@intel.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_device.c b/drivers/gpu/drm/ttm/ttm_device.c
index 7726a72befc54..d48b39132b324 100644
--- a/drivers/gpu/drm/ttm/ttm_device.c
+++ b/drivers/gpu/drm/ttm/ttm_device.c
@@ -232,10 +232,6 @@ void ttm_device_fini(struct ttm_device *bdev)
 	struct ttm_resource_manager *man;
 	unsigned i;
 
-	man = ttm_manager_type(bdev, TTM_PL_SYSTEM);
-	ttm_resource_manager_set_used(man, false);
-	ttm_set_driver_manager(bdev, TTM_PL_SYSTEM, NULL);
-
 	mutex_lock(&ttm_global_mutex);
 	list_del(&bdev->device_list);
 	mutex_unlock(&ttm_global_mutex);
@@ -243,6 +239,10 @@ void ttm_device_fini(struct ttm_device *bdev)
 	drain_workqueue(bdev->wq);
 	destroy_workqueue(bdev->wq);
 
+	man = ttm_manager_type(bdev, TTM_PL_SYSTEM);
+	ttm_resource_manager_set_used(man, false);
+	ttm_set_driver_manager(bdev, TTM_PL_SYSTEM, NULL);
+
 	spin_lock(&bdev->lru_lock);
 	for (i = 0; i < TTM_MAX_BO_PRIORITY; ++i)
 		if (list_empty(&man->lru[0]))
-- 
2.42.0



