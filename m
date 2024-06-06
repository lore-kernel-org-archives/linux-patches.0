Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ACF1974FB;
	Thu,  6 Jun 2024 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683475; cv=none; b=hNS4xB4J9PZhCpQm9auC096DWTEMtcmXErKPL1K1BdLfc4Y6bYimZTUFhfv4AeCUGKYq8NTHiBkEYayBgxcXvf7lFe6KFGkCJ3QJZfGnZMpcqz9rQfd/G04Xoa+5OpvlbWlBWaNlJ9uGrbI6xOvCTA4Z5YrHjD3wKmoMtNpY/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683475; c=relaxed/simple;
	bh=YSclHuZHGyXFaK3UwywMkfV+TOhHPU3VGKmGNjT3h6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kckn6ct3O8x+dgJfa6jPbTgKQewDZ6ZV1ML99zUvWRsyPD8yYtK3OLRTlY/1pWXtnbAEDyHlMPiUGjing4HJc4sys8zJQGeCHUPfFPb0vGtk7Sb85C1n/UEI6zp5PwV6ggvEOEIm7YY9For5i94kIqsFCZNfnQtwN9DhRdwF3h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNUeYdvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNUeYdvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DFEC32781;
	Thu,  6 Jun 2024 14:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683475;
	bh=YSclHuZHGyXFaK3UwywMkfV+TOhHPU3VGKmGNjT3h6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNUeYdvxHFg3XKR0pblwXz1hLsWtxrFqeY5y0Cwcl45I2q+TE6fO44pXJl3nLJI9A
	 3JviG8syBkZtUx1/DVUAnah+7I1yRjfrnLGL6q1XXPsrESu8yG9a/Z+oJJZDd2Md0h
	 uKjpMR2AVIY16VFR1V0uQHS/qsLxg91qJ+od9lxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Andrew Davis <afd@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 362/473] mmc: sdhci_am654: Write ITAPDLY for DDR52 timing
Date: Thu,  6 Jun 2024 16:04:51 +0200
Message-ID: <20240606131711.881621236@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit d465234493bb6ad1b9c10a0c9ef9881b8d85081a ]

For DDR52 timing, DLL is enabled but tuning is not carried
out, therefore the ITAPDLY value in PHY CTRL 4 register is
not correct. Fix this by writing ITAPDLY after enabling DLL.

Fixes: a161c45f2979 ("mmc: sdhci_am654: Enable DLL only for some speed modes")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240320223837.959900-3-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 1db03164af2b1..fb410a8a40799 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -304,6 +304,7 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (timing > MMC_TIMING_UHS_SDR25 && clock >= CLOCK_TOO_SLOW_HZ) {
 		sdhci_am654_setup_dll(host, clock);
 		sdhci_am654->dll_enable = true;
+		sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing]);
 	} else {
 		sdhci_am654_setup_delay_chain(sdhci_am654, timing);
 		sdhci_am654->dll_enable = false;
-- 
2.43.0



