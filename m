Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA43612CDA5;
	Sun,  7 Jun 2026 10:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829808; cv=none; b=c4ZhLcmtfmLhsBpAnxCEwtTHjYeEC8C8m2gEh7epap7N6E4k5Ts9/YXSSmm+KM0CrCNPkOCfJbmUhHumHi68Ziglfo2LDiU6tRtvPvOZg+q5Jz46qMhnoqLd7mKdNk3XR+4xyW/Pm7Epuse1bVNkTV61tbWw2ztHMsvugumr4LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829808; c=relaxed/simple;
	bh=oQeiD1hj+nuP6YmhUq3OrhqA3fd5pzRS68bN2P9fysI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omcO8atYVYGSsJjxzn2y3bX/UWFSm6VMhNGSMCV6mww3f6Veqdw9xazb6KCihBAukVmC8A4cm00X9+A5vgeBtN6kjzyTZ/qI+dlKkLjQ4eVl/AhHzTY+fjYx3/zpTSb/hbHlM4lj5O9nYMD1veh/sJ+WkmKq6YplL9bla3XfTlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ch32njoh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ch32njoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1641F00893;
	Sun,  7 Jun 2026 10:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829807;
	bh=wPXs25up35l1GbU7TRssbJu1GHdQ/6zdHXg3rzo+LsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ch32njohZuJJBu3Ygxr1HhaBaxMhNHv+3JpZYIpu1dNAW9f/JgfgOA8BUCfzLffVK
	 CIpcbFl9hl8B3nahUc+1ELACoNmKK5SU+WHi7odz1I/ceIVE7x6Sh4x/+FkEFFMLXt
	 yNeLgMHQgNoa9GGFlUZN5gj5uTEa0eRUywexHogI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 255/307] drm/amdkfd: Check for pdd drm file first in CRIU restore path
Date: Sun,  7 Jun 2026 12:00:52 +0200
Message-ID: <20260607095737.056882617@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2260,6 +2260,11 @@ static int criu_restore_devices(struct k
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
@@ -2269,11 +2274,6 @@ static int criu_restore_devices(struct k
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


