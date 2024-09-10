Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7E0224F6;
	Tue, 10 Sep 2024 09:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961923; cv=none; b=FtfvZVH0eWEsNhOgbTEf19AlEcQzd3oM8dEIMxqoff5JCRoCGL2pL1hXpQJDZDpJ37k1X66T9q/69H9NMMKIQrT1z90BNtk4I7VwLui/2RnaVlwHSC79ou7nITPQVM5TJ0LHhnkKBV90lvSivCtzqeWIHloh1NqM2Qe5AcIlsIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961923; c=relaxed/simple;
	bh=jG3n6NSL44iUR9m3x64qAgw9ItC5W58veXuAp5pFwhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uThNGZkCB8ycM/dWk+fjyGCWm2dZUdlRz3GsmOpIu3rz7WJU6ePlqE/5aR0qnZKrYGsAGsDL5YOG6J13h9pZ8CfaoEyUDl+8UJTpFWIWAoZAsZoh83mwv3jZxraxIkfxT51w6NIpipBaIzb/SpLkxdqvu7b+A/pueYMVMRkE8bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfuv6KtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfuv6KtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8EAC4CEC3;
	Tue, 10 Sep 2024 09:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961922;
	bh=jG3n6NSL44iUR9m3x64qAgw9ItC5W58veXuAp5pFwhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfuv6KtOOu+hGms5c2+G+mVof3DzFj7EBIRX1QfIu+DoGSe7GyoxTssc3RiWXrv+g
	 n4+8D0uvlazr38eLKpikvicEEtvjjTPQywP01QJ0i4drWjiNK5rGDJ+B24ymjybR0Y
	 roD5PziJTu92oUdPtG3eECNgJ3tCVm7Yfip2zx5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 235/375] watchdog: imx7ulp_wdt: keep already running watchdog enabled
Date: Tue, 10 Sep 2024 11:30:32 +0200
Message-ID: <20240910092630.441090352@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit b771d14f417e9d8030ab000b3341cf71266be90e ]

When the bootloader enabled the watchdog before Kernel started then
keep it enabled during initialization. Otherwise the time between
the watchdog probing and the userspace taking over the watchdog
won't be covered by the watchdog. When keeping the watchdog enabled
inform the Kernel about this by setting the WDOG_HW_RUNNING so that
the periodic watchdog feeder is started when desired.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240703111603.1096424-1-s.hauer@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx7ulp_wdt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/watchdog/imx7ulp_wdt.c b/drivers/watchdog/imx7ulp_wdt.c
index b21d7a74a42d..94914a22daff 100644
--- a/drivers/watchdog/imx7ulp_wdt.c
+++ b/drivers/watchdog/imx7ulp_wdt.c
@@ -290,6 +290,11 @@ static int imx7ulp_wdt_init(struct imx7ulp_wdt_device *wdt, unsigned int timeout
 	if (wdt->ext_reset)
 		val |= WDOG_CS_INT_EN;
 
+	if (readl(wdt->base + WDOG_CS) & WDOG_CS_EN) {
+		set_bit(WDOG_HW_RUNNING, &wdt->wdd.status);
+		val |= WDOG_CS_EN;
+	}
+
 	do {
 		ret = _imx7ulp_wdt_init(wdt, timeout, val);
 		toval = readl(wdt->base + WDOG_TOVAL);
-- 
2.43.0



