Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC133FE;
	Tue,  3 Dec 2024 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238193; cv=none; b=jIYCyXG944GWlfWKrCop5IUUa5zE/fngsCqD6LdoMoZmfCURPwUKg8FmKcXR3AiHl6NGIiaYH6N4FSwaxTPQ/mwc4BSjSvKAEBU4uqN2qmpan0z37aKP9UFWpGZKWbhggDhb2H/5Cvk5u3m2hBr1f5SCI1cqu/zfLM/c5ODKM90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238193; c=relaxed/simple;
	bh=JxkOrvxR2NvS5MuEj7yc/tPBRvRrimVz3G42/o06g4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nia8C/jarR//7SgAwPMV2dF6TvNfJM4YWMBQ+hMkGm5UZ25Zu97gSBzCn7P6OXIEp9LZjy2hW01e4rd5dALZe485pdqraWxsYnqHQlMf6Re078mWaJ7VuhqAJXH1vMY9iluHlcQ3ITyO5jGxouGiINjXgpt523lCbzSaio39fXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXyE4uaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXyE4uaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF4AC4CECF;
	Tue,  3 Dec 2024 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238192;
	bh=JxkOrvxR2NvS5MuEj7yc/tPBRvRrimVz3G42/o06g4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXyE4uaNCy78t6boRGMSfZOMQ8yfrXsx7zNyANTx+6cC4jvMOPhNlpXNvq2Mn8zwc
	 USW2Awu90jkHDTrwxLovOd/tIeUtqxaigTANty8wdnXVHR3nMZ4TTGGWyL8NVswuDj
	 JmJIvDk60CcEyv+X/L2q3mHSm2KOb+VBCjDcYg+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 193/817] =?UTF-8?q?spi:=20zynqmp-gqspi:=20Undo=20runtime=20PM=20changes=20?= =?UTF-8?q?at=20driver=20exit=20time=E2=80=8B?=
Date: Tue,  3 Dec 2024 15:36:05 +0100
Message-ID: <20241203144003.272698232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 558c466135a51..d3e369e0fe5cf 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1359,6 +1359,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 
 clk_dis_all:
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
@@ -1389,6 +1390,7 @@ static void zynqmp_qspi_remove(struct platform_device *pdev)
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
-- 
2.43.0



