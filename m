Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C664411671;
	Thu, 30 Jul 2026 14:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422705; cv=none; b=Ou9gVzY5GAnYuuJoOujER/cGVcEXuTiGCDUinwtie2fjy4RQ8Aw/bPmF/V6f5ZTMtA1dmd5BwqiNCQBnCJFzmsA4AJtnfWshSBupa+9mc/erMmV6sJ/fXV2pMWZbGhfgHCdoqLr0F75ELI/xoJYz5+KAK4y8g3x0+16VXGjecbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422705; c=relaxed/simple;
	bh=QH1/XRzcb9jyTgcTYmhQ1SdzveqDnh24ZNzZmlqHeH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vp3yW4MH7TFB0mT8Qu5ae7Rj9LWOhZcJcdXGmwWcj8+CvBGD11JSobQ3ATWnJ5SuzPk1U0tVKkYRSIl3NgnKy1mwuitu50th4M5D0qFU9y8Y8J0L29/L1D2AK6bWofS1SeMkeoKMWjPo0O8pxocN5IT2llLPzDd62rvZ6PheQLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcsTh2CP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcsTh2CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DAC1F00A3A;
	Thu, 30 Jul 2026 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422704;
	bh=Y2y4z5FaUOSwUXmnK9Z8IDe1Eg+dgHPcAz7Oe4aEiCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcsTh2CPTnKc6rKTnty8znJcPeTFBhEo/F/mPJy03IMTu93PVeFSx8ud8JcNpivUL
	 yYJuFfuCRrIoHmtjiIequI8JDZmu3yuEXoD6VJlBhS+q+hZYBNSk3huVXIKvdQLUXp
	 P0O1tsfHXa7fL8RViwN2yn9yKAmz1ffJkoc3aMgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 7.1 529/744] media: v4l2-subdev: Fail {enable,disable}_streams and s_streaming nicely
Date: Thu, 30 Jul 2026 16:13:22 +0200
Message-ID: <20260730141455.516932180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2504,6 +2504,10 @@ int v4l2_subdev_s_stream_helper(struct v
 	u64 source_mask = 0;
 	int pad_index = -1;
 
+	if (WARN_ON(!v4l2_subdev_has_op(sd, pad, enable_streams) ||
+		    !v4l2_subdev_has_op(sd, pad, disable_streams)))
+		return -ENOIOCTLCMD;
+
 	/*
 	 * Find the source pad. This helper is meant for subdevs that have a
 	 * single source pad, so failures shouldn't happen, but catch them


