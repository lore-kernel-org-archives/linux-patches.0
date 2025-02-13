Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D302222C0;
	Thu, 13 Feb 2025 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458327; cv=none; b=VDdjDsMsfZyBqiISm2kn3uqutK+tyCoxi+QsHronnf7i4LfSJm3DF99WWHjDz7izI+qornGfJEKkLvQyx54cBjOT/Hfoizi/ZJfqMXX/8Ynd7OOpMWn7EQdUu18CL/GrTq/fSHMZQvkMcX5OvIdZf1sADgCuYVomI0p6yAYmvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458327; c=relaxed/simple;
	bh=OaiFX7PluS5nq+i9+MrO0uv61Qw9d8ciOJayw5n+su0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4hnwzUObH87r7IWc9APMij0w/c/zLKe/BfkNLLVI2s3IO5RnzZ2pRE2XvTHZl5l8A77XzRbMUKjLY/e+rZRRTFYFeEs4ALT7Z+n141XVI+OmifheTn53LrTriWCgG1g2oYxqvCwvW2iKcxW03w81FN/kVUa7ZlmMSgc6llW1TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyQfyhbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyQfyhbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A621DC4CED1;
	Thu, 13 Feb 2025 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458327;
	bh=OaiFX7PluS5nq+i9+MrO0uv61Qw9d8ciOJayw5n+su0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyQfyhbnk4AGERNcxowB2zi88LXxAbyyHATShUXg/BrVEy6/9grKa1KqtJCHWp9e4
	 0BRt3VhSJaYIPwPZsMe2T8L1vj+5TyAeTNtG1HuBmOe5JMWjpd6DtztFwf5Ki0QtF8
	 Z6kf0HZv2dFO4mZccv6v0dPYiTogJU7K4ejFmfuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 336/422] media: uvcvideo: Support partial control reads
Date: Thu, 13 Feb 2025 15:28:05 +0100
Message-ID: <20250213142449.520536891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ricardo Ribalda <ribalda@chromium.org>

commit f00ee2ca8da25ebccb8e19956d853c9055e2c8d0 upstream.

Some cameras, like the ELMO MX-P3, do not return all the bytes
requested from a control if it can fit in less bytes.
Eg: Returning 0xab instead of 0x00ab.
usb 3-9: Failed to query (GET_DEF) UVC control 3 on unit 2: 1 (exp. 2).

Extend the returned value from the camera and return it.

Cc: stable@vger.kernel.org
Fixes: a763b9fb58be ("media: uvcvideo: Do not return positive errors in uvc_query_ctrl()")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20241128-uvc-readless-v5-1-cf16ed282af8@chromium.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -79,6 +79,27 @@ int uvc_query_ctrl(struct uvc_device *de
 	if (likely(ret == size))
 		return 0;
 
+	/*
+	 * Some devices return shorter USB control packets than expected if the
+	 * returned value can fit in less bytes. Zero all the bytes that the
+	 * device has not written.
+	 *
+	 * This quirk is applied to all controls, regardless of their data type.
+	 * Most controls are little-endian integers, in which case the missing
+	 * bytes become 0 MSBs. For other data types, a different heuristic
+	 * could be implemented if a device is found needing it.
+	 *
+	 * We exclude UVC_GET_INFO from the quirk. UVC_GET_LEN does not need
+	 * to be excluded because its size is always 1.
+	 */
+	if (ret > 0 && query != UVC_GET_INFO) {
+		memset(data + ret, 0, size - ret);
+		dev_warn_once(&dev->udev->dev,
+			      "UVC non compliance: %s control %u on unit %u returned %d bytes when we expected %u.\n",
+			      uvc_query_name(query), cs, unit, ret, size);
+		return 0;
+	}
+
 	if (ret != -EPIPE) {
 		dev_err(&dev->udev->dev,
 			"Failed to query (%s) UVC control %u on unit %u: %d (exp. %u).\n",


