Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C4B1D1F5A;
	Wed,  2 Oct 2024 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878517; cv=none; b=OPnxAprynbwL0xzycyxd4KtYixvaaqu8UMd86vVT4dNaSWfUwjkaZmlDLeQAswRtQm9iw9zR5VbH7DaiXQUuvkqLnHNzAl0IaqCGiH+yMQUQSM8YUR1f7zbEzITwALGVpZ2H56mW7ab2vx/9XZWoD+Bh6FTftmlfMJJO/kHZHIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878517; c=relaxed/simple;
	bh=ivT0M+R6wR5UnDYmmAZQRriVGmdcJyMucJACPhL3I/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hm5i3b0g+jIkYuzsu6CRsCGZTITWgDJ51Icng9OE/CL28qFi+MTxz/3UXZk69C4IOZM2XAj13J6nRpswwIjQ0NbV5DZlSYODTozxBd/z5zPPCD9du4yfpC4BytTgR5eNShHjtVp/GOsGHj+g+VTSV0vzqdhawwq1JITzEtD4kQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKluwvI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKluwvI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF7CC4CECD;
	Wed,  2 Oct 2024 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878516;
	bh=ivT0M+R6wR5UnDYmmAZQRriVGmdcJyMucJACPhL3I/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKluwvI2F/XujZtstfhuLTNmKNFrAglBwMcOfOyNcrsD+OrmWd5KgnMA+FF2vtpo+
	 lQKeTZvShPP1bF65Gwrty5TzOXSO1sTAn8dnnafyjcH4sALBSq56fEQiAJ6ATigCoz
	 D6lSs6vowwz6+wLr7bWTF4YEJSbvTrUjF4ejS3X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 409/634] spi: atmel-quadspi: Undo runtime PM changes at driver exit time
Date: Wed,  2 Oct 2024 14:58:29 +0200
Message-ID: <20241002125827.251489356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index 5aaff3bee1b78..466c01b31123b 100644
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



