Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E20389470;
	Tue, 10 Mar 2026 11:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141220; cv=none; b=afxofMU/eZYWRyPeaMR8rRuVdreT0V9yvAx8gnpcOzLzlwPTjdkStrHXS3gMoT5PTCOme7QkpmvBO9YwuFuj1Vu6ce+CzdtbIUitYd5ItudxSS0jQd+aja+1OO387be3/fYhdl7M0y3cI3SaunOexngUG55DQleHhj8qgvgMF+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141220; c=relaxed/simple;
	bh=zOgiKWF+4/k5ddCa77UtIEthe9Cn46C6XEXxI5Zvqgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgsGGEMFHKr3DNtfz2/rO4bJ9J/yHaH5fthlVCGfGiZ6NeHmq51FJ61FSRePtXI1/EwO+0B/+v++mGuzhiUj8oxHLe3gsovJoqTjzL2cCJkDGLbcQVxgunMLcj908qBUJjEMcBnkSowEKu3AnDt2x4cSrT20GO3jiJDhdQlkEgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pK37AMYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pK37AMYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07402C2BC86;
	Tue, 10 Mar 2026 11:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141220;
	bh=zOgiKWF+4/k5ddCa77UtIEthe9Cn46C6XEXxI5Zvqgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pK37AMYJaiDh574O96QTpWQSRxr+v7VftKcW00nXfi353bbgYUc8RJWzXa3Q0820X
	 V82j4gzcT4HC+Bx27jhwmCQmUasdOASIO4mVm9QD/l3+IbN8Yw1L47erM1C5IICZJw
	 XcW33lumDARv/6d2jDHsUgdCLN1fT02x7aA373WFcm4q+Q7MsFrh5uBVdX71r8/jW4
	 bfeeOC3rZQBYqPGrRD3aw68yipnsV9uG5RR15eO3m6MmCf/X1Dbak569qOLcHUMtUI
	 Xckb+FWitxtkvW1RBBDpJzbmRsVAxr9OqwSoR1I2Ife3VwWXjgqPse6/GU232jDZtK
	 1WQ0yPFPb7mGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Julian Orth <ju.orth@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 222/311] drm/syncobj: Fix handle <-> fd ioctls with dirty stack
Date: Tue, 10 Mar 2026 07:04:29 -0400
Message-ID: <a536c2e52a78308b397cd1c04a656ff195275836.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Julian Orth <ju.orth@gmail.com>

[ Upstream commit 2e3649e237237258a08d75afef96648dd2b379f7 ]

Consider the following application:

    #include <fcntl.h>
    #include <string.h>
    #include <drm/drm.h>
    #include <sys/ioctl.h>

    int main(void) {
        int fd = open("/dev/dri/renderD128", O_RDWR);
        struct drm_syncobj_create arg1;
        ioctl(fd, DRM_IOCTL_SYNCOBJ_CREATE, &arg1);
        struct drm_syncobj_handle arg2;
        memset(&arg2, 1, sizeof(arg2)); // simulate dirty stack
        arg2.handle = arg1.handle;
        arg2.flags = 0;
        arg2.fd = 0;
        arg2.pad = 0;
        // arg2.point = 0; // userspace is required to set point to 0
        ioctl(fd, DRM_IOCTL_SYNCOBJ_HANDLE_TO_FD, &arg2);
    }

The last ioctl returns EINVAL because args->point is not 0. However,
userspace developed against older kernel versions is not aware of the
new point field and might therefore not initialize it.

The correct check would be

    if (args->flags & DRM_SYNCOBJ_FD_TO_HANDLE_FLAGS_TIMELINE)
        return -EINVAL;

However, there might already be userspace that relies on this not
returning an error as long as point == 0. Therefore use the more lenient
check.

Fixes: c2d3a7300695 ("drm/syncobj: Extend EXPORT_SYNC_FILE for timeline syncobjs")
Signed-off-by: Julian Orth <ju.orth@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260301-point-v1-1-21fc5fd98614@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_syncobj.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index e1b0fa4000cdd..7eb2cdbc574a0 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -900,7 +900,7 @@ drm_syncobj_handle_to_fd_ioctl(struct drm_device *dev, void *data,
 		return drm_syncobj_export_sync_file(file_private, args->handle,
 						    point, &args->fd);
 
-	if (args->point)
+	if (point)
 		return -EINVAL;
 
 	return drm_syncobj_handle_to_fd(file_private, args->handle,
@@ -934,7 +934,7 @@ drm_syncobj_fd_to_handle_ioctl(struct drm_device *dev, void *data,
 							  args->handle,
 							  point);
 
-	if (args->point)
+	if (point)
 		return -EINVAL;
 
 	return drm_syncobj_fd_to_handle(file_private, args->fd,
-- 
2.51.0

