Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B3B13FD86;
	Tue, 26 Aug 2025 13:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214573; cv=none; b=PKr5lmRsPKiPKmi5rjMJ2aMpCarOgHrBYO4MEEOoPmtZ4rOwOUK2bPmGfZf5Fmd/laG8mynMx898/U63aVK/V3PyBnNRm03DfwQF3w/GWGjQ1FEFOo7s8FL7N1hubt+/IwqcGkMZGFuXiPowvl1Tjeb6Rd1BbZFWg3XuyDhqjTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214573; c=relaxed/simple;
	bh=ebvj+sHX5hNliWFjqpRc2yW0r/dtK4hA23EoN0fVT8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTR9bFNKBtxW9TDYQhRrqf79y4oH0ynIPoFV9LiBrgdcdAJCU3A19FF/wctY7Xa/le3O23J+Cy8BSk4s83yW8BEgrl3zjQm7jaCmwSkz0HljcsbWY55OKKQjauom92iMJO6eWGW/7Ia6poQZivioEhqe6486PTWG5/1FHDENso0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0A4gQjyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0A4gQjyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E533C4CEF1;
	Tue, 26 Aug 2025 13:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214572;
	bh=ebvj+sHX5hNliWFjqpRc2yW0r/dtK4hA23EoN0fVT8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0A4gQjyWm3xbjViG8HiutWBMla/7hxMWBJUNOIl70i0L32nZFG+ZJ3nzJg3K/0ITB
	 NuvYyo2OQBGubtaTBwbGp7iKf06YSGVxkUkunH7FJmRO8XMr4YdQwHmtgGAV210dhO
	 vjGqa5CtrMXDifLRoLbOzIC4qyLU+7z2k2BS/r/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/482] watchdog: dw_wdt: Fix default timeout
Date: Tue, 26 Aug 2025 13:07:14 +0200
Message-ID: <20250826110935.278168448@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 61af5d1332ac..e3e09dc38c65 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -658,6 +658,8 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	} else {
 		wdd->timeout = DW_WDT_DEFAULT_SECONDS;
 		watchdog_init_timeout(wdd, 0, dev);
+		/* Limit timeout value to hardware constraints. */
+		dw_wdt_set_timeout(wdd, wdd->timeout);
 	}
 
 	platform_set_drvdata(pdev, dw_wdt);
-- 
2.39.5



