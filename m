Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6C35E535;
	Wed,  3 Dec 2025 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779228; cv=none; b=jIi2iHuDUeh5gMTiA9/PGq6qwqLyQXZund2XWlvj4oOxr3bbwx8YJNQE4N/n58d/EDyCO4ihFZBqpHb3YPuAtgI0WFoQJGdnduRHC24mzNC71IY8BrUzmCG2wA4x7iozEbkzisHq09pZgq6V/8pzFSDJBnkUchjXmy1D/9cg6E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779228; c=relaxed/simple;
	bh=99f3Ujs9UJkv1G2+3Gr8Jn0MFG7K3QEDdfuPCYojXy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7T7Voqtf9Xhkp0ZGg5V5vW/cnVRM2bNPSTB2ApdGDdSx9YF2MXEHgWA9utx2LVIlerMYj5RMBx+jZSdSj7nYthK5J1vCiPf0JehNo2fISNdXlFwWsexafhoApT7Y6HK7o0D1yMK3SoFqnI16sNG8A5B5kUc5db/mvV9Stfh76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQGTxv71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQGTxv71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186B0C4CEF5;
	Wed,  3 Dec 2025 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779226;
	bh=99f3Ujs9UJkv1G2+3Gr8Jn0MFG7K3QEDdfuPCYojXy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQGTxv71nH6qLRiY7E41mTmT4NY/1QJ/hY/t2iXVsA75vRpwZmPcLm3y6yiu9NSHt
	 CJVtY1/lRcu8aBDrk0Ef/fe1Xu5D7Ji3FpIkfUV081pwT7mMk5LEMbi2VIkljD1+Ka
	 sfUJ9+/b4F94nmz/L2eSl570I44tbdpjjVcXm7no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/568] media: adv7180: Only validate format in querystd
Date: Wed,  3 Dec 2025 16:23:15 +0100
Message-ID: <20251203152447.794220142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74356ea06deee..5d10edcfcc3b5 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -356,32 +356,27 @@ static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)
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



