Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE013A5433;
	Thu, 30 Jul 2026 14:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421793; cv=none; b=Et2/6XBEdeEzoXBBLuFdbj6ZhBDc9/9kBlAM5xdvZ5rlWMVWxCYw2dHSLvoe5kVxuMbGml46pY+cRO8gfRI/+4Q36MoKTNZ3dmLctc6EUSJvYax3NfeRvUOSSqPhWr65yz0khOSBFa6W891CQh7r9smxmli1Qm3ExaswS+q1yVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421793; c=relaxed/simple;
	bh=64CVORiZtko00jYPRXAUpsU7sTgJmgENorWFRwMtKNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSXO7TCEoWH69mJBhPxzQCai51iaM42mTWc9RuYQ5Xtv//4R+Lwaf5zPKb5DdqnY7U2+/NPYuUA19/Y52zi9Cn7e46aQe+muiernf+ow4oTTTwHfUqCc+RFLEKyoma+MXwZs1OLB5KH9D3V2iSMTIAGSJKtS4yuONSBXBTy1saY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Puz3CMhw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Puz3CMhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF631F000E9;
	Thu, 30 Jul 2026 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421792;
	bh=lTFNSP4VinGzX9J1OQy1IcBqr7bXbCDd0KLM9hopVNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Puz3CMhwaKULSgmGbWdi5qDvenIvVe/0+BCqGyuHW+mz1cmV99uc6hkfnPlDrFr/l
	 v61WigVV9Z7bTEzhIatGbJuVeh1qmc66/yy8THYPB4FxoWdHubxKHn1gXohh4rYBv4
	 PC2uM61Fja9Mgzu6n8ZumH4gh77RTg0erSK9G0QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 177/744] watchdog: airoha: Prevent division by zero when clock frequency is zero
Date: Thu, 30 Jul 2026 16:07:30 +0200
Message-ID: <20260730141448.048839031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen Yan <win847@gmail.com>

[ Upstream commit bcfcd7619f277842430d197556463b401b839ee9 ]

clk_get_rate() can return 0 when the clock provider is not properly
configured or the clock is unmanaged. The driver uses wdt_freq as a
divisor directly in airoha_wdt_probe() to compute max_timeout and in
airoha_wdt_get_timeleft() to compute the remaining time, which results
in a division by zero.

Add a check for wdt_freq == 0 in probe and return -EINVAL with
dev_err_probe() to prevent the division by zero and provide a
diagnostic message.

Fixes: 3cf67f3769b8 ("watchdog: Add support for Airoha EN7851 watchdog")
Signed-off-by: Wayen Yan <win847@gmail.com>
Link: https://lore.kernel.org/r/178347932594.81327.4834644880399144119@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/airoha_wdt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/airoha_wdt.c b/drivers/watchdog/airoha_wdt.c
index dc8ca11c14d81a..4bd333189b87ec 100644
--- a/drivers/watchdog/airoha_wdt.c
+++ b/drivers/watchdog/airoha_wdt.c
@@ -147,6 +147,9 @@ static int airoha_wdt_probe(struct platform_device *pdev)
 
 	/* Watchdog ticks at half the bus rate */
 	airoha_wdt->wdt_freq = clk_get_rate(bus_clk) / 2;
+	if (!airoha_wdt->wdt_freq)
+		return dev_err_probe(dev, -EINVAL,
+				     "invalid clock frequency\n");
 
 	/* Initialize struct watchdog device */
 	wdog_dev = &airoha_wdt->wdog_dev;
-- 
2.53.0



