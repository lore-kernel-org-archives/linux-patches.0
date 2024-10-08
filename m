Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221C9165F08;
	Tue,  8 Oct 2024 12:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390430; cv=none; b=cONf82nA0SjhBeHKVZsRiBC5z/2/HYnyfOcANuqwH4mNhT+vzvQllfcirhe0WJz91nFiZDuU1X8djiaz9W+dneM55DwCxeACr3Tjtxv1z4lCxjI16wT1VYdZ73heBi4S3uMc3Vv4xAuIYx8ra+Xb86vFVJJ5d4OAwaJianNhxnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390430; c=relaxed/simple;
	bh=5x1g4UHHWb2icSBDwi3edTOpwV5XSyxudVoixeWYh0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVArY8bwMzpLR8A5Efx+CGahhu7+NlCq6X13q7Z/RVmD6ojvGFKqrMGyJ/xMhj0RWJfFfBtdlq6IXTvQM6FjzGW7kO0Xb/SF80DYjndWtJavZtFAHjgr9i2wUiZIGykI+MkMEUrPeFlyZj4RgCnHop733LJ3gl9mY6sYPV80Pqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEvmBpQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEvmBpQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D0AC4CEC7;
	Tue,  8 Oct 2024 12:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390429;
	bh=5x1g4UHHWb2icSBDwi3edTOpwV5XSyxudVoixeWYh0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEvmBpQiCBJd+YNXv8hkk+rvM4UE/JQT0xBaRH7Tw9LuwP6xVq7tK1pF64EoDI5z3
	 28qG2Q/QiVWm8QEUDgVCXOCJmqloP2HP3khy7Ftc93Bi9GF+KHwh/KRcBUfDs60mJh
	 c4fxuU3Sfu/mVNbcmOmpRz+l+WeCyrqaQMGTKkvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 259/482] spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:05:22 +0200
Message-ID: <20241008115658.478422734@linuxfoundation.org>
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

[ Upstream commit b6e05ba0844139dde138625906015c974c86aa93 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 43b6bf406cd0 ("spi: imx: fix runtime pm support for !CONFIG_PM")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 1439883326cfe..4c041ad39dc5d 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1870,8 +1870,8 @@ static int spi_imx_probe(struct platform_device *pdev)
 		spi_imx_sdma_exit(spi_imx);
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(spi_imx->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	clk_disable_unprepare(spi_imx->clk_ipg);
 out_put_per:
-- 
2.43.0



