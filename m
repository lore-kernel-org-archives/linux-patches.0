Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02A11D0968;
	Wed,  2 Oct 2024 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880111; cv=none; b=FbyG7rrpGupIaNTHL48c04n9MI81+KYFpzUe4e46AJ3g39ftwm5k+TwdeYxt+YKdRnVpwopHXzNK5XqVSVvOKQ/ihWzobt0c/TUnx0HwKQSOnWk6/b5W8f18b1i49P42nueJeYXMWKk1IIhVEoDuvvOeEejk6swYYtjHfzOd7kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880111; c=relaxed/simple;
	bh=DeM5dKPCJCqJnhQeDk/t0dcJOzFIzN4QZoR85LZW4uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuIYWTA4wsh2kgYquCG+UrnXtJOzrwqMUU4IokTx1UVp8CGX2E4ScVxFFomRSNJLXi8v966ZB1u7soyd0vmj09imurh2jThozUQiN3YWmAb4WfpBXQwJhN6iaZtAsQNG/8tvi6fTXGmtD+lfoS2eSvBwaa0v0aDnoHJl//v+BVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFmt1EVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFmt1EVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491B6C4CECD;
	Wed,  2 Oct 2024 14:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880111;
	bh=DeM5dKPCJCqJnhQeDk/t0dcJOzFIzN4QZoR85LZW4uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFmt1EVJV/YFMZ15yRKeLxLrfyR+xdgy99WkK8Wtxfb2QaHhDVFiCkDjgIznp8VyA
	 Bzl/bcZ0ny/I1T9cYTN7eVnAjzdPSAHtVgY5339LyFA6Cyc4qJ5klnACu/ggRDoPC9
	 bIJG0b2rXOGSWFrQeWTgel9oNLBi+ZGH8bDdDiUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 348/538] spi: atmel-quadspi: Undo runtime PM changes at driver exit time
Date: Wed,  2 Oct 2024 14:59:47 +0200
Message-ID: <20241002125806.166322009@linuxfoundation.org>
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

[ Upstream commit 438efb23f9581659495b85f1f6c7d5946200660c ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time unless driver
initially enabled pm_runtime with devm_pm_runtime_enable()
(which handles it for you).

Hence, call pm_runtime_dont_use_autosuspend() at driver exit time
to fix it.

Fixes: 4a2f83b7f780 ("spi: atmel-quadspi: add runtime pm support")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240906023956.1004440-1-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 4cc4f32ca4490..af0464999af1f 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -726,6 +726,7 @@ static void atmel_qspi_remove(struct platform_device *pdev)
 	clk_unprepare(aq->pclk);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 }
 
-- 
2.43.0



