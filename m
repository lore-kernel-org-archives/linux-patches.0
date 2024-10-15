Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30351AF0B2;
	Tue, 15 Oct 2024 13:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997474; cv=none; b=M1pEJEcyX9aEX2VuFsaJtCWf7s47Ql7E5HuIw9VeiVlGTFHt7y7OWOHQwEjml0Hg3V3wIn3dSlT4gYNjZoRQ1AdSSeMXTQxaDh4qf5y6RSeCE9RpV8k/aJs3Bbf0h+bfjAcGOoKS47sRJGTb4GWvi2HZBoPIrLwwGq95KyFeOeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997474; c=relaxed/simple;
	bh=PyZNc9dSmrPMHlk5NNjBuxk1IjlyoYMK2s+i4rXoe0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLvXasiS3T2KD08hrXOsyBU98FKK8hig68CNzwdgwD4PEv8omvtUJjURljl3Po3KMq35S+2KejujaOZyYcBbvB26KGKES7GbYSJ/K2xFfAeuqbggEQO1ijw90zosrdfweilUGQycl0GAY0rDp/oWFsGWxYEvRvplT08ZhzOMfzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL/iegq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL/iegq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BEFC4CEC6;
	Tue, 15 Oct 2024 13:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997474;
	bh=PyZNc9dSmrPMHlk5NNjBuxk1IjlyoYMK2s+i4rXoe0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL/iegq8P4hvR6w4dvd9+HHOYZMe95UHBEem1O26wMnUkKmHRbb2LINpyxRFYrreT
	 1oePwD/kqtepJMjCE4VXuhzkN+raunZWz9EAdVRNXAijS0oAYIv756h+86xZDIRFqa
	 UYtRyWNCCOO/hRdEkTEzxhuIuU1U4SpPrQGcgvNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/518] spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time
Date: Tue, 15 Oct 2024 14:41:37 +0200
Message-ID: <20241015123924.431785664@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 314629b172281..b6674fb6c1d67 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -948,6 +948,7 @@ static int fsl_lpspi_remove(struct platform_device *pdev)
 
 	fsl_lpspi_dma_exit(controller);
 
+	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
 	return 0;
 }
-- 
2.43.0



