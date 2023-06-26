Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71564134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E801AC433C0;
	Mon, 26 Jun 2023 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803969;
	bh=AlyljVhLcoW6ffreaLuFfYb+N+jU/OaKfpzfPbWU+p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7qWdTc/R8Qu3C+d027ZAI/nz6KpmJ6E5D2sYt0cZgyzug9RZ6op2NNev+MS0ASu2
	 ddj7kIo5H8g+TumoQL9qI9hcnn1o0kNMAId9up3eJlZfrITk5+sNexl+It6yhDuIxm
	 aF73tBDQ1QF4T4KouSenIASQ8SYgPu64VZrILKKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Min Li <lm0963hack@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/41] drm/radeon: fix race condition UAF in radeon_gem_set_domain_ioctl
Date: Mon, 26 Jun 2023 20:12:02 +0200
Message-ID: <20230626180737.722844231@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
References: <20230626180736.243379844@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Min Li <lm0963hack@gmail.com>

[ Upstream commit 982b173a6c6d9472730c3116051977e05d17c8c5 ]

Userspace can race to free the gobj(robj converted from), robj should not
be accessed again after drm_gem_object_put, otherwith it will result in
use-after-free.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index 27d8e7dd2d067..46f7789693ea0 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -377,7 +377,6 @@ int radeon_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	struct radeon_device *rdev = dev->dev_private;
 	struct drm_radeon_gem_set_domain *args = data;
 	struct drm_gem_object *gobj;
-	struct radeon_bo *robj;
 	int r;
 
 	/* for now if someone requests domain CPU -
@@ -390,13 +389,12 @@ int radeon_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 		up_read(&rdev->exclusive_lock);
 		return -ENOENT;
 	}
-	robj = gem_to_radeon_bo(gobj);
 
 	r = radeon_gem_set_domain(gobj, args->read_domains, args->write_domain);
 
 	drm_gem_object_put_unlocked(gobj);
 	up_read(&rdev->exclusive_lock);
-	r = radeon_gem_handle_lockup(robj->rdev, r);
+	r = radeon_gem_handle_lockup(rdev, r);
 	return r;
 }
 
-- 
2.39.2



