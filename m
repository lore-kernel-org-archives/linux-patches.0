Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5261F3E0092;
	Fri, 15 May 2026 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862521; cv=none; b=ZmfKyDa/yiAFaH5n7gSlC+agBM59EhLN8np8AUgKa0NySgBDSwB1rUHJ3f2DOB5GbFJdwJjlbxSgWHDY3M4p+SYXL0y1vyZS1dFdZ14dEpzdyCeog5DEG/BzW/1Nx20+3UNQ3Kw/9rD9c5qw0ZYW6Nf83/jdFVe9gOHRJ3JjrCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862521; c=relaxed/simple;
	bh=iya9lXVba/XJk8r0KnLcoUsx8rqSvwhjtlhjvS/OgjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9wZGkh5F9aBWXbAeVhjPFn0QzIlKzH3aERNPvbxuOGrJUC5U1GP7G8W3xnNO5ayLoK1qLP+jRnlyi8jsUubbnTceKf+igCo0Uc2u70C8BgnO8vnJF/Ac+QdCDbdEMQC6Gon0OZs4DVll8KNMxvwLTyrIiIYQwKMO9WQRfEevtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVQ74j52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVQ74j52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB3BC2BCB0;
	Fri, 15 May 2026 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862521;
	bh=iya9lXVba/XJk8r0KnLcoUsx8rqSvwhjtlhjvS/OgjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVQ74j52Xhm7alnqGE7WW5zCwC1JF+Vu//IO+2GWPOz65MIatWS3r2+e9Z29llTWq
	 wBUAY/RYtFJ0bWS0ILVj9GlG5M62A2WVHY9pKABTuOpmT86Y/s91wvU3QcdMW0ktJZ
	 ZC9gB19GJMKxqDiSFQ7S8NLWYovqhXrKTNNC6Tkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dang Huynh <dang.huynh@mainlining.org>,
	Michael Riesch <michael.riesch@collabora.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 043/201] media: rockchip: rkcif: Add missing MUST_CONNECT flag to pads
Date: Fri, 15 May 2026 17:47:41 +0200
Message-ID: <20260515154659.467329201@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Dang Huynh <dang.huynh@mainlining.org>

commit 8e3c751259dc2d1325838eff26f41032523c7b57 upstream.

The pads missed checks for connected devices which may a null dereference
when the stream is enabled.

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000020
pc : rkcif_interface_enable_streams+0x48/0xf0
lr : rkcif_interface_enable_streams+0x44/0xf0
Call trace:
 rkcif_interface_enable_streams+0x48/0xf0
 v4l2_subdev_enable_streams+0x26c/0x3f0
 rkcif_stream_start_streaming+0x140/0x278
 vb2_start_streaming+0x74/0x188
 vb2_core_streamon+0xe0/0x1d8
 vb2_ioctl_streamon+0x60/0xa8
 v4l_streamon+0x2c/0x40
 __video_do_ioctl+0x34c/0x400
 video_usercopy+0x2d0/0x800
 video_ioctl2+0x20/0x60
 v4l2_ioctl+0x48/0x78

Fixes: 501802e2ad51 ("media: rockchip: rkcif: add abstraction for dma blocks")
Fixes: 85411d17bee9 ("media: rockchip: rkcif: add abstraction for interface and crop blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Dang Huynh <dang.huynh@mainlining.org>
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkcif/rkcif-interface.c | 3 ++-
 drivers/media/platform/rockchip/rkcif/rkcif-stream.c    | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkcif/rkcif-interface.c b/drivers/media/platform/rockchip/rkcif/rkcif-interface.c
index 523103872b7a..414a9980cf2e 100644
--- a/drivers/media/platform/rockchip/rkcif/rkcif-interface.c
+++ b/drivers/media/platform/rockchip/rkcif/rkcif-interface.c
@@ -378,7 +378,8 @@ int rkcif_interface_register(struct rkcif_device *rkcif,
 		snprintf(sd->name, sizeof(sd->name), "rkcif-mipi%d",
 			 interface->index - RKCIF_MIPI_BASE);
 
-	pads[RKCIF_IF_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[RKCIF_IF_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
+					MEDIA_PAD_FL_MUST_CONNECT;
 	pads[RKCIF_IF_PAD_SRC].flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&sd->entity, RKCIF_IF_PAD_MAX, pads);
 	if (ret)
diff --git a/drivers/media/platform/rockchip/rkcif/rkcif-stream.c b/drivers/media/platform/rockchip/rkcif/rkcif-stream.c
index f15bee4f7cd7..3130d420ad55 100644
--- a/drivers/media/platform/rockchip/rkcif/rkcif-stream.c
+++ b/drivers/media/platform/rockchip/rkcif/rkcif-stream.c
@@ -555,7 +555,7 @@ int rkcif_stream_register(struct rkcif_device *rkcif,
 	vdev->vfl_dir = VFL_DIR_RX;
 	video_set_drvdata(vdev, stream);
 
-	stream->pad.flags = MEDIA_PAD_FL_SINK;
+	stream->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
 
 	stream->pix.height = CIF_MIN_HEIGHT;
 	stream->pix.width = CIF_MIN_WIDTH;
-- 
2.54.0



