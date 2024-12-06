Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2101494A8;
	Fri,  6 Dec 2024 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497050; cv=none; b=aUcsoXcUpkVYWDnXgmhtRB/zNPEZlZjfW+5Bo9mPGBiWv8NLMyL9LQD7ZgtEEQlS+FuymTFZOI6AKEx2yYXitFCI4hs9NFNyZEYIaU3XzGoLWTmvXxbHHvc6R2NBZeOzhri4I4jHl3gg6a+9wCIvasKkhZCd10pbev+OSkhkMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497050; c=relaxed/simple;
	bh=ZUkVIeiMnanU5OjtkKSeO8gbxoMaHCVg5znuxagsifY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQpcPoMpb8VjU21Ju3HjINwTevU00kOctL3ZSabzEYEAFpfo1W0p0NvaDv/d7VeGUUrkSx3mlOJNmPv0I2MK5QqocYwRktouy6zYsLYN9O2Mvnf4MlXQ1nYZEWpSmhCDnRHqxiUXNzSAjzjhg5GpukkdsvLKmgC5KmI7tTY3LJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5p9mvrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5p9mvrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FEFC4CED1;
	Fri,  6 Dec 2024 14:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497049;
	bh=ZUkVIeiMnanU5OjtkKSeO8gbxoMaHCVg5znuxagsifY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5p9mvrxwqOoY+bkPnzY6aiFuN2tQDiBTwj51BZvr9cY68weXJwEZbwoO3UGKeEDv
	 xG9VH4k+8tCg9oMbGPiR6+jgL3p1dombWmqoXA88fxeV2bPmzjsUNLEyNV2BK9uRDL
	 B7M9oOjt44kCOVkY/VPxXXk5Hp1Zvm5adzduXbiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/676] =?UTF-8?q?spi:=20zynqmp-gqspi:=20Undo=20runtime=20PM=20changes=20?= =?UTF-8?q?at=20driver=20exit=20time=E2=80=8B?=
Date: Fri,  6 Dec 2024 15:29:27 +0100
Message-ID: <20241206143659.133526194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 9a46b2478f4e9..3503e6c0a5c98 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1341,6 +1341,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 
 clk_dis_all:
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
@@ -1371,6 +1372,7 @@ static void zynqmp_qspi_remove(struct platform_device *pdev)
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
-- 
2.43.0



