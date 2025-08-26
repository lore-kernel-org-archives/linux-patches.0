Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8904F35CEBE;
	Tue, 26 Aug 2025 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219060; cv=none; b=Xn108mIY+GAmgR3w15ReRrVtdu1o1uao4MChfjEgb0T/M5sHqPVxkpYxfb9Ae5OAESnpBnPcindHZNbNLfhTL0gJDbeyl/AG2wLyDr0McTrRJchzJSeYYfWcd4Qg/g/Ltz27Uux62OjvTllLqMEXGFno4MY2X61w686Nkw799f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219060; c=relaxed/simple;
	bh=ZU/3srY0aXpQQYG6ik6Ox5O//fHApD9saiRnYThKTOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBtXZ2xardQL+a+QocN/PxDMbICX6yXUMcQoETS+45C2d3LM9WtBIgg+1+PO/Zda1iBqw6uMrwOqMizX22AyedRxEf9/Cz0GnJCzgj/8Cwk45VrRlazgCOF198IZAQclLlXwDWQvi+mSUaHKm2BEoNDmHB1rD+iGYKn5ul7tfc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMU0HsF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMU0HsF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD89C116B1;
	Tue, 26 Aug 2025 14:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219058;
	bh=ZU/3srY0aXpQQYG6ik6Ox5O//fHApD9saiRnYThKTOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMU0HsF1YPpxktx+pht1OhkUzf8QfyTQtL+YiTs+p8wLFzJ745OoNiOmXljzUSeCB
	 LDyp849NQuxvhXqBlkB9Cu/O6G8rA+od0ny4UYs9TbKFrjtz9OYyMTreP/rxBoBDGz
	 M1mcsORMRPGbyjHAtdCFPiai0jrpyoGxjLX1q6b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 236/403] watchdog: dw_wdt: Fix default timeout
Date: Tue, 26 Aug 2025 13:09:22 +0200
Message-ID: <20250826110913.352410994@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit ac3dbb91e0167d017f44701dd51c1efe30d0c256 ]

The Synopsys Watchdog driver sets the default timeout to 30 seconds,
but on some devices this is not a valid timeout. E.g. on RK3588 the
actual timeout being used is 44 seconds instead.

Once the watchdog is started the value is updated accordingly, but
it would be better to expose a sensible timeout to userspace without
the need to first start the watchdog.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250717-dw-wdt-fix-initial-timeout-v1-1-86dc864d48dd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/dw_wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index fef7c61f5555..72dc5f4f6eb8 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -289,6 +289,8 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	} else {
 		wdd->timeout = DW_WDT_DEFAULT_SECONDS;
 		watchdog_init_timeout(wdd, 0, dev);
+		/* Limit timeout value to hardware constraints. */
+		dw_wdt_set_timeout(wdd, wdd->timeout);
 	}
 
 	platform_set_drvdata(pdev, dw_wdt);
-- 
2.39.5



