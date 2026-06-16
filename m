Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E42A332637;
	Tue, 16 Jun 2026 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629090; cv=none; b=jQ7A/Mvut5wwR+kvg5G2XWI2EJmyCNUw+glCWwI2c9ni9IOHswp2x1n3HDCsLVOvYc1lR7DW5IqT9uO41yXbUYFoOAPMwyDYHVhRCZCgKv+NPqCaXunlkmqkoS9asila70ZgWbbDZ4m+rs8Z2Uaa1LjtGR7yjshrDhx9RGQs97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629090; c=relaxed/simple;
	bh=2zoI1TGyRhAqVJ6B8jsPEygJKhEDux0J8jhuq5ammHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XurGl32cT5WP90gHuHvZCXd3hmiwUjZsLAoq5ZilKeMOyvnu+7kkczPuLWjHhOZwrZwRKqxpV3osueQjPQ67dEkI8jodJigAzQdIgH7UfTQzIQMXOq+SoX4DnUBYUuUc2CZgiNii3wmxOAhx2wu4inc8r9tReiLtjxfUf/NVCTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiG6vCMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiG6vCMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6651F000E9;
	Tue, 16 Jun 2026 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629089;
	bh=lKJr273MayzVGWpzaj1tRJqGhVrvfI2Wh96hN3qfhu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiG6vCMlzRDeN978V4bP8vOvwg17WP6cS0dqXJ+xd83FvC+ukForo4l4tOISTfmQS
	 YhZatwfEoVfHZvBYCyTettwg3+VJL9txZZhIffdMCYbOH9s+1cU4dqw4FLM6VUsOYX
	 vLl77yRQ+r49CWM/ugBm/4wXUsSJmCmOiKNWZOag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 187/452] drm/amdkfd: Check for pdd drm file first in CRIU restore path
Date: Tue, 16 Jun 2026 20:26:54 +0530
Message-ID: <20260616145127.663573916@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2265,6 +2265,11 @@ static int criu_restore_devices(struct k
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
@@ -2274,11 +2279,6 @@ static int criu_restore_devices(struct k
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


