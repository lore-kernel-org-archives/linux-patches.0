Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C154705A;
	Thu, 17 Sep 2026 18:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668221; cv=none; b=kVsMX5RPfeQF8HevWmdxx00YNEn0qJ4LFnpAkBiMWr7AX6CM3TteE9wal3SuFSGSS+2ewlvTxyaOer8K0U/VoAzOiqGU1ZoFO5cDsd981OLKVHI8ZBbcKSDIL3vEL8rsBm2VJHYaBHCS8JshwHBObKWTZZ1RzSOhE6JVwC3hLRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668221; c=relaxed/simple;
	bh=F5h+YJzFiR24mLlyJhFDVorKvsc7KxCC+7LFfDTCreA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAOCMDuw5gIIQEfpa4R6s1GDyOt9A5o33KW29x94+EcEx081Of7BtYYZS+uqN6a20Mf68CrEA86K4epiHL2z3mKupFj1jdUrpzaADOYRk7aAORaSBJgFOiMT5/31WKQwV3MQtb4w2adIJx0GQKs51l1NP3gX0UIERDj0FWiA840=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgLmCDSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgLmCDSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F071F000FF;
	Thu, 17 Sep 2026 18:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668219;
	bh=DVmw645xhQ3BozA7xIrjzD/VdRygEZ5Y+HSQLuEnQmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgLmCDSk+E32NPeu20WUZOILTFQV6Lybv0AIXWn2E1c6vf8fCWixCKgR4QPLiHT75
	 C+w5jtcVoK3Zxm8ITlP7HqHA9sUaQgskhCodNLp4Z4ovAOUGXE6Jhr67BQ76F5WIGT
	 +kfJNYhQvwkJodI9gR33J7+FPI70Y9sy/s65gb5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akashdeep Kaur <a-kaur@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0326/1102] mfd: tps65219: Make poweroff handler conditional on system-power-controller
Date: Thu, 17 Sep 2026 16:04:29 +0100
Message-ID: <20260917151547.815794776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akashdeep Kaur <a-kaur@ti.com>

[ Upstream commit 104cd764a031bfe2ffe253adce9581384a78c16e ]

Currently, the TPS65219 driver unconditionally registers a poweroff
handler. This causes issues on systems where a different component
(such as TF-A firmware) should handle system poweroff instead.

Make the poweroff handler registration conditional based on the
"system-power-controller" device tree property. This follows the
standard kernel pattern where only the designated power controller
registers for system poweroff operations.

On systems where the property is absent, the PMIC will not register
a poweroff handler, allowing other poweroff mechanisms to function.

Signed-off-by: Akashdeep Kaur <a-kaur@ti.com>
Link: https://patch.msgid.link/20260401112257.1248437-3-a-kaur@ti.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65219.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65219.c b/drivers/mfd/tps65219.c
index d3b77abec786e..5bd95e75f6e78 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -280,13 +280,15 @@ static int tps65219_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	ret = devm_register_power_off_handler(tps->dev,
-					      tps65219_power_off_handler,
-					      tps);
-	if (ret) {
-		dev_err(tps->dev, "failed to register power-off handler: %d\n", ret);
-		return ret;
+	if (of_device_is_system_power_controller(tps->dev->of_node)) {
+		ret = devm_register_power_off_handler(tps->dev,
+						      tps65219_power_off_handler,
+						      tps);
+		if (ret)
+			return dev_err_probe(tps->dev, ret,
+					     "Failed to register power-off handler\n");
 	}
+
 	return 0;
 }
 
-- 
2.53.0



