Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C23199222;
	Thu,  6 Jun 2024 14:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683692; cv=none; b=dawdW93x0i2LhDeBFSWoxS+ZyjprPfPaFQxtqgLb8siAE6fQaFpq4WuqR2G0fYet8rRSqCl4artnGveOV4ApYFnJUc8KnW3wd3/RUWlpR9ZGdttb3xbs54xbQ7CsYCuOdQ7ArCAppcU/M9dazLtJp44ec6K0NAeIljFoOPlfslk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683692; c=relaxed/simple;
	bh=0inX9Cb4f3+bhPBAUPt+IjEZQ6svVW35Zj+1gsHDx2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOV0Y994mvD2vm7CsQpaGYowanTUrWopmXJwwsDD+sUhZbZHx20aj/ccVi4ohM+j2C31hsxr4r+QrAwhUmmVk1OHJ7D4JilJHIlGz9IcmTrVDUc2O9m2ZdkPU5wYoD04p8QRxiem1Gm4Cx9b2Sw3ln02WL+Dh9hSekx9TifJmxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlEc+bsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlEc+bsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03700C2BD10;
	Thu,  6 Jun 2024 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683692;
	bh=0inX9Cb4f3+bhPBAUPt+IjEZQ6svVW35Zj+1gsHDx2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlEc+bsTKdhoDLLAV5iMy4Q/TGZX8yxjSZdWf1BF+ndiQzbrpkznMghgwWHMH3kXQ
	 dBE0QhXK6QSMmMMjxBhrU5pni9x34FapRBvhbYm9ZtCzOaGR4NDZSJQbBs9ohdfRqT
	 8+JY7VfPVf7D+3yMWddeBC1K2atrSSYfk1Z9vzZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 567/744] media: v4l2-subdev: Document and enforce .s_stream() requirements
Date: Thu,  6 Jun 2024 16:03:59 +0200
Message-ID: <20240606131750.644844388@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 009905ec50433259c05f474251000b040098564e ]

The subdev .s_stream() operation must not be called to start an already
started subdev, or stop an already stopped one. This requirement has
never been formally documented. Fix it, and catch possible offenders
with a WARN_ON() in the call_s_stream() wrapper.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: f2bf6cd8f447 ("media: v4l: Don't turn on privacy LED if streamon fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 17 ++++++++++++++++-
 include/media/v4l2-subdev.h           |  4 +++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index ee159b4341abc..f481d1ca32abb 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -359,6 +359,18 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	int ret;
 
+	/*
+	 * The .s_stream() operation must never be called to start or stop an
+	 * already started or stopped subdev. Catch offenders but don't return
+	 * an error yet to avoid regressions.
+	 *
+	 * As .s_stream() is mutually exclusive with the .enable_streams() and
+	 * .disable_streams() operation, we can use the enabled_streams field
+	 * to store the subdev streaming state.
+	 */
+	if (WARN_ON(!!sd->enabled_streams == !!enable))
+		return 0;
+
 #if IS_REACHABLE(CONFIG_LEDS_CLASS)
 	if (!IS_ERR_OR_NULL(sd->privacy_led)) {
 		if (enable)
@@ -372,9 +384,12 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 
 	if (!enable && ret < 0) {
 		dev_warn(sd->dev, "disabling streaming failed (%d)\n", ret);
-		return 0;
+		ret = 0;
 	}
 
+	if (!ret)
+		sd->enabled_streams = enable ? BIT(0) : 0;
+
 	return ret;
 }
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d9fca929c10b5..ab2a7ef61d420 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -446,7 +446,9 @@ enum v4l2_subdev_pre_streamon_flags {
  * @s_stream: start (enabled == 1) or stop (enabled == 0) streaming on the
  *	sub-device. Failure on stop will remove any resources acquired in
  *	streaming start, while the error code is still returned by the driver.
- *	Also see call_s_stream wrapper in v4l2-subdev.c.
+ *	The caller shall track the subdev state, and shall not start or stop an
+ *	already started or stopped subdev. Also see call_s_stream wrapper in
+ *	v4l2-subdev.c.
  *
  * @g_pixelaspect: callback to return the pixelaspect ratio.
  *
-- 
2.43.0



