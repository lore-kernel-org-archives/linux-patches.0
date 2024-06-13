Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A551384;
	Thu, 13 Jun 2024 12:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282460; cv=none; b=COmyc7xtEGzkY7M5qeWtUNO26qqYmb32J0F16SHC6V5TGIw8YMIHdhg087khYAnt7LeizxvXf1oG5PuZMMhZ6uOH8OsJhMFdwDmL/Pv6AIKKjecpMdLNErQg+VD5/2dl0WETHBn1e3g+2gwcIwHYJ9AV6g8DpYZLYGm6yHImWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282460; c=relaxed/simple;
	bh=oVL+8O6vtsnn3x8Szj1HaP1r9LJtjTA7fc5JK6K7K5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqfa/gxdubzj7PgKRf4ruLlnY0WH48ni0Jv52pjVzCGpKmy9zl1uGsaXa395yuCrtMlx2WFLQ+XAzKeW2HKJbNVyOmb6KiyUAnetjGGCQi0a7CjXpEQj1eC67mTcbN5C/xZGbWrTOPFg7gUWoL1FZpgbhMDPSM6MuaFp2u9BpKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r39uQgs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r39uQgs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E98C4AF1A;
	Thu, 13 Jun 2024 12:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282460;
	bh=oVL+8O6vtsnn3x8Szj1HaP1r9LJtjTA7fc5JK6K7K5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r39uQgs1CdaeECuYomeZTyU3zoGe0D8C/R44a4fs1T2b6XhMHpwSp9SRjDADO3tu1
	 FUVP6YPnLK0UcUBP26R3HOWt/5GiLF/o8j+Xn5tWWYlnVFgFJ/MgFwI1gWbajhbGsQ
	 GuYr6d/E95sSPAfYHzb36teaUw5VY8AzMhvAUs2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/402] mmc: sdhci_am654: Fix ITAPDLY for HS400 timing
Date: Thu, 13 Jun 2024 13:33:31 +0200
Message-ID: <20240613113312.054644085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9cdc5e7889b45..230b61902e39d 100644
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



