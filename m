Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B71207A26;
	Mon, 18 Aug 2025 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524023; cv=none; b=XnoH2Qx3bDZbpd3GcfYBvC41H7O8oyKS9WSNNicwlIRKIEoSvHfwMBmj3NmwVYa5KKnWF3ibqi5sxzCfEpj3cNeR30Ar9gG2IPM+ixOZmbtICbB6TqtsM3WMcPzufyDgttA5axe0eHpN5eP95SXLFEWZPYXAUiLjO9mbaiXO9Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524023; c=relaxed/simple;
	bh=M/gghEN2KNqhpsMSt53N92/MVsR+SJsb+duVa0gGhw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGIRTCx0qxViC7gB9nUisr9pUj5Qt6z5T7ljISBpEdCr3e0habAqTRFO+PhQeCSulr0TWdZqxIPb3eaP4uG0Rdxds1WiRRh84J4IggX5czIeI1Npte/6Vg2ByDSD8aXjymlY/13cL4boBsIq+nw7uuY0gUD7JLaDjjcozQmWitQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcW1t/H4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcW1t/H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00E1C4CEEB;
	Mon, 18 Aug 2025 13:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524023;
	bh=M/gghEN2KNqhpsMSt53N92/MVsR+SJsb+duVa0gGhw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcW1t/H4zjFywR790Tr+KlniZ5jCITW/3Z7QnDX5JmCiwFDoxeUoUNBjoaJ702q3C
	 RGo6r9Z0rivnYTT/yhyHcTwiZ6qA45keuIs2+MSlSpEz6HO9sFKGND8OGm+pzQer7o
	 Aj2XKPWkzCD5cVXuZx9kka/E4P0nLKVsrJwX4z9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 344/515] watchdog: dw_wdt: Fix default timeout
Date: Mon, 18 Aug 2025 14:45:30 +0200
Message-ID: <20250818124511.671172765@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index 26efca9ae0e7..c3fbb6068c52 100644
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



