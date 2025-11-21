Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3452343C0;
	Fri, 21 Nov 2025 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732629; cv=none; b=Clv9PTaYiTIWH8MhjlNtxxRkRhkPfx6Q9dZm14D3rck1ifTuWk0lug1EYi7Ed2pNafNRtwg5V7+Wpbo0xP/p5EpKhIabpyKN8Dt2o1etg0vherADTqNaSg8g/dh8xBw1JwR28ihsXo9z01d0npFwlS94lHkPiSlyAIFkVldzWBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732629; c=relaxed/simple;
	bh=kaz1M/1NIvojfMbmjo8ROAvRRrowLLSbhH6IjhddJqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z753SexLp75aITS2+QCXWGuJ1CmOy+7AfKYy5VLViGvCQKVogPxZGTVw7UMMysVmQArHWEGO9K4kNwEWQnOxgE864llZuGfRcPn06Sm1c43eqJCMSwKal4kSJVSKH1e6XWgotOER+dPhY+ajjQtDLqupTvR55I7K6aBnxGyqivA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N70GJRms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N70GJRms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66759C4CEF1;
	Fri, 21 Nov 2025 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732629;
	bh=kaz1M/1NIvojfMbmjo8ROAvRRrowLLSbhH6IjhddJqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N70GJRmsUysjrgLWblxdApK9WG+QGncpCJTouIMSoVKjd3nWaEVtFixU+0KOZ7CVu
	 /KcEtkam3w65X2fjov5xW/aBSU1JOy581PH5ZUza1KXDRILoz/73zpDOGJkI0p09Xd
	 wQoGTrWwQwl1GAqZ8nI31snev/2bI2abbfIGC3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/529] media: adv7180: Do not write format to device in set_fmt
Date: Fri, 21 Nov 2025 14:08:07 +0100
Message-ID: <20251121130237.708170445@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 46c1e7814d1c3310ef23c01ed1a582ef0c8ab1d2 ]

The .set_fmt callback should not write the new format directly do the
device, it should only store it and have it applied by .s_stream.

The .s_stream callback already calls adv7180_set_field_mode() so it's
safe to remove programming of the device and just store the format and
have .s_stream apply it.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7180.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 831ce10718550..ef2c769929a97 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -803,14 +803,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 	ret = adv7180_mbus_fmt(sd,  &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		if (state->field != format->format.field) {
-			guard(mutex)(&state->mutex);
-
-			state->field = format->format.field;
-			adv7180_set_power(state, false);
-			adv7180_set_field_mode(state);
-			adv7180_set_power(state, true);
-		}
+		state->field = format->format.field;
 	} else {
 		framefmt = v4l2_subdev_get_try_format(sd, sd_state, 0);
 		*framefmt = format->format;
-- 
2.51.0



