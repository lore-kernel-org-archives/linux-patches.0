Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510C51DEFD7;
	Tue,  8 Oct 2024 13:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393887; cv=none; b=oRmyG3TUbGT2iAqwxpVL+rKu7hH4ElukwzqIA7PJ7cZo6+VU7gnt+E+Bu4UXvyOBOtzdeEcfGIbwZ4lstkMj6Ow4xDfOhPQLoQkU47GcKn8OX2Si7gRsNV96iqnsgklu2/VZrqWHjClX8n3eLvo7HUX+cOLt0DdggjY5RKSdkhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393887; c=relaxed/simple;
	bh=O92rSR72os9Waxiq4Ljw0+JHsDWyWv5Rr2dB/GnSygE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7lDAudcKmHSWtnlNYhJ6EsecVrbDE1J/f+R1BoUt7Dq2yJoy8PHaEtI8JDH+Dv8xG4rDm1MlIwA2fHrz/aY5y6jf9X0DREvUkQohTEreyRDndkex9c98S5XnTq+XJVa44SwuImlJP7PsfcSqqnBJCU9PBskXtqEKY47KTnlJ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f93lxNDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f93lxNDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C12C4CEC7;
	Tue,  8 Oct 2024 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393886;
	bh=O92rSR72os9Waxiq4Ljw0+JHsDWyWv5Rr2dB/GnSygE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f93lxNDtLch7IaxkG9Wau+w36nO95h1ezcIKXoVePmk/o5z2L3oIghgbKGt9+u+cV
	 mbMjNW4fs6W+1Slz8ZLNsqn66IMKe4DGub+JkGqjrAPG35qKeOf0KxuG3PXbeTeHnI
	 n0ImGWqPMHzJ5VpWErZUhUBbYdO3X2S3rGnN6WGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.6 283/386] media: sun4i_csi: Implement link validate for sun4i_csi subdev
Date: Tue,  8 Oct 2024 14:08:48 +0200
Message-ID: <20241008115640.522980565@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit 2dc5d5d401f5c6cecd97800ffef82e8d17d228f0 upstream.

The sun4i_csi driver doesn't implement link validation for the subdev it
registers, leaving the link between the subdev and its source
unvalidated. Fix it, using the v4l2_subdev_link_validate() helper.

Fixes: 577bbf23b758 ("media: sunxi: Add A10 CSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
+++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
@@ -39,6 +39,10 @@ static const struct media_entity_operati
 	.link_validate = v4l2_subdev_link_validate,
 };
 
+static const struct media_entity_operations sun4i_csi_subdev_entity_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
 static int sun4i_csi_notify_bound(struct v4l2_async_notifier *notifier,
 				  struct v4l2_subdev *subdev,
 				  struct v4l2_async_connection *asd)
@@ -213,6 +217,7 @@ static int sun4i_csi_probe(struct platfo
 	v4l2_subdev_init(subdev, &sun4i_csi_subdev_ops);
 	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
+	subdev->entity.ops = &sun4i_csi_subdev_entity_ops;
 	subdev->owner = THIS_MODULE;
 	snprintf(subdev->name, sizeof(subdev->name), "sun4i-csi-0");
 	v4l2_set_subdevdata(subdev, csi);


