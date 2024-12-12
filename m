Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CCB222D4A;
	Thu, 12 Dec 2024 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023174; cv=none; b=YwXEA+nDgbtcTaQDUApUDZWjR6p3Lmw1DUUAi/mlVugU+eS2jvtu4w7NiLz6uo1Rs/w00kqPfnhNYlMDsanwlFS2jW8bs8SOdmtpAxzcoppBAumQ24WfF3tL1NbPTWe58ssbcDPylETsZEmghL5tl35qHXDkx2SL0iT1khQIrxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023174; c=relaxed/simple;
	bh=4KLpK2KQuBOYisYrlrENrPvqqubw7Oaib+4LRMJ0AL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZUITZZlP2qxOXipyt5GlSxtTKZYzLFCk35xyo7SeF9BFRcPYunMGrmg9v37DXhB2+fRpIvwf2soxMBtQVQOLMSX1N6XVAb4P00bym8BcgSJFZBdP5GQ8RnlnBbsOnq+sR9COO3/D25FEPk+sAODGw7NdBevv4HiJC2bsJK1Ydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtG1FYCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtG1FYCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A06C4CED3;
	Thu, 12 Dec 2024 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023173;
	bh=4KLpK2KQuBOYisYrlrENrPvqqubw7Oaib+4LRMJ0AL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtG1FYCUduqwqQO4f2RnPo34gYQMrsgRmsFvmRutsOUqqFV8bETrZYms3+QXowhV9
	 TAM7bPMtLWSQnyd8bgkRmwB8Wwp5n4aHL4yZa1Wq4tLBMjXOVIhbKdgHd3+0nSox9g
	 J8x+TlQJk8EqnfJz9hE6eD2Ud6+efinvs0g5k6iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.15 446/565] watchdog: rti: of: honor timeout-sec property
Date: Thu, 12 Dec 2024 16:00:41 +0100
Message-ID: <20241212144329.336780295@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 4962ee045d8f06638714d801ab0fb72f89c16690 upstream.

Currently "timeout-sec" Device Tree property is being silently ignored:
even though watchdog_init_timeout() is being used, the driver always passes
"heartbeat" == DEFAULT_HEARTBEAT == 60 as argument.

Fix this by setting struct watchdog_device::timeout to DEFAULT_HEARTBEAT
and passing real module parameter value to watchdog_init_timeout() (which
may now be 0 if not specified).

Cc: stable@vger.kernel.org
Fixes: 2d63908bdbfb ("watchdog: Add K3 RTI watchdog support")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20241107203830.1068456-1-alexander.sverdlin@siemens.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rti_wdt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -54,7 +54,7 @@
 
 #define MAX_HW_ERROR		250
 
-static int heartbeat = DEFAULT_HEARTBEAT;
+static int heartbeat;
 
 /*
  * struct to hold data for each WDT device
@@ -242,6 +242,7 @@ static int rti_wdt_probe(struct platform
 	wdd->min_timeout = 1;
 	wdd->max_hw_heartbeat_ms = (WDT_PRELOAD_MAX << WDT_PRELOAD_SHIFT) /
 		wdt->freq * 1000;
+	wdd->timeout = DEFAULT_HEARTBEAT;
 	wdd->parent = dev;
 
 	watchdog_set_drvdata(wdd, wdt);


