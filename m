Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879F21D88D7;
	Tue, 27 May 2025 17:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366568; cv=none; b=eHJeqCefHra7ofKkH9BxtGclKcPX09tL0eSYeetHHay0rRzpDR1HQjxEUWwdq2KEiluk6soN1ClcJ16HZZ+0mEmkqMwFgWKs5MGm5ePImqbqmFS/edcJRDH0yw4mNBM7NxEJLxSKRSUsFm3gOyu/Br2/ufn0IxVyoVhOQtA8OIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366568; c=relaxed/simple;
	bh=IkZqhT/iDipMcj+hsl25sGXnXz3en4q6NP7bBsYPnPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kn+ShoiYXq6tvpGqC/P4Kp5YruXe0nymuoqdFe1Rox0bRa58ibiIHhxOWshPwrwrm4lPKROUnfrhSNKPwyDOXsgpign0hoRklDpaaOibQZEB0lIVdcXXx3DzDDFqofJ+RhI2SklT/0zeW5CGSqFK/KwU+8o8KWiJLIHkUsreuZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgT9dVsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgT9dVsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1269BC4CEE9;
	Tue, 27 May 2025 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366568;
	bh=IkZqhT/iDipMcj+hsl25sGXnXz3en4q6NP7bBsYPnPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgT9dVsUE9v+cJ2mEY75NMV50pe3tXllIORGEfnlMZ0Kk3vOypunTc3XhdeVqQ0zA
	 XUIyBuINgrIG9HYxw8xNO1RfBsucqY5tB6mS+W/Zm7WcFRTT0BIE6l26Jd8gu4ZQRH
	 7vrkihmIZbaznkljDDtWCpLu13BaiXKvucoJlCyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 110/783] mmc: host: Wait for Vdd to settle on card power off
Date: Tue, 27 May 2025 18:18:27 +0200
Message-ID: <20250527162517.631187550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erick Shepherd <erick.shepherd@ni.com>

[ Upstream commit 31e75ed964582257f59156ce6a42860e1ae4cc39 ]

The SD spec version 6.0 section 6.4.1.5 requires that Vdd must be
lowered to less than 0.5V for a minimum of 1 ms when powering off a
card. Increase wait to 15 ms so that voltage has time to drain down
to 0.5V and cards can power off correctly. Issues with voltage drain
time were only observed on Apollo Lake and Bay Trail host controllers
so this fix is limited to those devices.

Signed-off-by: Erick Shepherd <erick.shepherd@ni.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250314195021.1588090-1-erick.shepherd@ni.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 1f0bd723f0112..13a84b9309e06 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -610,8 +610,12 @@ static void sdhci_intel_set_power(struct sdhci_host *host, unsigned char mode,
 
 	sdhci_set_power(host, mode, vdd);
 
-	if (mode == MMC_POWER_OFF)
+	if (mode == MMC_POWER_OFF) {
+		if (slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_APL_SD ||
+		    slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_BYT_SD)
+			usleep_range(15000, 17500);
 		return;
+	}
 
 	/*
 	 * Bus power might not enable after D3 -> D0 transition due to the
-- 
2.39.5



