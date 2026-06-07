Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD4E296BCC;
	Sun,  7 Jun 2026 10:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829672; cv=none; b=sfgIHjPjCcJ4J02kgYgLF+wsxK0JVd1THvVXCP8/YnaBA7omVxprNLiscO9iFoa+u61SDsnzBGGgVyjJ/Zh7Vd6H3djRPWGI6hBguZ6PvFYGKyMuasrJa0iztoF/iNd2FNYWzxxxOTukZPFQnFRtE20isWYRduKLCISm9hkgwz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829672; c=relaxed/simple;
	bh=5L6CEy9SWMjkYBNs+vq0xYrvi9h7Ep72A/4OJEloNWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCRy0KHQT+UMXcc+/pcQBwlKk1WRagCMNAhN57FYibPGOK3PlaukBYFtpuTCcauiaJmWmClWwFu4H8gTAyhgEubCkfNpS2jM2qfNL79Q7lqtkyw8Jyhj2wvQXoSHEYWcFic2sEDVZr559NXMsVdIE3eFh1tLKn3pWNEbz36xVBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgUqyymy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgUqyymy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0DB1F00893;
	Sun,  7 Jun 2026 10:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829671;
	bh=yMU/SAWRHWjOdPi/mCVmJcPFwB69RxGCrLxF2Z3mnU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgUqyymyhqjcOn2K0DL3vcRch3L2H3QjKxAkb6qLllFdGPb8GaLc4jmGFDX9MhsAl
	 MAiA2TkBVjz+52C/cWYvhinqWBO7Ym41dY48WVAdo9nchsQ5aehPFkXgxPzRActkhw
	 gmhxI9fGeuCpQnvoD2mDDFMmDzw5vC8zqMeqVn7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 304/332] drm/amdkfd: Check for pdd drm file first in CRIU restore path
Date: Sun,  7 Jun 2026 12:01:13 +0200
Message-ID: <20260607095739.242416602@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit 6842b6a4b72da9b2906ffc5ca9d846ace2c54c14 upstream.

CRIU restore ioctls are meant to be called by CRIU with no
existing drm file. There's an error path
for if the drm file unexpectedly exists. It was positioned so
it was missing a fput(drm_file).

Do that check earlier, as soon as we have the pdd.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2bab781dac78916c5cc8de76345a4102449267d7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2278,6 +2278,11 @@ static int criu_restore_devices(struct k
 			ret = -EINVAL;
 			goto exit;
 		}
+
+		if (pdd->drm_file) {
+			ret = -EINVAL;
+			goto exit;
+		}
 		pdd->user_gpu_id = device_buckets[i].user_gpu_id;
 
 		drm_file = fget(device_buckets[i].drm_fd);
@@ -2287,11 +2292,6 @@ static int criu_restore_devices(struct k
 			ret = -EINVAL;
 			goto exit;
 		}
-
-		if (pdd->drm_file) {
-			ret = -EINVAL;
-			goto exit;
-		}
 
 		/* create the vm using render nodes for kfd pdd */
 		if (kfd_process_device_init_vm(pdd, drm_file)) {


