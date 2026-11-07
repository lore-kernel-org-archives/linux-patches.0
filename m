Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062821;
	b=FwW1uBGvKIZKoTLpSyBw0EcKpR7jxJWKKoOQwU0bKIIlFWj4KixF1ErG9c+IhMt6ub7j
	 luo64rGLs+nfvaiO0UDHynECJIfbgbNuE/I55acmiDhpIRAX0oj3uXYUQgGs/zNz129ML
	 BGk/FvpYVrEeRSgN8AbQhnTaaJyZiXzXrd05DCFZXZYUcf6soJ+WzbJ+W7hvIzY5sidK4
	 nBCcIrrsctzJyKt3Ukqa54BdSTeupDIQ7qNjDHR9FntbKABsKi/eW5vEcWrwWuBcoaeCu
	 Cw0KqEInZyiXpLxPje0xUXzzWHjOtOfWbsO1rnb385SLvP6ZgadWUDE8yNZi36WSPIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dhLkB+NyB0hTkq4DVQhoJQvbtSIp9MfuUA4kNbIoCB8=;
	b=fhqwiME6mOSpWj1+6snwIOmEzzhilttRW/JM/SB+uS3KiOXvqlZXm7N1ByW68De70D4d
	 nysQdlXqp7SJ4V2pfIJeLXP0O2Emcj/UMPKtsMlYBtmv2HlehHbnpd83q9sGVTf7QsuCt
	 wPcdRyyypPJzrq4PNSgFkeAL3maueFWCPEoBHbN8OGIufIy78DarG5TpWzkdUC/1xnOuO
	 Wj+r5Ogux4n2tDNu2iKmx5TTqcw1e0NZ5R/0jU2Tx7DssgZ/0d1IVJQpjpvWMaiKemrHg
	 5lTJKcJXrlqer7F4MVoEqngDJhsIcnrrKN14MJmQ+pYXHLorICkS+IofFzgeXNx2oIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIVHyfH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DB6606A336;
	Sat,  7 Nov 2026 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIVHyfH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B241F0089F;
	Sat,  7 Nov 2026 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062821;
	bh=dhLkB+NyB0hTkq4DVQhoJQvbtSIp9MfuUA4kNbIoCB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIVHyfH8SvD6f02eeyAa7otA0wWdIMN8gkM2dqkfOg1vT5r7qZAbG2nUpJ1MvgrYr
	 PWPwEWkxsj5Os8TVPjIvs38MR7EoO9bMM2nLrLTPbXfnbCQa8i2KViPQ66PuTEL+Bd
	 SeoFac2fA+S1tcExdU/3YKr0D5J8AxxbSU2MCVOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/869] power: supply: bq27xxx: synchronize work cancellation on suspend
Date: Sat,  7 Nov 2026 08:46:40 -0500
Message-ID: <20261107134856.538847704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Shengzhuo Wei <me@cherr.cc>

[ Upstream commit f0ff5673aa07ded2bb383ac526c1faee4fe9ca07 ]

The poll work requeues itself via mod_delayed_work() while the device
is not removed. cancel_delayed_work() does not wait for a callback
that is already running, so a poll racing with suspend can keep
issuing I2C transfers after suspend returns and requeue itself into
early resume.

Use cancel_delayed_work_sync() to quiesce polling before suspend
completes, as the teardown path already does.

Fixes: dfcb264a01a9 ("power: supply: bq27xxx: Stop and start delayed work in suspend and resume")
Cc: stable@vger.kernel.org
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Link: https://patch.msgid.link/20260827-bq27xxx-suspend-cancel-sync-v1-1-77a67711cbc3@cherr.cc
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 01c9ec1116fa0..4d4809a70b622 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -2291,7 +2291,7 @@ static int bq27xxx_battery_suspend(struct device *dev)
 {
 	struct bq27xxx_device_info *di = dev_get_drvdata(dev);
 
-	cancel_delayed_work(&di->work);
+	cancel_delayed_work_sync(&di->work);
 	return 0;
 }
 
-- 
2.53.0



