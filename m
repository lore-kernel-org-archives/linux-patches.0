Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629C4434
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFEDC433EF;
	Wed, 15 Mar 2023 12:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882938;
	bh=NCntH6LXIMwjKURQYZds+5+7mmadtr57G3tQYD/TDTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POWavEDpfUSnwym+MIZcE0V928xWFx9f2oZf6j3weqeC2dp/6efbO7RDWJ+xBStwq
	 qFh76EQyaHwd8/lHAnjdu6AItcU6DNsZOgGPQAw9OBI4rd6maAvySx+uktBhuYNiTc
	 zmNxEzkXOVcAYKudzi4eIv62+U4TP0VryRbE9ygM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/104] PCI/PM: Define pci_restore_standard_config() only for CONFIG_PM_SLEEP
Date: Wed, 15 Mar 2023 13:12:29 +0100
Message-Id: <20230315115734.414134864@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 18a94192e20de31e7e495d7c805c8930c42e99ef ]

pci_restore_standard_config() was defined under CONFIG_PM but called only
by pci_pm_resume() (defined under CONFIG_SUSPEND) and pci_pm_restore()
(defined under CONFIG_HIBERNATE_CALLBACKS).  A configuration with only
CONFIG_PM leads to a warning:

  drivers/pci/pci-driver.c:533:12: error: ‘pci_restore_standard_config’ defined but not used [-Werror=unused-function]

CONFIG_PM_SLEEP depends on CONFIG_SUSPEND and CONFIG_HIBERNATE_CALLBACKS,
so define pci_restore_standard_config() under that instead.

Link: https://lore.kernel.org/r/20220420141135.444820-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: ac91e6980563 ("PCI: Unify delay handling for reset and resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 8b587fc97f7bc..bbaecc2340371 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -499,9 +499,9 @@ static void pci_device_shutdown(struct device *dev)
 		pci_clear_master(pci_dev);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
-/* Auxiliary functions used for system resume and run-time resume. */
+/* Auxiliary functions used for system resume */
 
 /**
  * pci_restore_standard_config - restore standard config registers of PCI device
@@ -521,6 +521,11 @@ static int pci_restore_standard_config(struct pci_dev *pci_dev)
 	pci_pme_restore(pci_dev);
 	return 0;
 }
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM
+
+/* Auxiliary functions used for system resume and run-time resume */
 
 static void pci_pm_default_resume(struct pci_dev *pci_dev)
 {
@@ -528,10 +533,6 @@ static void pci_pm_default_resume(struct pci_dev *pci_dev)
 	pci_enable_wake(pci_dev, PCI_D0, false);
 }
 
-#endif
-
-#ifdef CONFIG_PM_SLEEP
-
 static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 {
 	pci_power_up(pci_dev);
@@ -540,6 +541,10 @@ static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 	pci_pme_restore(pci_dev);
 }
 
+#endif /* CONFIG_PM */
+
+#ifdef CONFIG_PM_SLEEP
+
 /*
  * Default "suspend" method for devices that have no driver provided suspend,
  * or not even a driver at all (second part).
-- 
2.39.2



