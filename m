Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055310;
	b=EQF8oz75eKMYS19ISdam/QX6efQubXjsB73oPK92YV1yNbQ1Db0o1YusqNu2+QNfEBcM
	 vESdbpRSyhHw5raTPb4EHPXrr3y1h7lJJAv0ydLraa7ChviPmvccO6Vj3vqwubAg8nODa
	 bOigUGCcJlmNHkZLXFMLTj26POgNaqdHeZJeyRLFifUsC9v6kabA1Jk0wi4vNrBvsz47c
	 uQUUJ8wkHahhsJdjRXhPVxB0cuuOyO44EHAslX4dPiMjLi9mG+/OsUist3ngVh4VGQWnj
	 BUAw6JSN4MIakxYEYp1BFIksnsgoGqmYxkUQKRtEczduzaF3muvdpmDneuVZ3gHP11w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MmyBNNiyO8UGESHd/T14SdqVk2mtL9Hj/zlvoGSKqjo=;
	b=m0wW0NLmFI7IpUWvPS/5dc0XbZlagvSMvKIUa3lGoqaCJYe0xrVTQ3FC0uqq7fC6W7JQ
	 Uo8+4v4wgVp2EdynCSOffBCCeZUJPmEoirM51LUX/cBdpcOGZvwAASACUuJ9RH3W7DWC3
	 MiJWNQbaPxeH3ZqM7VBwqKAK1q2FX5dtjH5aEkW7gbI1SLIQuh3oLRcIeqaYmdekbyqe2
	 42KELdArrXdtiLDgGAv6GS46NTIYTEnaf+qqYULFuvALlwoiazMRvMiF+ZHYk/9Z/ac0M
	 dA1wLsq4phwKDefJvJ/smmd9wGCi9ZlCo2AagE4N+FGeLTEFX528xdU5EzbekS6kaYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lddzv4Zv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFA0606A31C;
	Thu, 19 Nov 2026 02:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lddzv4Zv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8101F000C4;
	Thu, 19 Nov 2026 02:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055309;
	bh=MmyBNNiyO8UGESHd/T14SdqVk2mtL9Hj/zlvoGSKqjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lddzv4Zv5BrsgK0KVjToapfYhvcvtjFo+KQsQnCnHZHQE2xolGlqytWzVm/RCBH0A
	 9o3XaA3SdXv1BqxX0s0oQGVHc7y/sg9S84tn8NsoRgnzXfKSj+R5XLnHxj6u9mt9M5
	 ULgSvjT0Mk9dtvqzT0LMZ2+wJeeJWknI4T/LEuLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1584/2214] media: i2c: ov5648: Fix a data race on state->streaming
Date: Wed, 18 Nov 2026 15:54:20 +0100
Message-ID: <20261118150115.372920897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bb3666fc56183..741f0dcb801eb 100644
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



