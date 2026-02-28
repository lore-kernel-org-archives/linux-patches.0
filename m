Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6156E4A33EF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300991; cv=none; b=EWpnnPNK5ufHUd4z2bJd0HTzwZduij3fle7aBWr1uDoJ1NsyjFfBl1U/R9VyVjA0RJmuktHD/6bFIkpBgCcXiFdGb2erRWsX6cZGOOm/5fXfpwlJoJxz3pr/D4kWjzxOLaYLKHNSbNWs7aIPW8jDDe5ksJjnNXRF6NnIy1gschM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300991; c=relaxed/simple;
	bh=xehgDJJWxqSQrnet2nvM18dmn5YLwSsbw02FjpyQyf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJRAOKJo8SZuPcrD59MCxt1Ew1bNHRnnF863qsHj5SAcTxcEdrbVTR+qPgQYCNoQMqc3LxvdWQ2IwOwuDVHtV8h/3vw7jztDnYlYhSkdWZmQClZ5v0xJtqht/A9eNNtrySB39VISnRUwMfbSM/I+zkSYYxTTO40YlR51ujm29ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFFtC87M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFFtC87M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0FEC19423;
	Sat, 28 Feb 2026 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300991;
	bh=xehgDJJWxqSQrnet2nvM18dmn5YLwSsbw02FjpyQyf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFFtC87Mguv2UcXZ9BrLy52CkDNQXh+abNaK1AcqSJVtTDM2DJCSlgVhOQ6DsyS2a
	 JDzNQ6RCCMzDJ7/o6hX/doDy7Hh5pUTvrNB0FOhElqtHHPn8psQwGEudfK9w3jYNtR
	 thWEE5xHgzLJhojrd8ft7cCTpgb1Dq9mXSPSLw8Oiy6/vWXc7/phk0OsebR9posAmS
	 T/baFscuSlST44Rp4Amr+NzbFdbsSVev4KE2MVVPQIseVLnyefckO0UssBF4O5vVph
	 fxcn0MiCRcMB7t1Es9au3NlzwPQOmOiYuJzlEkieJujcCETyorklIHv6FIKYnUhTee
	 bA4dIXs0OFCVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mark Brown <broonie@kernel.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/752] spi: cadence-quadspi: Parse DT for flashes with the rest of the DT parsing
Date: Sat, 28 Feb 2026 12:37:13 -0500
Message-ID: <20260228174750.1542406-122-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 9f0736a4e136a6eb61e0cf530ddc18ab6d816ba3 ]

The recent refactoring of where runtime PM is enabled done in commit
f1eb4e792bb1 ("spi: spi-cadence-quadspi: Enable pm runtime earlier to
avoid imbalance") made the fact that when we do a pm_runtime_disable()
in the error paths of probe() we can trigger a runtime disable which in
turn results in duplicate clock disables.  This is particularly likely
to happen when there is missing or broken DT description for the flashes
attached to the controller.

Early on in the probe function we do a pm_runtime_get_noresume() since
the probe function leaves the device in a powered up state but in the
error path we can't assume that PM is enabled so we also manually
disable everything, including clocks. This means that when runtime PM is
active both it and the probe function release the same reference to the
main clock for the IP, triggering warnings from the clock subsystem:

[    8.693719] clk:75:7 already disabled
[    8.693791] WARNING: CPU: 1 PID: 185 at /usr/src/kernel/drivers/clk/clk.c:1188 clk_core_disable+0xa0/0xb
...
[    8.694261]  clk_core_disable+0xa0/0xb4 (P)
[    8.694272]  clk_disable+0x38/0x60
[    8.694283]  cqspi_probe+0x7c8/0xc5c [spi_cadence_quadspi]
[    8.694309]  platform_probe+0x5c/0xa4

Dealing with this issue properly is complicated by the fact that we
don't know if runtime PM is active so can't tell if it will disable the
clocks or not.  We can, however, sidestep the issue for the flash
descriptions by moving their parsing to when we parse the controller
properties which also save us doing a bunch of setup which can never be
used so let's do that.

Reported-by: Francesco Dolcini <francesco@dolcini.it>
Closes: https://lore.kernel.org/r/20251201072844.GA6785@francesco-nb
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20251204-spi-cadence-qspi-runtime-pm-imbalance-v2-1-10af9115d531@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 1cca9d87fbde4..3689e38ebe56f 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1853,6 +1853,12 @@ static int cqspi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	ret = cqspi_setup_flash(cqspi);
+	if (ret) {
+		dev_err(dev, "failed to setup flash parameters %d\n", ret);
+		return ret;
+	}
+
 	/* Obtain QSPI clock. */
 	cqspi->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(cqspi->clk)) {
@@ -1996,12 +2002,6 @@ static int cqspi_probe(struct platform_device *pdev)
 		pm_runtime_get_noresume(dev);
 	}
 
-	ret = cqspi_setup_flash(cqspi);
-	if (ret) {
-		dev_err(dev, "failed to setup flash parameters %d\n", ret);
-		goto probe_setup_failed;
-	}
-
 	host->num_chipselect = cqspi->num_chipselect;
 
 	if (ddata && (ddata->quirks & CQSPI_SUPPORT_DEVICE_RESET))
-- 
2.51.0

