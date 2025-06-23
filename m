Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA5E221FA4;
	Mon, 23 Jun 2025 21:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713127; cv=none; b=sNQ9Xd9JkXzw9eNJGqYzu1Ci2Ox28JWr92KqpJEolZBRD5cKvyAYgkOx9uHLJiA39vniyFhHydpJ9F0IZczMfDy8oYLFhic2n8PhJETqOVsstFWwmrmwZpoAK9HczO/rl6Cz0ahEmDKW6lW82/JqvlqejealUYUwUcORNRbZ05Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713127; c=relaxed/simple;
	bh=QHg8kQkIB6V1G1jGy0BxJERJXf03nX4QOa/nv5CuqJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMcOCoQuK21JuXILws3c8RQeT6IDI1VuLhEq7NleamqiPL/FxFV0/7izlfbAeitMzx7zqLRAEf76NY0Z700o5UmOkRwRrRJwI1fBUQLGcbwus7XcsqnchOXhUNaDzjUX5pzzqGZHml6/Xqem7iKXj8msiAmUXNXnO3qhX197o/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wT6sVQdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wT6sVQdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE48C4CEEA;
	Mon, 23 Jun 2025 21:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713125;
	bh=QHg8kQkIB6V1G1jGy0BxJERJXf03nX4QOa/nv5CuqJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wT6sVQdYGztHPZ80nnkILWXuQVrpdwn1pFd+ZNPcZXeqSn6LxdS5KdWpHzhOB2j5t
	 ld+Dbm9Xm7lp4SEI9krE8qvy7OZQ32JT/suwwXiSvhrBMfmW4uIRjmvm55ZIlosz/U
	 AezFfbm1tzYYtpDp9Tv0BPtYsRCayJic+Ql1gI3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 047/414] media: ov2740: Move pm-runtime cleanup on probe-errors to proper place
Date: Mon, 23 Jun 2025 15:03:04 +0200
Message-ID: <20250623130643.217483761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit 81cf4f46a03a07b0b86f9d677c34ba782df7d65e upstream.

When v4l2_subdev_init_finalize() fails no changes have been made to
the runtime-pm device state yet, so the probe_error_media_entity_cleanup
rollback path should not touch the runtime-pm device state.

Instead this should be done from the probe_error_v4l2_subdev_cleanup
rollback path. Note the pm_runtime_xxx() calls are put above
the v4l2_subdev_cleanup() call to have the reverse call order of probe().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Fixes: 289c25923ecd ("media: ov2740: Use sub-device active state")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov2740.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -1404,12 +1404,12 @@ static int ov2740_probe(struct i2c_clien
 	return 0;
 
 probe_error_v4l2_subdev_cleanup:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	v4l2_subdev_cleanup(&ov2740->sd);
 
 probe_error_media_entity_cleanup:
 	media_entity_cleanup(&ov2740->sd.entity);
-	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
 
 probe_error_v4l2_ctrl_handler_free:
 	v4l2_ctrl_handler_free(ov2740->sd.ctrl_handler);


