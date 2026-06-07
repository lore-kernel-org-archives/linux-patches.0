Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5EC2E3AF1;
	Sun,  7 Jun 2026 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829524; cv=none; b=lBjKe37duB1bB3kYBoNL9WEmM3vqSra1VLs1C8Bw0CfOx1+j5agr0Au3rbHLxoH1w+4oK3VGb/tdwaAFbGhoQ7ILVF4dNmgewWs0hOYiyyTNgl3acUv6RAGXxAMpSJGKnlh7oUTi2imhiyEoI2BHyIY00nRGhKSpKCrGcSwph/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829524; c=relaxed/simple;
	bh=fNQ+1Q6cJrJxOgalrcDc2Er+vlcaF0NWl3YbJIlIV3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1ew5xN8ugI5I4IJ7f78GzSmLWVqZ6G80BNXyEJ6Se31GZhr4XyY08yHTjyblJ+/QXuereoJY0w3CwKWJPSf+ITSvVo2ENHAfHqxoiKL+KnZXM/dpxz2oMdCggkEeb7t6EwFbHRenf5wXoKH0vYpBLp0uoy3f02ZaHJcFzSV2Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15R5dd6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15R5dd6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8422F1F00893;
	Sun,  7 Jun 2026 10:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829523;
	bh=QNw9iYfU20TSJlMP2c1mkDCAk3CtIBYSIjBPK55p3L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15R5dd6L8Zet1lqkUgqr3Bx2xpGXy8POuFuCOVVVJVzAaXgl54JMt3+iZQDHok1Rr
	 JeFQ7DJFbuGQ9yZcC1HyNeNVDnD1BPP1ypXn5hWb6/XSWQAToQRI3oaAKumsCGxUWb
	 RF6ViA0Vl5uTk+/aBAHkfH3XmK8IzJOmpa5SmdV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Berkant Koc <me@berkoc.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH 6.18 255/315] drm/hyperv: validate resolution_count and fix WIN8 fallback
Date: Sun,  7 Jun 2026 12:00:42 +0200
Message-ID: <20260607095736.922886117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Berkant Koc <me@berkoc.com>

commit 13d33b9ef67066c77c84273fac5a1d3fde3533d1 upstream.

A SYNTHVID_RESOLUTION_RESPONSE with resolution_count > 64 walks past
the supported_resolution[SYNTHVID_MAX_RESOLUTION_COUNT] array in the
parse loop. Bound resolution_count against the array size, folded
into the existing zero-check.

When the WIN10 resolution probe fails, the caller in
hyperv_connect_vsp() left hv->screen_*_max / preferred_* unpopulated,
which sets mode_config.max_width / max_height to 0 and makes
drm_internal_framebuffer_create() reject every userspace framebuffer
with -EINVAL. The pre-WIN10 branch had the same gap for
preferred_width / preferred_height. Use a single post-probe fallback
guarded by screen_width_max == 0 so both paths converge on the WIN8
defaults.

Signed-off-by: Berkant Koc <me@berkoc.com>
Assisted-by: Claude:claude-opus-4-7 berkoc-pipeline
Fixes: 76c56a5affeb ("drm/hyperv: Add DRM driver for hyperv synthetic video device")
Cc: stable@vger.kernel.org # 5.14+
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Link: https://patch.msgid.link/6945b22419c7d404b4954a113de2ac9c900dba93.1779542874.git.me@berkoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_proto.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/hyperv/hyperv_drm_proto.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_proto.c
@@ -396,8 +396,11 @@ static int hyperv_get_supported_resoluti
 		return -ETIMEDOUT;
 	}
 
-	if (msg->resolution_resp.resolution_count == 0) {
-		drm_err(dev, "No supported resolutions\n");
+	if (msg->resolution_resp.resolution_count == 0 ||
+	    msg->resolution_resp.resolution_count >
+	    SYNTHVID_MAX_RESOLUTION_COUNT) {
+		drm_err(dev, "Invalid resolution count: %d\n",
+			msg->resolution_resp.resolution_count);
 		return -ENODEV;
 	}
 
@@ -513,9 +516,13 @@ int hyperv_connect_vsp(struct hv_device
 		ret = hyperv_get_supported_resolution(hdev);
 		if (ret)
 			drm_err(dev, "Failed to get supported resolution from host, use default\n");
-	} else {
+	}
+
+	if (!hv->screen_width_max) {
 		hv->screen_width_max = SYNTHVID_WIDTH_WIN8;
 		hv->screen_height_max = SYNTHVID_HEIGHT_WIN8;
+		hv->preferred_width = SYNTHVID_WIDTH_WIN8;
+		hv->preferred_height = SYNTHVID_HEIGHT_WIN8;
 	}
 
 	hv->mmio_megabytes = hdev->channel->offermsg.offer.mmio_megabytes;


