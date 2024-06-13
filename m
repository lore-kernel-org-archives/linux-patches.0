Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0D156458;
	Thu, 13 Jun 2024 12:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281348; cv=none; b=EbGeeuXktEWQOy5tmLxf7speivyfuL0lPSlNNhgfP3oWVPNJ/TA2okyag3L3Z/ZkGix8dU8Qq/qgSkmVnVEps31hYSlZ1oRjkEvf6ImXCSJLYq9YeMKKrAQq7l+wNPuOHNxUz3aDavw6uitlOVfi8MY14RWcc26VjG/lN5/ydcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281348; c=relaxed/simple;
	bh=KtkuAShG93W1ZF2yDQCi+FZhH7ID+GyzFiTrcXapoHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy8z/k7ym8PFdDO5A9BFUL2HyKtDs32POxW9G7tnxNVoVYNtV4l9RgZz/ZeR249lTpf4VZrcdaF0X9pIc3nlanWPiS43n/WeiozYQXmexKA7Nw4sUFEmBxES5964a7hY27eyP6S3zgRmx9ZOVMQzsB3gpYkai2L3+IqHN/HLS4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLIh1ZMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLIh1ZMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C47C2BBFC;
	Thu, 13 Jun 2024 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281348;
	bh=KtkuAShG93W1ZF2yDQCi+FZhH7ID+GyzFiTrcXapoHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLIh1ZMwJELGBMNCSaZ1NBBt0vmMjNP+x+BTbqE1UQUTh3PV19peD4+U3n5Jy5vxq
	 Yd0Cim4AzyiD188ao1/R2cmwDcY0zUDvGrMG6plzLFjqn8G+xUdL8YZ8WiNDb30PAV
	 zAgAE7kRSWCNeSd7f4Jiw9sgpAHrP4vodtwAfSOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Andrew Davis <afd@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/317] mmc: sdhci_am654: Write ITAPDLY for DDR52 timing
Date: Thu, 13 Jun 2024 13:33:35 +0200
Message-ID: <20240613113255.179309279@linuxfoundation.org>
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
index 2e302c2b0ac12..13bff543f7c06 100644
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



