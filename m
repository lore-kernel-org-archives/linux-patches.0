Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9D24BEE54;
	Sat, 12 Sep 2026 09:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205258; cv=none; b=dJUowxXPrtL2UMh/LsFAwjMcOsMLOMMxLlZJsl2lmmrYD2IrRM1hVgTrseBIFfG4N3dSEGLSZkQ3p53b7GvR3b034Fa4lKy7vO7d4HfB4FR+tTvxfhZKDXNu8iUyaL878RInU4L1cLlHYRpNCvjJEyeEQEdA2PF608+9pivNZdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205258; c=relaxed/simple;
	bh=QDELX3IwR+X8H6gtWUNgkxoumFtlo+hJmfD9s+ikHrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcKMJuC4oMYNCo7tiNTu9vOEiq+nVhtjxJgxGaJW2X540p7k7+syEdLnZCW7i5wipgT/XhVpoEyMpckNiPgcQ6+wBuLIWV/vVwL6rYyW88vXwnebS35u/fjYy9OMldXWdKoFXphoYXb5KEsJFXVlXLBPBDl6kytTJFgAmSUGS6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxJrSuAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxJrSuAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F831F000FF;
	Sat, 12 Sep 2026 09:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205257;
	bh=13SFbnE7GgBkYC09Aoof4X8NVAp1zvaJcMN55E3ScNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxJrSuAWAj92zPfVahxXYfZOoiOfIQ1++/t8tg/H1dimYlhK4uty65RBvqNMox45D
	 k0mO7blUgCR6sf5FfWBYt2h126TUnE18EPjWe5gfkMP0k6gtIIG8GkRawzhbfJA/YA
	 RaMtMPFdOwsBXee3mh22ZpTumu9HbKIwjQbjcDm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zhilkin <csharper2005@gmail.com>,
	Vitaliy Sochnev <sochnev.v.74@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1779/1815] net: phy: air_en8811h: move LED GPIO configuration to config_init
Date: Sat, 12 Sep 2026 08:58:49 +0200
Message-ID: <20260912065730.783901845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Sochnev <sochnev.v.74@gmail.com>

[ Upstream commit 03b4702fc5e311cbac9ba8654021a88f0dac914c ]

The LED GPIO pins (GPIO3/4/5, mapped to LED2/LED1/LED0) are only ever
configured as outputs once, in .probe(). But .config_init() restarts
the MD32 MCU via en8811h_restart_mcu() on every call after the first
(priv->mcu_needs_restart), and that restart resets buckpbus-mapped MCU
state, including EN8811H_GPIO_OUTPUT. As a result the LED GPIOs fall
back to inputs after the first event that re-triggers .config_init()
(link renegotiation, ifdown/ifup, resume), and the PHY's LEDs stop
reflecting link/activity state even though they worked right after
probe.

Move the GPIO-as-output configuration from .probe() to the end of
.config_init(), so it is reapplied every time the MCU may have been
restarted.

Fixes: 71e79430117d ("net: phy: air_en8811h: Add the Airoha EN8811H PHY driver")
Suggested-by: Mikhail Zhilkin <csharper2005@gmail.com>
Signed-off-by: Vitaliy Sochnev <sochnev.v.74@gmail.com>
Link: https://patch.msgid.link/20260823130638.1166453-2-sochnev.v.74@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/air_en8811h.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/air_en8811h.c b/drivers/net/phy/air_en8811h.c
index edd49c193e476..0eeb7b9a4e260 100644
--- a/drivers/net/phy/air_en8811h.c
+++ b/drivers/net/phy/air_en8811h.c
@@ -1173,13 +1173,6 @@ static int en8811h_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	/* Configure led gpio pins as output */
-	ret = air_phy_buckpbus_reg_modify(phydev, EN8811H_GPIO_OUTPUT,
-					  EN8811H_GPIO_OUTPUT_345,
-					  EN8811H_GPIO_OUTPUT_345);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
@@ -1324,6 +1317,17 @@ static int en8811h_config_init(struct phy_device *phydev)
 		return ret;
 	}
 
+	/* Configure led gpio pins as output. Must be redone on every
+	 * .config_init(), not just once in .probe(): en8811h_restart_mcu()
+	 * resets buckpbus-mapped MCU state (incl. this register) on every
+	 * call after the first, e.g. on link renegotiation or ifup/ifdown.
+	 */
+	ret = air_phy_buckpbus_reg_modify(phydev, EN8811H_GPIO_OUTPUT,
+					  EN8811H_GPIO_OUTPUT_345,
+					  EN8811H_GPIO_OUTPUT_345);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
-- 
2.53.0



