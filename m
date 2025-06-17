Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15412EA147;
	Tue, 17 Jun 2025 16:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178151; cv=none; b=R/fClQFtY3cacy66v8UrL2u3nfZTMhShk+1f/2pUvlqzp7IKODuNYdXRVWIx6CNt7OLkd5m2lPceyv7IwiBJNjsbjquqD69CDQbkW4/d6TwvLm/Vt1kvEU6PTsXDrnf5xoJgp+BhoftT+7zWmAbmeLoLZICszkdG1Pe+C6OSMyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178151; c=relaxed/simple;
	bh=xlOyCqLHWtmn4sJa9t++RkvJFVeuxT6Gfu1YMOrMFdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRoIVCGmgWNKV3+NnzqS5b1J7Lz0dfPo7uAIXi4apIpbw2q4BAtS2e/jlqs9yZmD7EVdIQ1akxO2njCkdNiHn5MritdSURCR45fvONhlN6PSJ8TLIvEyUBOHGuoKc1RGcYrC1oRBy3J/tVPXB4pZp8ANvVqPfhkY2BjFq/VV6sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkeLZK0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkeLZK0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA8EC4CEE3;
	Tue, 17 Jun 2025 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178151;
	bh=xlOyCqLHWtmn4sJa9t++RkvJFVeuxT6Gfu1YMOrMFdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkeLZK0+bwU5jaYF4jaKqCeYxS8hZJNCrnf+CdSKRH/rR71h8irHDUy1v8ClAcMFK
	 iAIEKhOnsWlwNYFSb81EYJaJolN/BATuqQe7VBm1y+vG9DvdhBHVseqw8OxZqLAXA0
	 EyQJdQagqzK0rcAHlwzCqV32SwYxei0az6p/ue2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 417/780] watchdog: lenovo_se30_wdt: Fix possible devm_ioremap() NULL pointer dereference in lenovo_se30_wdt_probe()
Date: Tue, 17 Jun 2025 17:22:05 +0200
Message-ID: <20250617152508.454060398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit a4e2401438a26131ecff9be6a3a1d4cbfea66f9a ]

devm_ioremap() returns NULL on error. Currently, lenovo_se30_wdt_probe()
does not check for this case, which results in a NULL pointer
dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: c284153a2c55 ("watchdog: lenovo_se30_wdt: Watchdog driver for Lenovo SE30 platform")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250424071648.89016-1-bsdhenrymartin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/lenovo_se30_wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/lenovo_se30_wdt.c b/drivers/watchdog/lenovo_se30_wdt.c
index 024b842499b36..1c73bb7eeeeed 100644
--- a/drivers/watchdog/lenovo_se30_wdt.c
+++ b/drivers/watchdog/lenovo_se30_wdt.c
@@ -271,6 +271,8 @@ static int lenovo_se30_wdt_probe(struct platform_device *pdev)
 		return -EBUSY;
 
 	priv->shm_base_addr = devm_ioremap(dev, base_phys, SHM_WIN_SIZE);
+	if (!priv->shm_base_addr)
+		return -ENOMEM;
 
 	priv->wdt_cfg.mod = WDT_MODULE;
 	priv->wdt_cfg.idx = WDT_CFG_INDEX;
-- 
2.39.5



