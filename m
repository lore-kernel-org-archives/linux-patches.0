Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939BE1E502;
	Tue, 26 Aug 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213206; cv=none; b=uM9EqS30AMk9yVy1NcSB4yD5ehyqPTEREVO8syozUBVjI5Y3/icAuIp4l1PnSEouuVwBfrzd8xrEeZI6YE7wBXs9TT39uQD+id5q79Bm3Kl++tTg40mitS5aFfd1p+xzi9g5KICq4XxJdWj25dS7GVmB08AdC07HYRgxS0Zhsi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213206; c=relaxed/simple;
	bh=YksV+xeXTLsLhy3nXBnnwoDidHTVKN6DmFM52IsBgRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbB8Y6kBZdn08MbSAvsSFbA/bsMHT7rSqj3QEKwbn8j4C0pqh+btkf42gmVmtk7Mt5/dTTKze6lppthduUH51AJSwVUt/F7uH3JjMvGrbxVBzNxtYGg6UX2KVALVGmlpewFsSIY3gbnUVvpfJamZdWoaX3sbUT2Dz9GrviwB/mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6tThIEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6tThIEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DCFC4CEF1;
	Tue, 26 Aug 2025 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213206;
	bh=YksV+xeXTLsLhy3nXBnnwoDidHTVKN6DmFM52IsBgRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6tThIEUDKfP+lGQlQ9QKPg5XH6GU1S1uT7TZH34T3VOicMYIpqaRrni340+8cQNb
	 RrNTfZupKSgzCiF+ETJAGXYuAITirSt/nnteEWrUxUbvbuePJZzvbtB1eo5tVgz6YK
	 1axaBZJ7z+tx7EbkI7LgMinPKJoxK7M68wYjk3jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/587] watchdog: dw_wdt: Fix default timeout
Date: Tue, 26 Aug 2025 13:06:18 +0200
Message-ID: <20250826110958.759794628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 84dca3695f86..e5e6d7f15918 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -644,6 +644,8 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	} else {
 		wdd->timeout = DW_WDT_DEFAULT_SECONDS;
 		watchdog_init_timeout(wdd, 0, dev);
+		/* Limit timeout value to hardware constraints. */
+		dw_wdt_set_timeout(wdd, wdd->timeout);
 	}
 
 	platform_set_drvdata(pdev, dw_wdt);
-- 
2.39.5



