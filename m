Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25317BBF;
	Mon,  2 Jun 2025 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876056; cv=none; b=XMozXRiYfKu8h2La8U9XqEhOGT3ipXguWQqHHHYmZxyKabzE2sEyyJ+kczg0B3XLxxlvtRTJt8xjCdpZTPCv2SspdHYQur0EvArxnhTxtsQ4j+M2GONxJlN18ch3TAAhrhgP+9wKjeu1p2qO0T9zygUxF4DbMtGbx4zQl2NJNok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876056; c=relaxed/simple;
	bh=2D6zxXE3m1vOxHG2B/jm4vLkneQXyuRahdx+HaDvLXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv62FS4L8WXUeSsXGzzodn/Ru4xhdlL07m1jZ9Z1PZf23E+sRx2JMErmauH00LAuIIaHEh0sou4qChmbmJQE55LPbwNJbrdcEOrRgD9jo30ZV2MTHzikMJanu04+7z4eq8cH00tg0DuGRxmQG8ZzkK0fATc1OPtBIrElf8iXV5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axywkFu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axywkFu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A30C4CEEB;
	Mon,  2 Jun 2025 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876056;
	bh=2D6zxXE3m1vOxHG2B/jm4vLkneQXyuRahdx+HaDvLXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axywkFu2mVKi7dKgSY9EU/0jePhMVhTTWMYiFXjuDyGg1k4qhPYjuUYBixouLEXUc
	 b0gm2QsFKvnUCAYKhJq7cRT00UTrIP4D8umR2sRrY2k+zvCopXT1ISMM5TEhw6o6Rs
	 f7Q0ZhtOLpG1EMOeHiIbmi7Im8Qs3y5aJiWKMtWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/207] mmc: host: Wait for Vdd to settle on card power off
Date: Mon,  2 Jun 2025 15:46:38 +0200
Message-ID: <20250602134259.794910230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bdb82c1265edc..b4226ba1a1b33 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -677,8 +677,12 @@ static void sdhci_intel_set_power(struct sdhci_host *host, unsigned char mode,
 
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



