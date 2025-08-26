Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6019C30AAD8;
	Tue, 26 Aug 2025 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217842; cv=none; b=hzp0X4XJkoO9Wkxz8ZY4NQ9DdlyHRLfE6b28ilf6mXBJhOZydgWow1V8x2C2CRKSE1m04+SlPXfrUxQFQdnUDZTq5qFh1vipHRBarzhf95XWUku603RjB2qtaDvAj2UuFOk/zfFQfdRKJPzCM9/xj3gZ9g0iCyu3kZfVSUqpF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217842; c=relaxed/simple;
	bh=avyLKn5hxhCWmPEzwW3OALl2ENPKCS3yR3sBM+gncmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA/QeCJJIU/56FXVlbcskptGsKlGoj2VNM8dngPDCmmpxWmteWdpLGOPFiumupWxjvr9ESKSZBvOWozdHNazDPCizVZ24cgr+2D2OXFtAeqiSoeV5o1dimF9d74Tja4fQG7QjHQ25clVTkVobe2L+dCSvABQTGkEjzEcghCFEO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEbhDoaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEbhDoaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BE8C4CEF1;
	Tue, 26 Aug 2025 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217842;
	bh=avyLKn5hxhCWmPEzwW3OALl2ENPKCS3yR3sBM+gncmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEbhDoazruF0tVwNglICNhznPm6rWLgxUL0QI7x2+9iQWbiWyjvhmK6QfVA9eFfcb
	 m+Jrgnkc/Jz75P1C6ReMMEAJX/hxhLAh41r72OqvHj6GKGZNZIjtaohPFlwk6Hqbif
	 XemEC5NwSyNlZ3Xuaai+DjCpZyaRi2WfWGEQvWCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/523] watchdog: dw_wdt: Fix default timeout
Date: Tue, 26 Aug 2025 13:08:25 +0200
Message-ID: <20250826110931.726587422@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3cd118281980..d18530bafc4e 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -661,6 +661,8 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	} else {
 		wdd->timeout = DW_WDT_DEFAULT_SECONDS;
 		watchdog_init_timeout(wdd, 0, dev);
+		/* Limit timeout value to hardware constraints. */
+		dw_wdt_set_timeout(wdd, wdd->timeout);
 	}
 
 	platform_set_drvdata(pdev, dw_wdt);
-- 
2.39.5



