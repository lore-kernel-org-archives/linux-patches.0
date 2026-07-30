Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6B737BE64;
	Thu, 30 Jul 2026 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424567; cv=none; b=VeLhqBd/0kIv4Sh+k60XOLmKf/KIPybGhlC80h25JS7PJxzInDD9f+tY1o5sPLTS///TR21Xnc5MxJ8pcQ2Q6L4DFrY1lMSL1lxMzAQxgT4bOOgtRKY+wyb7eL+civW3jYOGYTc83ovoteedf+boZyRCitUsIkdWFDZHMN0x+y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424567; c=relaxed/simple;
	bh=kO8KNZc87+bKvB+6IXniv7uMPbJG1fWeXYGD0BoCGnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/+SPYL9nGaneolLgEBOhwjfJ2eRz6fWyywnyzjpn+mJwcVhsrVsv4LeXE+UDOGNSkpIwazR0FCuzlXeBwAbwAshdxRlWIowwrEEiYbXiglWHH5xkixhP9NU79ctLhr3PBaxGgCgKJZ98z78a6Zrcj99B68vRnAU/BEhcTa7+TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAQY+STZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAQY+STZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA411F000E9;
	Thu, 30 Jul 2026 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424566;
	bh=888ZFrHOj1XOlm8F8yJn1OfNsfJijJ6dO48o6hfJNx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAQY+STZci//yms9WAVOhVJLKN/tU3QOUWhyQyH+0yPel3rNaJ4keyOs+K3VKGTT0
	 qwOtf79dAXsJx7TEKY30gC+7Xv04J7iuV7c0tbBrX5zdDiZcM4nhjvRm4oJDXfxwBk
	 f+MKC7Hoj3nLcRsoFUv76xn/BAH3aztxgDUrakps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 6.18 438/675] media: v4l2-subdev: Fail {enable,disable}_streams and s_streaming nicely
Date: Thu, 30 Jul 2026 16:12:48 +0200
Message-ID: <20260730141454.448682753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 0bcbfd1c1142d85faef8df5cb679d37f71394c5f upstream.

If a sub-device does not set enable_streams() and disable_streams() pad
ops while it sets the s_stream() video op to
v4l2_subdev_s_stream_helper(), enabling or disabling streaming either way
on the sub-device will result calling v4l2_subdev_s_stream_helper() and
v4l2_subdev_{enable,disable}_streams() recursively, exhausting the stack.
Return -ENOIOCTLCMD in this case to handle the situation gracefully.

Fixes: b62949ddaa52 ("media: subdev: Support single-stream case in v4l2_subdev_enable/disable_streams()")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -2506,6 +2506,10 @@ int v4l2_subdev_s_stream_helper(struct v
 	u64 source_mask = 0;
 	int pad_index = -1;
 
+	if (WARN_ON(!v4l2_subdev_has_op(sd, pad, enable_streams) ||
+		    !v4l2_subdev_has_op(sd, pad, disable_streams)))
+		return -ENOIOCTLCMD;
+
 	/*
 	 * Find the source pad. This helper is meant for subdevs that have a
 	 * single source pad, so failures shouldn't happen, but catch them


