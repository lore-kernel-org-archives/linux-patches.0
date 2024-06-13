Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F6314374F;
	Thu, 13 Jun 2024 12:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281369; cv=none; b=pqtFiX6+xAEf3JGhxAqI5q/3uTfJJZvqfiu7IqP7LTesNwnYjywsEVQO5GiYg/TgumxEYhXaGPsbOJLQ85fdqsP/BaCuYyuMOF7NVquwNr7fna2qbMKNwMrwCjiRESoc88rzRux+/FpAfSAIeyABt/d5P+ikRLCTjL0yaFgn+U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281369; c=relaxed/simple;
	bh=27vJmllSCc3hWJT8cceSF38+e/0tJGAtOZstk2o1eS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcX+XKHLlj518lu+gFx0pJ1kA+Ns9bOQu4D/zmRQ+Y9ly5nY2599sGTSEdlNQA1pZeoPpuolOFgqgy+ZnBLaWxPRE2dqkZWJHU0Bk0JHcFdr0kEqDJDTPaA5kwhkA4+mV1sjGasKrP1OZHVmrMWfYsQAYlpWGenAB5hV5U8ZIYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM0sdnWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM0sdnWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC1C2BBFC;
	Thu, 13 Jun 2024 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281369;
	bh=27vJmllSCc3hWJT8cceSF38+e/0tJGAtOZstk2o1eS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QM0sdnWIOzN7v3gUYGK7ImCOwscZ8hj4KLVpbVx0/vZN1cpnqfI17U6bzoeE1AsB6
	 pNH2C9K8iNXuTxzo/BAYOqYsLWVTbsPuDoHNSmJBbEwOf8LzmXXPrG4LlAo5HlPt0g
	 OJu08h0RoHQlbVydBTOKQNwBBP8o+kWlMb89LfkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/317] mmc: sdhci_am654: Fix ITAPDLY for HS400 timing
Date: Thu, 13 Jun 2024 13:33:39 +0200
Message-ID: <20240613113255.331825751@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit d3182932bb070e7518411fd165e023f82afd7d25 ]

While STRB is currently used for DATA and CRC responses, the CMD
responses from the device to the host still require ITAPDLY for
HS400 timing.

Currently what is stored for HS400 is the ITAPDLY from High Speed
mode which is incorrect. The ITAPDLY for HS400 speed mode should
be the same as ITAPDLY as HS200 timing after tuning is executed.
Add the functionality to save ITAPDLY from HS200 tuning and save
as HS400 ITAPDLY.

Fixes: a161c45f2979 ("mmc: sdhci_am654: Enable DLL only for some speed modes")
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240320223837.959900-8-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 879ead07f8022..9d74ee989cb72 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -300,6 +300,12 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (timing > MMC_TIMING_UHS_SDR25 && clock >= CLOCK_TOO_SLOW_HZ) {
 		sdhci_am654_setup_dll(host, clock);
 		sdhci_am654->dll_enable = true;
+
+		if (timing == MMC_TIMING_MMC_HS400) {
+			sdhci_am654->itap_del_ena[timing] = 0x1;
+			sdhci_am654->itap_del_sel[timing] = sdhci_am654->itap_del_sel[timing - 1];
+		}
+
 		sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing],
 					  sdhci_am654->itap_del_ena[timing]);
 	} else {
@@ -530,6 +536,9 @@ static int sdhci_am654_platform_execute_tuning(struct sdhci_host *host,
 
 	sdhci_am654_write_itapdly(sdhci_am654, itap, sdhci_am654->itap_del_ena[timing]);
 
+	/* Save ITAPDLY */
+	sdhci_am654->itap_del_sel[timing] = itap;
+
 	return 0;
 }
 
-- 
2.43.0



