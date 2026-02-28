Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773DC47CC83;
	Sat, 28 Feb 2026 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301337; cv=none; b=UffUyTEpdR1FkGwZgQ/tGdtb4tZMeLaHLlV16XkSxzQfRh4rBn4euhpboOF9rBpc7bnBQuQ7YBA4+sKSEroI0OqZYq00/EJ8DPeJne7METUAcxIZWEw4jOH/+y644GjY8jNTmEsoEl/rPuewTqhrlFaHR9Eq4opoo/PBeRy0WEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301337; c=relaxed/simple;
	bh=MoI6jtW1+tHn1I40ybjJ8CI+qmV3MhZTCStQS/hEr/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLuUmlI8p/27kBqH0grWC7A21U6q1o/FkTC4zIciSpVtsE+QgfD+2lNibc5V8EvJftIqGwt8nG4PfJ54cnwiDW8Vl+T3zS84WFe0HgAu9a5nO7xoz4bHB+Ikcr8ddR3UOITuhDW9qlx2KQqd+mgomNpi8cTgQFXAoHhGmbl7ZbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXvPZPR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXvPZPR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D61C2BC87;
	Sat, 28 Feb 2026 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301337;
	bh=MoI6jtW1+tHn1I40ybjJ8CI+qmV3MhZTCStQS/hEr/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXvPZPR9ETTMeJR1ym3xTaQraKvAtdK2b753GYKPjJM3x0rlaZ2lrVy7VGTDSK329
	 z5zO97Rc43cz0NdPV7srvut5GWlIijCxVlIcJgw7uOW8NpTPnrqMgMn68bVDlXYTFV
	 6Qw4rCPnSoUBqHae82nFTUBKyyAtWSczUBffkcwbu1HQypiORJt/dbznfuBM7MzYNO
	 5f917cBi4yINb3f2DQ540j0UkLenEOKyH3sxjKVZz+PNXVnEYkvAQjGA0q3vyI6Bsv
	 o/dW+hN4WD/usjGWiTHP9Q7ZtO77EG2Nh7MSYbULKIcZDph9dinlttLijfpxXs+wGh
	 J8pc8Vfm0RFIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jai Luthra <jai.luthra@ideasonboard.com>,
	stable@vger.kernel.org,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 524/752] media: i2c: ov5647: Initialize subdev before controls
Date: Sat, 28 Feb 2026 12:43:55 -0500
Message-ID: <20260228174750.1542406-524-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jai Luthra <jai.luthra@ideasonboard.com>

[ Upstream commit eee13cbccacb6d0a3120c126b8544030905b069d ]

In ov5647_init_controls() we call v4l2_get_subdevdata, but it is
initialized by v4l2_i2c_subdev_init() in the probe, which currently
happens after init_controls(). This can result in a segfault if the
error condition is hit, and we try to access i2c_client, so fix the
order.

Fixes: 4974c2f19fd8 ("media: ov5647: Support gain, exposure and AWB controls")
Cc: stable@vger.kernel.org
Suggested-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index e193fef4fcedf..f9fac858dc7ba 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1420,15 +1420,15 @@ static int ov5647_probe(struct i2c_client *client)
 
 	sensor->mode = OV5647_DEFAULT_MODE;
 
-	ret = ov5647_init_controls(sensor);
-	if (ret)
-		goto mutex_destroy;
-
 	sd = &sensor->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov5647_subdev_ops);
 	sd->internal_ops = &ov5647_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
+	ret = ov5647_init_controls(sensor);
+	if (ret)
+		goto mutex_destroy;
+
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&sd->entity, 1, &sensor->pad);
-- 
2.51.0

