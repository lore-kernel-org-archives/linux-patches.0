Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA09923D2B2;
	Mon, 29 Dec 2025 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025375; cv=none; b=Uv5dspdeWmmBOH4mTkgiH1DpPpbiJz6um1p42QZiAwnPs29DO1urUF1moBt8AXU9/VvgaeAp2lNf/cocw3IWn3UVNaf7iWsT4cnWuBblCBlf6GStH7Fo+PGSQiS0R8TmW3TyTni3XLbXnS+3v6PqIyrorkPv9don3Ka20XVRc5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025375; c=relaxed/simple;
	bh=jf1eh2hrC04SwLj7hq7P3+CI82ohUuEE0twsEve7zDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOzrdr8/sBDK1SE/cmyFGMva7aL+wiNM71TKmJJ9TLeRQSZLl/O8eBstDOnwOnOXiLxcr7vHOxxGJQmbouz9tPsQztByJWt/MD4U6c0st5YYBg5z76MIFDBDHRa8b8blXX7uQdf6TwIlUFPoFqIJKPX566M5nCUQKjhuj0OGqy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyLyLToj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyLyLToj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437DCC4CEF7;
	Mon, 29 Dec 2025 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025375;
	bh=jf1eh2hrC04SwLj7hq7P3+CI82ohUuEE0twsEve7zDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyLyLTojPDiJhzQ3j63qLAqMELWhWoyGU13NXRIKXbV37yt1jffWzT+G3edULcwXO
	 V6Xiou01nxeLPVm/W4+mB8BxdAM/qsbjHsNVjahPDW/u08EonSJtGEzkDazdjLRR1z
	 l8HyxRr8fwXfLX06mn7XW6o9EGr+wOiCxKGagMtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/430] via_wdt: fix critical boot hang due to unnamed resource allocation
Date: Mon, 29 Dec 2025 17:09:53 +0100
Message-ID: <20251229160731.385306289@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 7aa31ee9ec92915926e74731378c009c9cc04928 ]

The VIA watchdog driver uses allocate_resource() to reserve a MMIO
region for the watchdog control register. However, the allocated
resource was not given a name, which causes the kernel resource tree
to contain an entry marked as "<BAD>" under /proc/iomem on x86
platforms.

During boot, this unnamed resource can lead to a critical hang because
subsequent resource lookups and conflict checks fail to handle the
invalid entry properly.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/via_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index d647923d68fe..f55576392651 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -165,6 +165,7 @@ static int wdt_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "cannot enable PCI device\n");
 		return -ENODEV;
 	}
+	wdt_res.name = "via_wdt";
 
 	/*
 	 * Allocate a MMIO region which contains watchdog control register
-- 
2.51.0



