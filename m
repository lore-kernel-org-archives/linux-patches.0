Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFAC262A1
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK+euWgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3086C433C8;
	Mon, 16 Oct 2023 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468066;
	bh=gY6GKDxiT2vh/3SpIxeen0gnMRKoi0NRJDE249KNotM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK+euWgif0nTpA/nG6oJgPYvOtoEtxSeMcbPB1WI4+2KyKLjW50JQnaT8C3+3Xoyl
	 VJhisZAW0hIFqiVlEdDl+rsjIpM2D0LC9xR1BR/KM3NnoE30sycICyuVUWXHym4+bN
	 TG0RB8gaTC3DBCzdEX/ykZrTnW6SAVvte51tDIEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Bonke <admin@dennisbonke.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.5 119/191] media: subdev: Dont report V4L2_SUBDEV_CAP_STREAMS when the streams API is disabled
Date: Mon, 16 Oct 2023 10:41:44 +0200
Message-ID: <20231016084018.157397850@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 4800021c630210ea0b19434a1fb56ab16385f2b3 upstream.

Since the stream API is still experimental it is currently locked away
behind the internal, default disabled, v4l2_subdev_enable_streams_api flag.

Advertising V4L2_SUBDEV_CAP_STREAMS when the streams API is disabled
confuses userspace. E.g. it causes the following libcamera error:

ERROR SimplePipeline simple.cpp:1497 Failed to reset routes for
  /dev/v4l-subdev1: Inappropriate ioctl for device

Don't report V4L2_SUBDEV_CAP_STREAMS when the streams API is disabled
to avoid problems like this.

Reported-by: Dennis Bonke <admin@dennisbonke.com>
Fixes: 9a6b5bf4c1bb ("media: add V4L2_SUBDEV_CAP_STREAMS")
Cc: stable@vger.kernel.org # for >= 6.3
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -517,6 +517,13 @@ static long subdev_do_ioctl(struct file
 				       V4L2_SUBDEV_CLIENT_CAP_STREAMS;
 	int rval;
 
+	/*
+	 * If the streams API is not enabled, remove V4L2_SUBDEV_CAP_STREAMS.
+	 * Remove this when the API is no longer experimental.
+	 */
+	if (!v4l2_subdev_enable_streams_api)
+		streams_subdev = false;
+
 	switch (cmd) {
 	case VIDIOC_SUBDEV_QUERYCAP: {
 		struct v4l2_subdev_capability *cap = arg;


