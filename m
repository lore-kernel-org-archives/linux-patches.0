Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048544;
	b=Yop8arhepq9vNsteBr48/Y75HfMp0tOKTH8yGfE0yUPKKbahJpvDX2H7ecM5Hc9AoOL8
	 lXFs10CjTx6oTnHw/YmEQaipS4A6VnkpXQtRNr/X39c3kjLkLJSmMr6eun2mxz9RvXgTN
	 biawrMaDO4ixJeFx15dMKjjlp5DveMuH67cFajdV4Wk6beaEkIa+M/q75CLEttZ5bHSon
	 KE9mFEm9WCfRKjRKH/fCwX8wthcXxIiW5lSItZXdHCTq2KM7eLajzAaiDgbtEhbH93soZ
	 l/Hpw8N7nxUvEHhgdmXp2TeqgOFd+HSWIJMZoF8bRi5zaIzQjkkhu8hm3zgiSZewKJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uEshg2PH8zt7Csr0gJGZgiR5Jc1BNLZuiVNxrwEZIfY=;
	b=gJmxntfgGwN8GGk5uznr+9zeXSa92pkuxn5vn6DvnVwsg0nvmRpu//vZ9eW4lEFwyca8
	 ZIZHrKtu+gXXXTHEbwQVw6pQKwG8YwXdbmOmRF6Zs/PmHOv3pxIG4Apo8xM98OBDbOHyN
	 2m6Uz53XKNUj/X8VReehDEeQxvPzhaqMBIhtTHo9D6BksnODaSnvijsJ6aC5lvrPPuWQp
	 q2FGOcZ63MhCD+PCiWDV19BWfs5TYbn3Bx8ClOT4Mw9lCbMHMY7MWs8yEcJb0VCKm3DBU
	 LSaoQ8jK5N4Y/tAOPAGCh+7jGJ8Pvv7D/0TXBv6BNokJ/LL/SxaJF57cZotd8gCKuMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BElV4ezP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AABB606A320;
	Thu, 19 Nov 2026 00:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BElV4ezP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65D61F000C4;
	Thu, 19 Nov 2026 00:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048544;
	bh=uEshg2PH8zt7Csr0gJGZgiR5Jc1BNLZuiVNxrwEZIfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BElV4ezPQpqI2WI29cF5wD5vsUWi74SK6KtiSxfAXl5vVxaI1wqqtHsQbkwl8IbIY
	 AzwF9oUPBN2NFhnl6ho/sSGFIxzzkk6DO4QmhPw878eWbuNSFIM7cBucBaPKS10wPI
	 C4TEMOk0+8hvx4CJ9RItZIqJZd5EhJuD0+pZMxYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2030/2857] media: i2c: ov5648: Fix a data race on state->streaming
Date: Wed, 18 Nov 2026 15:51:04 +0100
Message-ID: <20261118150314.498233232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 17465fcf28e33..efdebb1bbe134 100644
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



