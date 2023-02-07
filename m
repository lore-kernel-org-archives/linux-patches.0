Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68C3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682E7C433EF;
	Tue,  7 Feb 2023 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774835;
	bh=ZVwd7qLwLutn6xAlJaCXlNgWjze9eIxop3gFdqN6Myk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9sgYNq94NwARxeI6nOHAGInCdThHhe87I2WGZ8sNZlXyZoT5O49lywyNtVv6v4SZ
	 4F8tndfdp8bZifi/YiKwso+W8Q1fwiAAAPHMCf1KJR8Mzi3vO/LJmyWXYqq1Sohfll
	 RUJvnw3ufbuP5POMPuUnvne1b5GWC6ZA3gpcOrRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <mindal@semihalf.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/208] net: wwan: t7xx: Fix Runtime PM initialization
Date: Tue,  7 Feb 2023 13:55:02 +0100
Message-Id: <20230207125636.461686119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kornel Dulęba <mindal@semihalf.com>

[ Upstream commit e3d6d152a1cbdee25f2e3962009a2751b54e2297 ]

For PCI devices the Runtime PM refcount is incremented twice:
1. During device enumeration with a call to pm_runtime_forbid.
2. Just before a driver probe logic is called.
Because of that in order to enable Runtime PM on a given device
we have to call both pm_runtime_allow and pm_runtime_put_noidle,
once it's ready to be runtime suspended.
The former was missing causing the pm refcount to never reach 0.

Fixes: d10b3a695ba0 ("net: wwan: t7xx: Runtime PM")
Signed-off-by: Kornel Dulęba <mindal@semihalf.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 871f2a27a398..226fc1703e90 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -121,6 +121,8 @@ void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev)
 	iowrite32(T7XX_L1_BIT(0), IREG_BASE(t7xx_dev) + ENABLE_ASPM_LOWPWR);
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_RESUMED);
 
+	pm_runtime_mark_last_busy(&t7xx_dev->pdev->dev);
+	pm_runtime_allow(&t7xx_dev->pdev->dev);
 	pm_runtime_put_noidle(&t7xx_dev->pdev->dev);
 }
 
-- 
2.39.0



