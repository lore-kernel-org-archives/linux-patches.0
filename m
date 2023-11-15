Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223EE3DBB5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNCPmLl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BB5C433C9;
	Wed, 15 Nov 2023 22:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085880;
	bh=NbVHU5aTAMqcqo5HWYXtnWfy0MY+iit64pmtuBhATyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNCPmLl7s5GTwxgoyscn/r0OPyeB0e+Lnftsw7AaY9JPXJChKB1HWXC68oTo+MHGS
	 LZfibrV3QhicnqdNQksI23Pj/fICpsCGd2UOHscMhoquDm3K8VF80p7lGIV1Jj16rB
	 H387cPPOHP3KiGQcPDWtCjOhoBAIPI0gXqYSzo78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Kurzinger <ekurzinger@nvidia.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/119] drm/syncobj: fix DRM_SYNCOBJ_WAIT_FLAGS_WAIT_AVAILABLE
Date: Wed, 15 Nov 2023 17:01:43 -0500
Message-ID: <20231115220136.178798376@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Kurzinger <ekurzinger@nvidia.com>

[ Upstream commit 101c9f637efa1655f55876644d4439e552267527 ]

If DRM_IOCTL_SYNCOBJ_TIMELINE_WAIT is invoked with the
DRM_SYNCOBJ_WAIT_FLAGS_WAIT_AVAILABLE flag set but no fence has yet been
submitted for the given timeline point the call will fail immediately
with EINVAL. This does not match the intended behavior where the call
should wait until the fence has been submitted (or the timeout expires).

The following small example program illustrates the issue. It should
wait for 5 seconds and then print ETIME, but instead it terminates right
away after printing EINVAL.

  #include <stdio.h>
  #include <fcntl.h>
  #include <time.h>
  #include <errno.h>
  #include <xf86drm.h>
  int main(void)
  {
      int fd = open("/dev/dri/card0", O_RDWR);
      uint32_t syncobj;
      drmSyncobjCreate(fd, 0, &syncobj);
      struct timespec ts;
      clock_gettime(CLOCK_MONOTONIC, &ts);
      uint64_t point = 1;
      if (drmSyncobjTimelineWait(fd, &syncobj, &point, 1,
                                 ts.tv_sec * 1000000000 + ts.tv_nsec + 5000000000, // 5s
                                 DRM_SYNCOBJ_WAIT_FLAGS_WAIT_AVAILABLE, NULL)) {
          printf("drmSyncobjTimelineWait failed %d\n", errno);
      }
  }

Fixes: 01d6c3578379 ("drm/syncobj: add support for timeline point wait v8")
Signed-off-by: Erik Kurzinger <ekurzinger@nvidia.com>
Reviewed by: Simon Ser <contact@emersion.fd>
Signed-off-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/1fac96f1-2f3f-f9f9-4eb0-340f27a8f6c0@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_syncobj.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index e558381c4c96e..8b155e3377cfe 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -921,7 +921,8 @@ static signed long drm_syncobj_array_wait_timeout(struct drm_syncobj **syncobjs,
 		fence = drm_syncobj_fence_get(syncobjs[i]);
 		if (!fence || dma_fence_chain_find_seqno(&fence, points[i])) {
 			dma_fence_put(fence);
-			if (flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT) {
+			if (flags & (DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT |
+				     DRM_SYNCOBJ_WAIT_FLAGS_WAIT_AVAILABLE)) {
 				continue;
 			} else {
 				timeout = -EINVAL;
-- 
2.42.0



