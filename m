Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBDF1C5392;
	Thu,  6 Jun 2024 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683671; cv=none; b=DM67K0OghZApAtvPLPf9BLNo/xiuS1AAxMIjEybk+ua9S4FZxwthpDAIlSSObrYxRew3+/CDzX3S43yMbmUYHaI197tgJLAyXXyhvpluswSlpbCohlHLPvSdWe0f0OrGlesNe+kSvqYA3HxWRVR+z4gHDgugHyFsyjatddkNOhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683671; c=relaxed/simple;
	bh=DtnE0Us0uYr2QmwNK+kPaICt5TeNdw1gGdeRpXFKEqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4zAeJs25IrrcPCqln2r681+fkT3I4cP9bxJRq0DBBKgG0OBWTD5Uyx20lyIvUCF+YAOCL5d5bbBxRqcHadqeXKQVV1FWNY1ZavKn4ug2BsbLu7pIfXDFSY1AkPvzVADV7UJOUORjzq9fHUOGI1+yPCIm9NZ488o5HUd5nzQmSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zU2U7uFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zU2U7uFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8657C32781;
	Thu,  6 Jun 2024 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683671;
	bh=DtnE0Us0uYr2QmwNK+kPaICt5TeNdw1gGdeRpXFKEqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zU2U7uFixYrt1FrCeh3uXOxS35Xt0041ZRFtPdRGsVGuPhjdt8TTvkSsnOFa/5axK
	 IP6MZBk9seBMESowV0hxrLV4jw77HDEeu09qIxbgRgthEKh6qE7f4HAGeTIr2errpM
	 SOjbcpZbwt0uCALrNIO1j1cR3JJaoHwfOIGdE+1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Andrew Davis <afd@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 561/744] mmc: sdhci_am654: Write ITAPDLY for DDR52 timing
Date: Thu,  6 Jun 2024 16:03:53 +0200
Message-ID: <20240606131750.457417467@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c3b07957736e9..f38fa28b99141 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -305,6 +305,7 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (timing > MMC_TIMING_UHS_SDR25 && clock >= CLOCK_TOO_SLOW_HZ) {
 		sdhci_am654_setup_dll(host, clock);
 		sdhci_am654->dll_enable = true;
+		sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing]);
 	} else {
 		sdhci_am654_setup_delay_chain(sdhci_am654, timing);
 		sdhci_am654->dll_enable = false;
-- 
2.43.0



