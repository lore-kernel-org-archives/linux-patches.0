Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6171111710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D22BC433C7;
	Mon, 11 Sep 2023 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445778;
	bh=EhfmbSxjn1MFaguxrqEp3iWYgMQlXz4ybBRaPABpVpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9/xQ2Pmgytj811aO/WdEDi3TPWQ4S1lufX4IVBV4x2MQnYWnNcwZAdg9N8FwIvhu
	 R0f4QdSuzDtEtzkQbRQ7CAJ3cz8MWfgUvjb7zygS6kCx+1mE4YOXSlvBXNWetsI0hw
	 zxmhGWGv4b/7AlT3jkFHLi9H/A+SAL3AUi0mJDxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 469/600] media: ov2680: Dont take the lock for try_fmt calls
Date: Mon, 11 Sep 2023 15:48:22 +0200
Message-ID: <20230911134647.491367211@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e521b9cc1a49de677f4fc65909ce4877fbf7b113 ]

On ov2680_set_fmt() calls with format->which == V4L2_SUBDEV_FORMAT_TRY,
ov2680_set_fmt() does not talk to the sensor.

So in this case there is no need to lock the sensor->lock mutex or
to check that the sensor is streaming.

Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index de11a5fb03659..4f7ff23ef8973 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -595,24 +595,22 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 	if (format->pad != 0)
 		return -EINVAL;
 
-	mutex_lock(&sensor->lock);
-
-	if (sensor->is_streaming) {
-		ret = -EBUSY;
-		goto unlock;
-	}
-
 	mode = v4l2_find_nearest_size(ov2680_mode_data,
 				      ARRAY_SIZE(ov2680_mode_data), width,
 				      height, fmt->width, fmt->height);
-	if (!mode) {
-		ret = -EINVAL;
-		goto unlock;
-	}
+	if (!mode)
+		return -EINVAL;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		try_fmt = v4l2_subdev_get_try_format(sd, sd_state, 0);
 		format->format = *try_fmt;
+		return 0;
+	}
+
+	mutex_lock(&sensor->lock);
+
+	if (sensor->is_streaming) {
+		ret = -EBUSY;
 		goto unlock;
 	}
 
-- 
2.40.1



