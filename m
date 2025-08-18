Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CA428C849;
	Mon, 18 Aug 2025 13:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522342; cv=none; b=tN+COhN/gRHBwTX7McE2qHZBoUKflCmQLeL0J4cMRCLgr/FBw8yiGO8yiHi2nbM5spXJI11QOx9vNt+7Vwp+IIjEgPyYyH+DJgSnYHmqIHdERlce8nJszR0D1DeqWCw5WvBA4r62pBsHyqNAcH5taVYeGKoczEyhZOu5B2nCZqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522342; c=relaxed/simple;
	bh=TgS5Po55zlQWLIteRZwK7/aM3/Zn/JJz020PCFDA1i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOmGQxpqTFLQ4OHuMZCDi4id6be14lJSUgwZMzG+Ho+iUCs1JSWEL4FWdNI8tGlmherI5LfrCrqZN93oryBpk73IRJgaB4k5O6jsIZbPcvHcfrDohiXIDhIfaBSPDBbeCnO8a5lVJxPa91dZOxuwy7/Or5ENtJLlRRA199EJduk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0VNn7aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0VNn7aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246FBC4CEEB;
	Mon, 18 Aug 2025 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522341;
	bh=TgS5Po55zlQWLIteRZwK7/aM3/Zn/JJz020PCFDA1i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0VNn7aNHMgdgxOp7XGyCZR9ZhsbBcXUze/SgyzNR9BdOakYdtfH0Kvj6rNHPCG4h
	 jGlzgNc7N3sA51LfVqffYrldO+zlBOZ7ZC9oGvw+80Vp3e66VmGKw83jNR5Qv618b2
	 osp5ys0lu0qiLCalFczy+E7Rcsx2owlvKWqa/6kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/444] watchdog: dw_wdt: Fix default timeout
Date: Mon, 18 Aug 2025 14:45:12 +0200
Message-ID: <20250818124459.686923765@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



