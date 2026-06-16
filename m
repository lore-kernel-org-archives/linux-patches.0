Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138C747A0DA;
	Tue, 16 Jun 2026 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631158; cv=none; b=lPTsLN0INCe6M39q6rukrdlFxItJPupOuaj9jCnVk7AiMsLzVdzRqA6eB+6uF9Nml/xvbCvX/+cVG0yDn+dl0OCKicu7s5HRmjb2lXcvoNdQD7EWspmbHGFkPzdChU0RcONgkNZcvDoKEL3SqxRs368TsQ2s2OabclONrE3egnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631158; c=relaxed/simple;
	bh=RIjnSDRq5pyS3B/jrXj8ZeP81LtkMZlI3wTZ5JHvEeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpgySSjlT3uM+xPvTNE1ihTWFfCSnk3rvkmJdXY7esL3/1z3GVRNchfbWZtF5lZY9NzOokpYRseOnLlxduWUUMne3qAVOGo4wZViEht5xtKAa4AU4FCzLOTCjZ8HnyckbcFadJt7NhJX6o45OO83RyYqMH2vNIyp6yzIIUko+mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bljEchvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bljEchvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C6A1F000E9;
	Tue, 16 Jun 2026 17:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631157;
	bh=FUZ9Kn78SL8lnf5SJlFgZOR9qJ/EwVGzFY1BTnyRgdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bljEchvCUGQZop3J+TuHX6vKPPY1EkCKgbnBx66Xk5jN9ZGvWVvcty30zVkIimVFp
	 NTgtWhsmZClxJwlgftv6DdfwrEERyC3qLTU/wVWYuRhNtmFVkQVFtVFxUAN4KNKF80
	 pBXIlHuOx72c5hR4y6LUlqvNE+fTCUPuUkxkX1X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Berkant Koc <me@berkoc.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH 6.1 166/522] drm/hyperv: validate resolution_count and fix WIN8 fallback
Date: Tue, 16 Jun 2026 20:25:13 +0530
Message-ID: <20260616145133.926947961@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


