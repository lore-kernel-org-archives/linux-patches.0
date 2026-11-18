Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029979;
	b=XbWao9jViPvj1wVGnG+MDG9xhE8184j55XwSRfTVJLDVykx4om81jxu1BKZXcvDpiwJ8
	 15AkOwEsHa46cblxljprWPKdeBrjgOh5yrbw+XC/dVec0XQg8tn06j7S5iP98TyDgSIip
	 UZXb7A+osxYrUUt/M5pKWIpVF9K6DyqS3uAMibLumr6iWepkOw2279q7C04aAK2lF7l2C
	 KrNWiD6yWgotgk+gF1pTnaovQ6jxs8CX+vOZfCj/LpOD1nrXbQokPLJ6F3isxmwbPS6gs
	 2sC7gSjxedO6Xr8Ofy5hjbnyoOhttWZhuE/XSw3pvWWwtrXqHReD/qPzl5VeH3ZwXdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I1u8gr1e5VCSUEm2ZOoHs5bplpDtMns1iqASF/MoIys=;
	b=lPNWY5ii0YbSWtmKml+p6vPXIqrAqVemUufNdoY0natQAFAfQN7SghbtMvKy8eLP6R2S
	 4FChqYb8Nkm6W249g2AOWMm8ZNNNkrK8h1o1C98n0LnRCFGAUOYqIUEhe/kbzfjmmyZPR
	 cIt1DTMXrAxx7bb8lwZJegkm7lVU+FPE/ORBCvsdReGRXQGM6RpOJhfjb9tcEJOS0zc5F
	 KsdBnZSenxQ6mz1wJVC+d3Nf95+x0vjcpiseb0RxCxBYS9pQv1BBBRpz19LAJsrK9Ehuu
	 P2D4OsrVdFx7/bIXGEpccC92qCcjQbFYEBjeahH/kv549gzRm/iyRcrzyYajg6/a1mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbEl0cLt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A28F606A320;
	Wed, 18 Nov 2026 19:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbEl0cLt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2111F000C4;
	Wed, 18 Nov 2026 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029978;
	bh=I1u8gr1e5VCSUEm2ZOoHs5bplpDtMns1iqASF/MoIys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbEl0cLtLVueIUBnbuvTMU16VrpkAKAf7bXF6rsRL5gq4W/soReN6ebi0pf/fKd3R
	 XViW7eiKy4rivB8O/xRdtsxCKRcO6KXVQLt/WEhIk+UQEczxm2A8A8fZ2LB1u7MsFH
	 bb/kGaJV5nsOUFruYakoLxd9cQRXuuzxEddZGkM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0541/1756] media: i2c: ov5648: Fix a data race on state->streaming
Date: Wed, 18 Nov 2026 15:44:28 +0100
Message-ID: <20261118150030.681177211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b86d2631bd1c..9e67ce2ee11f3 100644
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



