Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024347;
	b=kTA8qLkHw47klU9me8TM4SIqkb+YT7y7Zj+dOUy82V75rOiEKAxhP1DVqWIAx7j/s00F
	 yxswki52Fxwf4H9ODj1SoFOGslwy8mVYmPqH/Pk4Xs/a2OZgHWmSFns+vU4eZLzE1casG
	 Nmlwu/YFr7yBvXgCH5ahwZJIdFw9sTVKxF+KWQxCvOOxtEMCgOq01idC3dysXC1ioq8x2
	 bZQOaCVM/cKH5NcqlOWxNREFc5r/QB954ZXFp3RKG9ClFO8qnmDlNR9SuUUVsCx3JDSYD
	 EmI5aHh12ZROP8CnJcLDW+k9+28SwgSNQYaeExOH8wHvymnXw1yPcl4Tf4570/f/uZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=60exCncCzA11iCbE855z0r5Za1RYyVdBOvtB2Y4YCCE=;
	b=keCiBvyJPAqbL7nYHu4RTSExLAp8KaVXUelf4jFJ40jeYSqTyvrdWemUeGTj8DDX/5d9
	 fbDEZlpmW77kA01rD7AMwQL0AwNmefsvyvxAo9I6km3FVsdJ7TTJUedTvGaUhlTIUmskR
	 LlV62hgADpFr66/WmcJmQ3EJdEYuO4MPWTFIh+5CdhIPY2D/C/tOPHikLyBX5WhZMBeHY
	 19ggho9119dpa63rj2u7xmmFcaU8ShUhuoTjdk2FuTwfN4h4ZpQrLHZona98Ylb8+rw7p
	 EjfmXj5J5NBs79LOS/KIVEpTSDkXLkZr8UBH7VaeVNgj7SwJaxrssy9aQJ1ZMnMBxeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmpJVkb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDCE606A320;
	Wed, 18 Nov 2026 17:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmpJVkb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0A41F000CA;
	Wed, 18 Nov 2026 17:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024347;
	bh=60exCncCzA11iCbE855z0r5Za1RYyVdBOvtB2Y4YCCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmpJVkb+RpRyHSY36+DPeh4s8H3VG74XGwjCePJswDzzuvy/A89MNhqyIgCyksHIv
	 otKmDaDOG8e0mR6wFqDI1uj+74bKmyUrWKwyhkGDILC1uNZUHiKw89bG+aPW7AYkBe
	 kjIfjKQ6WB0gb3Opn9dm5QvkA4qk/KY6xiL7eHJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0652/2151] media: i2c: ov5648: Fix a data race on state->streaming
Date: Wed, 18 Nov 2026 15:39:47 +0100
Message-ID: <20261118150145.590094710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ginger Li <ginger.jzllee@gmail.com>

[ Upstream commit 76c8ffbe1b9bc0ee4c977180e3f498352de0d01e ]

ov5648_s_stream() updates state->streaming after it has released
sensor->mutex, while ov5648_resume() reads that field with sensor->mutex
held. A concurrent resume can therefore observe a stale streaming state
and leave the sensor in standby while the software believes that it is
streaming, or the other way around.

Keep the update inside the sensor->mutex protected section that already
programs the standby mode.

Fixes: e43ccb0a045f ("media: i2c: Add support for the OV5648 image sensor")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5648.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5648.c b/drivers/media/i2c/ov5648.c
index f0b839cd65f11..006aeb93482b2 100644
--- a/drivers/media/i2c/ov5648.c
+++ b/drivers/media/i2c/ov5648.c
@@ -2145,13 +2145,13 @@ static int ov5648_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	mutex_lock(&sensor->mutex);
 	ret = ov5648_sw_standby(sensor, !enable);
+	if (!ret)
+		state->streaming = !!enable;
 	mutex_unlock(&sensor->mutex);
 
 	if (ret)
 		return ret;
 
-	state->streaming = !!enable;
-
 	if (!enable)
 		pm_runtime_put(sensor->dev);
 
-- 
2.53.0



