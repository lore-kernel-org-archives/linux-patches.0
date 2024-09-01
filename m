Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D6E44C97;
	Sun,  1 Sep 2024 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207751; cv=none; b=cznvBjAzveREbcMPGAA7GmhQSWEx+jCP38UL5afZtYcHV3sMB0Taoqj2STv63i27iEoErbTvQEU39w8a0FULaU1tPKtyki02vZUe0vHwko6DbLxRHpd5E1A0DFPA3piSLUgVUNztCOwDufSzDIQb192KqoXB5ZKXjit0DWPjVpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207751; c=relaxed/simple;
	bh=vazMM4pc3Ah2cFlln451tohtr3iw03OBjJw82PjNeQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X43ojxEiCstQKWz6GLTouhYYzLPPkKt3Dx3bXHWvEMG+xoy5O6hCTFYQuoM2KnFxhh2oqqU7hl8iTWNIK9YvrHMiLfxl0HE38h1DdYOhq8rMBPCJjPtatdPbbMyXlpFR7ChOut8egTX57u3fL/6wQFWH09g54AIUY4lhlm4lasc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGrZtfXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGrZtfXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEA9C4CEC3;
	Sun,  1 Sep 2024 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207751;
	bh=vazMM4pc3Ah2cFlln451tohtr3iw03OBjJw82PjNeQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGrZtfXXmdEAUU+0Vo9pjs9Zqnvb/lNEVXfhc3adGsgIl4JWYS57HNkt/Hxj/swUZ
	 e2LhLRVdR89qHPiK/haya0YTCq2fEzExLZYRz9I5wktii5ZgySduH9ujhbavQ9GcHv
	 nJ4tD5hIPEVnmxXHWOWtpb3XP+xPffNL4IM2VCPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Whitten <ben.whitten@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 67/98] mmc: dw_mmc: allow biu and ciu clocks to defer
Date: Sun,  1 Sep 2024 18:16:37 +0200
Message-ID: <20240901160806.224893419@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Whitten <ben.whitten@gmail.com>

commit 6275c7bc8dd07644ea8142a1773d826800f0f3f7 upstream.

Fix a race condition if the clock provider comes up after mmc is probed,
this causes mmc to fail without retrying.
When given the DEFER error from the clk source, pass it on up the chain.

Fixes: f90a0612f0e1 ("mmc: dw_mmc: lookup for optional biu and ciu clocks")
Signed-off-by: Ben Whitten <ben.whitten@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240811212212.123255-1-ben.whitten@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -3205,6 +3205,10 @@ int dw_mci_probe(struct dw_mci *host)
 	host->biu_clk = devm_clk_get(host->dev, "biu");
 	if (IS_ERR(host->biu_clk)) {
 		dev_dbg(host->dev, "biu clock not available\n");
+		ret = PTR_ERR(host->biu_clk);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
 	} else {
 		ret = clk_prepare_enable(host->biu_clk);
 		if (ret) {
@@ -3216,6 +3220,10 @@ int dw_mci_probe(struct dw_mci *host)
 	host->ciu_clk = devm_clk_get(host->dev, "ciu");
 	if (IS_ERR(host->ciu_clk)) {
 		dev_dbg(host->dev, "ciu clock not available\n");
+		ret = PTR_ERR(host->ciu_clk);
+		if (ret == -EPROBE_DEFER)
+			goto err_clk_biu;
+
 		host->bus_hz = host->pdata->bus_hz;
 	} else {
 		ret = clk_prepare_enable(host->ciu_clk);


