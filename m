Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AE7237FDF;
	Thu, 12 Dec 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019089; cv=none; b=DoYF4X3z6V27K+hv6AIPzodBQkqJ762SV1d3uqdE+uMzxozuGEjRUzaVVW5LdvpAumlZ2g5jQWsAp5NfXVYMKVt5MFsUZd8erLwPFymLUq7hogbhHe0Aop/oO2dcfMde+wJLD0UAgAlJlWpsue5vG3p8zfTRPQCK2Np0lc094Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019089; c=relaxed/simple;
	bh=pGNO3T98S57/l7kLONg0vrL3vhGDWdSKYiDeRj4e0yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+X1DMaUBXXtm8SKZmQi0w+KIiIhn2SlBL2kFjiL1B3kaPxM3TjhEl/tAF/mDgGuxcz1WXrD6g313DphOrqBBps8W/jAWOf4WYrjl42d3meAbdaGR1prVVQzH9uRUZXuXeKSKz5IcxIaMz4fBd9QpQbn9++K8KmQ5O6Mfxw4l40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/cwXjQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/cwXjQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3B2C4CEDF;
	Thu, 12 Dec 2024 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019089;
	bh=pGNO3T98S57/l7kLONg0vrL3vhGDWdSKYiDeRj4e0yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/cwXjQinNkNNiAv9NJShuhznrCEjuR+KmHh+dg8eotjaDMjmmtfo/hscD1ThI291
	 P1PhxW4qBCl6X9dY9O5HL5B1OddTx8oJ+adCgC0BplR9R2Cu8kMQfPoodeTR4b2adT
	 x8PvTcEsrz8CagvmJVZwxkHHYKEaZ5V4dijkSAG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/772] =?UTF-8?q?spi:=20zynqmp-gqspi:=20Undo=20runtime=20PM=20changes=20?= =?UTF-8?q?at=20driver=20exit=20time=E2=80=8B?=
Date: Thu, 12 Dec 2024 15:50:59 +0100
Message-ID: <20241212144354.631941721@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 2219576883e709737f3100aa9ded84976be49bd7 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time.

So, call pm_runtime_dont_use_autosuspend() at driver exit time
to fix it.

Fixes: 9e3a000362ae ("spi: zynqmp: Add pm runtime support")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240920091135.2741574-1-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 3b56d5e7080e1..c89544ae5ed91 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1219,6 +1219,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 
 clk_dis_all:
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
@@ -1249,6 +1250,7 @@ static int zynqmp_qspi_remove(struct platform_device *pdev)
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
-- 
2.43.0



