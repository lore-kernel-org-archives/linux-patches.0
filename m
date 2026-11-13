Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590589;
	b=UlCV1mq6lQQwmvK3ESHwoUJEzHumoq8aFlB+rNuuRnVLiVFwLpzHkceUgu8Lzu6pnxYF
	 TPBWCbfDwVAa3mMfujvXhvyRyLlPd7hgXxdZjibJObQYzEbBIluzi4yBKOXyc4F1Ivvxb
	 8FqseFDidNIn3ZmV40PaSA50QIPRCsyI3+XZODkIF2QNedGQSmNik7e8Dfx6L9rT1taZK
	 LPEtupu4iXgLghb4NwunIEqGADBuZKUSZQV9D45yJ/LVJALcx/ajdPBkvPI8aANPfeSvy
	 ddVjFRXqZzSB09HgrEnf+ClsL9a2ibhCn4F8F33V2s/l+7Jn96JrM+VkN/X9h2LToHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rjrk2mx6AAXwgOaevaGzHUVRTHNQGFy5xDhW91q11xQ=;
	b=5DMa8SDFuNWcgs89PTiYcutukqLmsBNSwDdPwZqAjlE1KuLRD3gJHeB4jLBXTt5aZUwo
	 XGWpsz26XlVDsPYFUcgvalq+DWVl0In7U0UJYZv1f/1DdMPEVX1rvzoBnET4dHE3SArLA
	 NtXAkRZhldId38CCoWfoNagwcjB03QWum3E1mrhGLivagz+W0b+y1zlaevZls4yCNNn0j
	 WCgTNPieguheTAS3tnvuOP5G5gERSC3IshDSg+RBoiWAQL/pJgdrop80dII9w28qmR0ix
	 r2j/09l05E/8W4/bunORcmvpQRAdb9O/cFrjZC3rLXdZJQ49IOvdODtvwszNqpR5Qfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4rS35W1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06C5606C08A;
	Fri, 13 Nov 2026 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4rS35W1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067191F000CB;
	Fri, 13 Nov 2026 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590589;
	bh=rjrk2mx6AAXwgOaevaGzHUVRTHNQGFy5xDhW91q11xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4rS35W1vwkXlGBGihDuvbaHdJxMO1fjp/wSJlTVYwKnXxROhRzZHV0GQWFxy0FBB
	 a6gYsWtPCBKO2K72dM2A5VaSiXnI1EiUxHAaanh/b0zhMzDYnO86QlmLmBhH9Ar9Zu
	 NIdCDfiZu4O72/MFPVWiUW2hvgndlAA9Anvd3Q+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/686] media: i2c: ov5647: fix power cleanup on remove
Date: Fri, 13 Nov 2026 10:50:54 -0500
Message-ID: <20261113153838.794536306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: Retained mutex_destroy(&sensor->lock) in ov5647_remove() because the driver still uses its private mutex. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 5fb10e02ba6e2..36460440059ab 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1480,6 +1480,10 @@ static void ov5647_remove(struct i2c_client *client)
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



