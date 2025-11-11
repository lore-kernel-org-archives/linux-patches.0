Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715F72D979C;
	Tue, 11 Nov 2025 01:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824092; cv=none; b=qyFJLCW6mHry4igy5Wr9VSkY2mvjhKwWJn1igOP7d3WY8iZ1kux3c4efn95ZFk5+pXAHUz/7KndpXCYe+WGeC8Tv1PxaRqM2V3us1Z/3QlJEoRT6AXeLZ5M9oNCtK448JuYd6GnGXAtNA1j4q7Um0rccekholR7z1c41K/hfYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824092; c=relaxed/simple;
	bh=WdvUI/2yHQF4Wdz3BIubOHQK6kRY2PqvFeZFn3biam0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2QB8qX2yE2I80LLlgcw0QHUzmG6YjQyRoCrHdM2H39i01luyP0imNBbmM4vhXKu1uTk+rgy6jI5ONQoSSh4uPwDG6AP7ygZQUaTbbK3lIbK4lA5AmSfK5cI/VUD+JYMqwoQN9nAWmyJNxpCz8/21j7g9heFOxZF2HRz17D7pvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12PlZhYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12PlZhYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0921EC113D0;
	Tue, 11 Nov 2025 01:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824092;
	bh=WdvUI/2yHQF4Wdz3BIubOHQK6kRY2PqvFeZFn3biam0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12PlZhYDUN+BnzxQgj4McqU/6ru/yD+MBfh0zXVUxwLgh7+zVX0xmKCPMAOmRpv2v
	 2tNHwpZlnaHsdtUwtaVRZBCm64j94ilXDP4RsBXCz76e0IlcVNBcpDjr/7jNZ9nMn9
	 srSUQ+onMYsgSkKs9VOvJGiP9B8zW2LiM/GEusWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 435/849] media: adv7180: Only validate format in querystd
Date: Tue, 11 Nov 2025 09:40:05 +0900
Message-ID: <20251111004546.947597363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 91c5d7c849273d14bc4bae1b92666bdb5409294a ]

The .querystd callback should not program the device with the detected
standard, it should only report the standard to user-space. User-space
may then use .s_std to set the standard, if it wants to use it.

All that is required of .querystd is to setup the auto detection of
standards and report its findings.

While at it add some documentation on why this can't happen while
streaming and improve the error handling using a scoped guard.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7180.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 8100fe6b0f1d4..5accf3020e076 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -357,32 +357,27 @@ static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)
 static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
 	struct adv7180_state *state = to_state(sd);
-	int err = mutex_lock_interruptible(&state->mutex);
-	if (err)
-		return err;
-
-	if (state->streaming) {
-		err = -EBUSY;
-		goto unlock;
-	}
+	int ret;
 
-	err = adv7180_set_video_standard(state,
-			ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM);
-	if (err)
-		goto unlock;
+	guard(mutex)(&state->mutex);
 
-	msleep(100);
-	__adv7180_status(state, NULL, std);
+	/*
+	 * We can't sample the standard if the device is streaming as that would
+	 * interfere with the capture session as the VID_SEL reg is touched.
+	 */
+	if (state->streaming)
+		return -EBUSY;
 
-	err = v4l2_std_to_adv7180(state->curr_norm);
-	if (err < 0)
-		goto unlock;
+	/* Set the standard to autodetect PAL B/G/H/I/D, NTSC J or SECAM */
+	ret = adv7180_set_video_standard(state,
+					 ADV7180_STD_AD_PAL_BG_NTSC_J_SECAM);
+	if (ret)
+		return ret;
 
-	err = adv7180_set_video_standard(state, err);
+	/* Allow some time for the autodetection to run. */
+	msleep(100);
 
-unlock:
-	mutex_unlock(&state->mutex);
-	return err;
+	return __adv7180_status(state, NULL, std);
 }
 
 static int adv7180_s_routing(struct v4l2_subdev *sd, u32 input,
-- 
2.51.0



