Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0333C1C07ED;
	Tue, 15 Oct 2024 13:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998012; cv=none; b=JTqTv332R/ijpXbF8JOB3ff0p8GREQZYwDo2gB0JD13SqyI35k/vB15x1OQVxsDox1NoNiFsiJ2PY7MI5gzq6tXC233eiw6Zz2QVlRxZHDRl2m7NOjnOF3/PSt2vCJ7v50JDE7TJrDn9WVibTM/L/Wz1MhgoBU36rIKBikQPZ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998012; c=relaxed/simple;
	bh=hq/RDSwd40QLrSZNn2WUPHfghWoR2kDC6LF5euU+L7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KysXbdRrYpxuZSss+TLJZlaYqq9HRM5XnVch2HnjbsM3BnoBDN32nYNfbLFQOh3+/5TYOKQioIZSMmKZgBcZMPi7vc2UhJtvASA/P9atu+Lv6Rh8f7gE6CjwtiuUN7ZttAYIDnBpnsqdiAFhmRFBv+lzWjCiAUX0du5uOec/YBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT2q5W2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT2q5W2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BCAC4CEC6;
	Tue, 15 Oct 2024 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998011;
	bh=hq/RDSwd40QLrSZNn2WUPHfghWoR2kDC6LF5euU+L7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT2q5W2eZFrSgaC65SIDlApRlMKxoFEOR4kVtCdhmPG6+UtJOQAKeQw/paIQDNSh1
	 /6weVq0ItSFbpKZ42kh8mg215LFdkqL87UbJggsFbsiqhNznhtrkdMrog0DQ8a/W8O
	 ehArnS37t83JvIRmFOB64Ra4af6NrLWuGT9y9US0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/518] spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue, 15 Oct 2024 14:44:18 +0200
Message-ID: <20241015123930.630288648@linuxfoundation.org>
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
index 8566da12d15e3..f1a0073a8700f 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1756,8 +1756,8 @@ static int spi_imx_probe(struct platform_device *pdev)
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



