Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040070;
	b=tGMoABGBumYDNv/b5ZvUbNDyb8EklshU/Sv1doEtJj8MBE8FAqUrNwGoRO5u2FyEZfwT
	 b5QtUres1JQLbWW6rGMOrxJ+b34Ka/R8CiKUbW7agPqK6nKvYLq85cZEbbvXAjTPpJWcU
	 H3/BOScA68FBrWrRnX4x3WNqCX1NghlMkRlqA/CivCE2iBmx6H7RkKOnfm+8Pht5CuJcL
	 LHs0KyvIHmQIgsLLV3z6Jlxu2YDE6ougefqsSqaUMSqJfSm/sHaI1dJ1C3X7DI9giN+f1
	 WZbTvDFIeswuP8A/EjQIu0USiTDI9ll+0Z1lvpPijNzkwINHqjwGBmSj9HNX0MckSzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f9lt7VhglFKu2SKgJ01qi0mnmIKnlR8159UPHoWkINU=;
	b=K0anLdjKiQ09uJIV19LVRZ1GfxkMm7T/cbSvovo12Fto63VS4FrVRRku4IA6iEOx/rj8
	 MSxfa2DWjoR6tILR5cjMMJ3r1yOiZHtrrJvDzSFBIxx6ZltbofkJfCmakcmUNeOxchlP9
	 VjjC0SxVDCZSaQ/PCiWNbkzKNRu8KFG5gaSAvbMgHBg2awjQPZnk0LodR/Wc4N4T1TnP5
	 hMwsUMpUmwy83rmNbcPnmCNYZpS1KVOwFPwtt26cPk95B4zEtU74vJZ/tlho5zhaJgiCA
	 KBJqT5TBGUTeERnQL97OxfCJCLESyLMrTCzdF0Bp5VqK9ViQgLwaESQ91bb3TFb+ihQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1mmHF5N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3745606A32C;
	Wed, 18 Nov 2026 22:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1mmHF5N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD601F000C4;
	Wed, 18 Nov 2026 22:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040070;
	bh=f9lt7VhglFKu2SKgJ01qi0mnmIKnlR8159UPHoWkINU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1mmHF5NCR52YRjnhoC54IlMIC7eQnLppqKtSIMoy88Djo7uSRqYmT++Ti3gNYfGm
	 qwINOYpBmYp8BGF31Uw+X7jVJu/Bgrk+eHU+CYyNca8IteK+a0KVZh+KJMmq/XbXg5
	 1XBxYEbMiJR4MiIYnq6AT9rqzZcSBShNy7vvQgjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2327/3318] media: i2c: ov5648: Fix a data race on state->streaming
Date: Wed, 18 Nov 2026 15:49:09 +0100
Message-ID: <20261118150431.469575722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa10eb4e3991c..3b06b31543775 100644
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



