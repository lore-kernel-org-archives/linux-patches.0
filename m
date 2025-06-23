Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7DF4315A;
	Mon, 23 Jun 2025 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714941; cv=none; b=rqDFBDrSDEXwGt9STdAYpedu654LYktgpvuL6Hcpn7arI/ernmDwJJu52PSy4KZRok82yT3R/nrzmm4jKExOYehMAHM2DsElvTJ5xQhTCHjbQiUlWfueqGzgZCS0LFL0ScXwrkXDcm5ZPYcD/lblYQGA6bX97qUBcmhulsgah9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714941; c=relaxed/simple;
	bh=Sbln8nBupkPqY+EONBP/rkGDpRWUgqRwVQ/KPp0agO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SktpQeKSnQW8ceThqWARnTCfIoaDr0gGB1mzauOdcMT0toHnhYbBQR0BZCE/T12vaAHH7VvE4Drc6LNvscQgn2nWYXi2Q+S37qzd5FahvLYhliUXeFyEArULGVVE87DeioRRyweT4zPuV2Q/xJ1XH1aihmo2WfovKeSi4ObU9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d82nib42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d82nib42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03FCC4CEEA;
	Mon, 23 Jun 2025 21:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714941;
	bh=Sbln8nBupkPqY+EONBP/rkGDpRWUgqRwVQ/KPp0agO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d82nib42RL5UkGW1JSnEtEMplabbNomIXv9fsW5x/HYsmnCXSX4GwqGwfhGYOyOPz
	 yuyU7bucL5FjA2Mbl6yJUSTBQUvaFXpyXq+f4QwEtjFQVqNUUQVkBNHj8TNNRST/OA
	 HGeBMQ7KUQOz86w7I8kUkzrQnIcxArSIgC2TW+tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 427/592] watchdog: da9052_wdt: respect TWDMIN
Date: Mon, 23 Jun 2025 15:06:25 +0200
Message-ID: <20250623130710.592166580@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 325f510fcd9cda5a44bcb662b74ba4e3dabaca10 ]

We have to wait at least the minimium time for the watchdog window
(TWDMIN) before writings to the wdt register after the
watchdog is activated.
Otherwise the chip will assert TWD_ERROR and power down to reset mode.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250326-da9052-fixes-v3-4-a38a560fef0e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/da9052_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index 77039f2f0be54..bc0946233ced0 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -168,6 +168,7 @@ static int da9052_wdt_probe(struct platform_device *pdev)
 	da9052_wdt = &driver_data->wdt;
 
 	da9052_wdt->timeout = DA9052_DEF_TIMEOUT;
+	da9052_wdt->min_hw_heartbeat_ms = DA9052_TWDMIN;
 	da9052_wdt->info = &da9052_wdt_info;
 	da9052_wdt->ops = &da9052_wdt_ops;
 	da9052_wdt->parent = dev;
-- 
2.39.5



