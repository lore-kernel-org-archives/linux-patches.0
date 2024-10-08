Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A41E485;
	Tue,  8 Oct 2024 12:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390449; cv=none; b=ShhWbNgqjIXd6HLhAIwGGjG+dRQuXDbrmCKQvN06KVaie4qpGfAfbo3JZJUIqqMKszEL+dBhmp1Eo8S6NwOJPDirSDEOaK62PkYHNLwhaWDLJWrdxocBACh5RDASFevKMjjcPsvEmhN44PChm63GLAxs8wBCW5jUbYW/Z6tWCxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390449; c=relaxed/simple;
	bh=NsMZUDq1E2lLRwo2FhjDawtgFzxrkyJTTcgKOrvEEz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnRDLTdc+G5lUdqNCuHIE080EQDSeMCI3Y3luArRuDK9pi7eGt/sMEz5b9cqctDYdNdG1M5trAA1CIL5r95CR1ScQ49DOvCWlH4D2QYk2ji+eUirhnDq3QQHUqfCjwvManVL4sFrAFbaz0gaGSqBqiZ54FvqXzhoiXdCzFTfSIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFYruFFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFYruFFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CD0C4CEC7;
	Tue,  8 Oct 2024 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390449;
	bh=NsMZUDq1E2lLRwo2FhjDawtgFzxrkyJTTcgKOrvEEz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFYruFFqpf5mqLQ/AtQdTx++5vXAySNBZ0I8bdZXtaZoqCuB8my2x1ZJ+IT0hksfP
	 fkB1SD7Om50o3W4gtnNbXsICPMlLYAsxDjmBlIuLBs5pz/E0LUhmqVFQyXlhBM/XTL
	 8lejpYbuVpLfXw+29exyOR2GqIAsEdBnhI1pkXSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 261/482] spi: spi-cadence: Fix missing spi_controller_is_target() check
Date: Tue,  8 Oct 2024 14:05:24 +0200
Message-ID: <20241008115658.555864952@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 3eae4a916fc0eb6f85b5d399e10335dbd24dd765 ]

The spi_controller_is_target() check is missing for pm_runtime_disable()
in cdns_spi_remove(), add it.

Fixes: b1b90514eaa3 ("spi: spi-cadence: Add support for Slave mode")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-4-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 316da99f798c8..81edf0a3ddf84 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -688,8 +688,10 @@ static void cdns_spi_remove(struct platform_device *pdev)
 
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
+	if (!spi_controller_is_target(ctlr)) {
+		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
+	}
 
 	spi_unregister_controller(ctlr);
 }
-- 
2.43.0



