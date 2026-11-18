Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046832;
	b=glEjm7HhJ4isqUaRn/3xHvtpus+1GuM6Efh8b8Q75SJPCoyW91ka85gyE1uqFTZnM3F4
	 895zHbFbuBsaxi9NYLe3YC2h8gZ1xXHgHKC+hXp2mBLOhIyD6PODH7MYGtu3HqjefPihd
	 qXUrcqMU9usr3VOZfh5zmD1bt/mGJZagck5ASUm936NnAs9ssb5wBOp9TpCusbMZyOXuD
	 649mRlyZKFF+54VrZEB6u6DtElivMmxPx8ukgi/lrCiug7GwFelj3VoLUqRxmZHilfu8j
	 WRlc1NFQHHRu1KUtSMIflkbzKlU+Dm7OTruyI7OBIhlqvHJyMqSkXvEEB3ojAYGqrvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=azJJuqq8hHlqD7ajvrxdpkD9Yu5WDZBnnIYZ7UKIRwA=;
	b=pzt2h6XdCjmWOJs4bTlU0ZnpTYtOs0DoeGaMqgUUmaytMqzNLOTe21084XfEJS23S8Yy
	 a0/KFoNASbKrAGnVkp9qQmNheNVoZD6QawMp1fYdOxCevJkcRIxrRH16ct5A5GLLd4ijm
	 3Emg11I7KKz3Qn4mvfVjqWA3CId3IvW7qcJTxpQ7o8jllaNaGPfUTI5r37Y/0pZJfXfGf
	 nSOobJEtSX5gus6oa6T4X/rZbweIuUT0+pSGKSMN0+8bAMMsPTLQozpdxa9B79dPpQ6J6
	 0teIDBphfoh+TFfcuFCzaVvZKnyy92bEsS68/rM6JJ4nt2Wx2GAFL2DWQg3t9IjZKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttF515+P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF0D606A31C;
	Thu, 19 Nov 2026 00:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttF515+P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321EF1F000C5;
	Thu, 19 Nov 2026 00:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046832;
	bh=azJJuqq8hHlqD7ajvrxdpkD9Yu5WDZBnnIYZ7UKIRwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttF515+PGZ+/MNU5vk6XjO8dupYqcZXf4YLZqjtZGZrte/s6wLL5ccPy2Dju5lCMu
	 wmFpvi4AhL2Rp3dpvRv4HBEmdRMuov5mwxOrYYa0Aw1ScZzSzRA+LasAeIxifRbqQS
	 bn5GEkgmewaXx2EKOwm0aZX+ImLi2yo2nH252Vn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1382/2857] media: i2c: ov5647: fix power cleanup on remove
Date: Wed, 18 Nov 2026 15:40:16 +0100
Message-ID: <20261118150251.133314867@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 6e81cfc38548109021ab761b94ecdd01f8753154 ]

ov5647_remove() disables runtime PM without powering off the sensor if
it is still runtime active. pm_runtime_disable() does not invoke the
runtime suspend callback, so the sensor can remain powered on.

If the device is not already runtime suspended, call ov5647_power_off()
and mark the runtime PM state as suspended.

This issue was found by manual code inspection.

Fixes: 089b7c70f0d8 ("media: ov5647: Use pm_runtime infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[ sashal: adjusted context for the existing mutex_destroy() call in ov5647_remove() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 869f4d3840f12..ff3752d53f27a 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1460,6 +1460,10 @@ static void ov5647_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&sensor->ctrls);
 	v4l2_device_unregister_subdev(sd);
 	pm_runtime_disable(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev)) {
+		ov5647_power_off(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 	mutex_destroy(&sensor->lock);
 }
 
-- 
2.53.0



