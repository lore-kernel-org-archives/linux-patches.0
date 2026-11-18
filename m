Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016988;
	b=IYYgKyUIw61mk8v+h420k8RIirci7GWwjLQ8i+4XcD9gxE3TQpdek/Vkw5ZjudWI3Q5z
	 Dpzd4hmHK8xutGPBoXvC+AABIcjxe8WJHHsiW6KZMPDNVjHVDw3NLizm+5FFPDVb+wGsi
	 0xutUKm2xj4kCYGQ+O8+kNYTTYPsGEvZnMr2EojwjNoHe70NoJtfIynmoq6JQlMsr2iTB
	 P9bgkmH9fxpIylk3rw94SMVy3v9jH10aEsxM4Uu+Ex+FFEXW17xrJ2UMCOLyDMToZSrOI
	 kvbdfRNvbRIeq4ygj8zKWTqk3twnnsF5irCk2WAdoftAizrnOdedSSF+5ORfjkDqhTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrZcta42sj+RsLr6Z1RY1Pgu17WFP/d3vpBMIRwEOqQ=;
	b=HS8DdoefAsGJhPL/8TchIW81G2Y21oguBi50S+iFvN326CGCp8EQICCxuiAqMLXXD+H0
	 lKXRlzwykw2sJdWSTuYztlJ1u3zziVW4POAXoYKlQwxppHjrsdRlFBWwOaAGVkn69fT48
	 Ea2iBsI1LMS/GQni9jPbIEiTq32QKr7jdzJBXrts+9eD4huj/nvKR4wf+uyxXO5wglrOz
	 NO2ImswqxQbAPWEOXerkQZS8mbHpxgoz1pNkrqMYrWNvqIgXnOE2LliLg1rUa5I/k/rbE
	 Cd9YBRMUu6qyA+NUrjDQ/EsJav5qzrpieumw0CDidxTziHJMqnZRRpmPwbX+Ed4MA2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7yWpwW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE54B606A31C;
	Wed, 18 Nov 2026 15:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7yWpwW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385861F000C6;
	Wed, 18 Nov 2026 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016988;
	bh=JrZcta42sj+RsLr6Z1RY1Pgu17WFP/d3vpBMIRwEOqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7yWpwW99LwM8R88CEEEFGRP8sQtZuqQ2fx7TGQXKfeon4iF/P2jpgfy8J03fRnvY
	 0zenTGZm7k/Rf7w/LruRoovkTkH0/lXyM/H7KOCMa3IezF4ZfUuqAOrWu80k0KUfaV
	 hFes+nhC2fn0RYECdnB6kw8pJmjN3LiLglSS0HMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0723/2651] media: i2c: ov5648: Fix a data race on state->streaming
Date: Wed, 18 Nov 2026 15:32:43 +0100
Message-ID: <20261118150313.901825730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



