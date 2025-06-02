Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E94122A4ED;
	Mon,  2 Jun 2025 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873198; cv=none; b=tXqMHWtMwKuFWnX8ghosKFvoYoQuu+jU8Q/7GASo5ZmK0lfWnGsIBGOVbDLX3w6nKYpHd87LFIT+KhcRysZTs3pI7+Z3KIjKTN2Pp1drM4fDIM5/9GMvPbmpHFjHVObIZ4NvdFPN2XlkNfQnryl93IQ3PlD9/T249/x/iOhxbqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873198; c=relaxed/simple;
	bh=vZ2EMmDDIfzfoYHhFdnVDRQqOOwnXg9L5KGDwIdCv3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrAS0ERheeMz0qnoBHvHvdpjcZYkjn58eRkWBPC+P8E3V/WayMIL+UOSNXtCs7YYcSNDJ04+XS2duJaT68Hl/Kj94skrVJxoN9xvjZwnpvjDgoBrwo9hiUwl8xwGaEhLAiLcEmXpOsVX4Y3f1SMeDkW89YJ1782SQk95859NCPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC1aOflQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC1aOflQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA7C4CEEB;
	Mon,  2 Jun 2025 14:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873197;
	bh=vZ2EMmDDIfzfoYHhFdnVDRQqOOwnXg9L5KGDwIdCv3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC1aOflQb9eb9wNPhnQmbds2NyxAybTM6GZhM+foTSBz5AJmvzGiXve/94lqRPVYq
	 iq8Jr8cJI0JSs7dSdxCDC8vn0xdS67DZzP7jCMNIAT8Wb3mpqMjFmAhY9SgjG5mn4C
	 Li9D/QYJk+9Z/nkwkZu0hW5U/vYkdWMSXFPkCD8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/444] mmc: host: Wait for Vdd to settle on card power off
Date: Mon,  2 Jun 2025 15:42:12 +0200
Message-ID: <20250602134343.675867399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b351810a301c..dbfe0a5324eaf 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -608,8 +608,12 @@ static void sdhci_intel_set_power(struct sdhci_host *host, unsigned char mode,
 
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



