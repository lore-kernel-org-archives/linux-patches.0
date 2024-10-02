Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F661D0BA8;
	Wed,  2 Oct 2024 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880117; cv=none; b=eWl0qqof1WrGK828FGrGTRX+1W+YvwEmA37ohbPcPeRDI/mAEYA1iDnLfzR8vQFW0Xa1NbCLnr2iN0WsWKwDL6sfaXDd53SLtsqf7UYk3XyuXQtAQPXGEdgTNOLoo/9OqeCTWgsMFiFxGi3yb+rjos68hhTCBojx5k+84ZAXR6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880117; c=relaxed/simple;
	bh=jhBF94cozvUOAy0scOnKavCOqprMFCfeRPnoQRHivrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1K/mJLwl1nM7BPoXBXT72k4JCcvCLh/2RPPTYCgbDYSIkU7yTlFB2zDqrQpY9NXS/+mHFCxNPtfUNzyWFlAC8P5zTzNNO6B2pOYDzm9xa+G0TDdCjm8inw7w/J/RJJNq+uDRgioRrq7N4mV4vBrKNj9/O6UY2eNtY37tobLgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKX/jcnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKX/jcnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144B7C4CEC5;
	Wed,  2 Oct 2024 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880117;
	bh=jhBF94cozvUOAy0scOnKavCOqprMFCfeRPnoQRHivrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKX/jcnCW96K68vDbH0hXw01MPXXt7gFy0JMDebG1iooAKAXX5QWmhUTikkFATj1j
	 2J1mnSokHpE34kC9L4Hch++7D14+hmSOJd08VV94nfC90YF0PSzcvsSNhtm7NEQU2E
	 xQoTfvR4ZIbem916/dwhIeDb2RO3ICOxzCgoQsJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 349/538] spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time
Date: Wed,  2 Oct 2024 14:59:48 +0200
Message-ID: <20241002125806.205041073@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

[ Upstream commit 3b577de206d52dbde9428664b6d823d35a803d75 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time unless driver
initially enabled pm_runtime with devm_pm_runtime_enable()
(which handles it for you).

Hence, call pm_runtime_dont_use_autosuspend() at driver exit time
to fix it.

Fixes: 944c01a889d9 ("spi: lpspi: enable runtime pm for lpspi")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240906021251.610462-1-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index f7e268cf90850..180cea7d38172 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -988,6 +988,7 @@ static void fsl_lpspi_remove(struct platform_device *pdev)
 
 	fsl_lpspi_dma_exit(controller);
 
+	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
 }
 
-- 
2.43.0



