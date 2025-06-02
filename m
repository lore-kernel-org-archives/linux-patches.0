Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37E01C5D72;
	Mon,  2 Jun 2025 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874674; cv=none; b=BMW943wxpTc5D0wQoXvnS6c44BjZ9XUxoaMp/vtSameUaGiegx86MHZZCgixqZv/+ZycUnLtnB0fsSnqkIZczvfpee68lA5aRtf2HfWoLQ7PbmbWVHwSQDEhRW802A4t4tg8/zI5xtBXQQhaBpwZ7H0LyZuR7YZanmHBKCHwWQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874674; c=relaxed/simple;
	bh=Jx99gOmDCBkOIF91tVVk6tJAAWwG4cOylcOeJZfII98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJLIXT5vnjnR9WjrspwCiUjZ3vvyjyqNgaRE65HtvK3VuXFUg2qi8BxKHmmzAtnTCAsudvb6r6UjDLusIz7crGahcO4R7a8ayk9TCktv9jjPOEVZJ7E2gEcQhO4J6j+WAL2a4VoErWyFgqy83AAG2dbv6DBvnmQ8gZjLiCJVQWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEyW1j6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEyW1j6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D0DC4CEEB;
	Mon,  2 Jun 2025 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874674;
	bh=Jx99gOmDCBkOIF91tVVk6tJAAWwG4cOylcOeJZfII98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEyW1j6LKl0O+1VT5Ac/wQsfzzTh2HgHwM2nady66Z+aTKGIstS3DJF4ErzLXRySK
	 3uY9c4W1Po8Larfr3Xnte9fD2cdHIqpsIy/x36TITF30cJN9Pfr9GEgWdeV3JO+YS0
	 M1AtIWsEWN4Nks+Ylv5CkSBNprz9SZYYZQ0K/xdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/204] mmc: host: Wait for Vdd to settle on card power off
Date: Mon,  2 Jun 2025 15:47:12 +0200
Message-ID: <20250602134259.552961649@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 390caef1bdabc..22978057b94a1 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -669,8 +669,12 @@ static void sdhci_intel_set_power(struct sdhci_host *host, unsigned char mode,
 
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



