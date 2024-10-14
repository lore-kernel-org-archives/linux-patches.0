Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF6A1AC447;
	Mon, 14 Oct 2024 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918172; cv=none; b=Cef5T7Z8d14sPhf5Oy1vzTOoHVRuLMT3hOcEVI1x8f7XUWaS2ck5lFFDdBoJ1eibIZ8qGgrQjfqgqg1fymTAiTWGx6kA5V9WqvofXPgoer/Tf9rsBDx15EoI87S9O7K+PoO2m7gmVs2zBFD45X47AUX4ZJAIItsW7uJ6gD57q0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918172; c=relaxed/simple;
	bh=G8G2bMeJM03Y7Gms1fbW/PQm7TJOCw60HvAFyzn/1xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kipzMJ7FCd+l6wH+HzwEkplhEhjcNIjtcugcfngMYg4CKVAS7IsmTfBMtBr9Yph7zlC/y1Mm/WQV11afr3udVTrRk4Zqbrh8DqubTkMD+/5UBN+XgKIp+4Kuo/VItw0kYLCwpMU49qLaJwJzZGF0elGMMMk9fpH3X9ChYHv+bh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XY7iNX0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XY7iNX0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6D1C4CEC7;
	Mon, 14 Oct 2024 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918172;
	bh=G8G2bMeJM03Y7Gms1fbW/PQm7TJOCw60HvAFyzn/1xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XY7iNX0bItM+XEogLN28BFgx6++xOF5MtdQnxVoP2lZ5K+rBRXgcJ08cLl2XollbI
	 vnhGe9/dfaF/7fgEI6kYioGaB3jb5slB8kv6Rh7d7PdOiVTzRBGNj5qCYxANvHCFjL
	 3Qf4ChdOWsLUzuoJQR93CzAJt/qexky22Ss8hU4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/798] spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time
Date: Mon, 14 Oct 2024 16:13:18 +0200
Message-ID: <20241014141227.516787330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index dd2381ac27f67..7d016464037c3 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -947,6 +947,7 @@ static int fsl_lpspi_remove(struct platform_device *pdev)
 
 	fsl_lpspi_dma_exit(controller);
 
+	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
 	return 0;
 }
-- 
2.43.0



