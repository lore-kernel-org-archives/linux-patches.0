Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6862054EF;
	Thu, 12 Dec 2024 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022134; cv=none; b=Nuf1lHPPBNuwesNtAmnqtNRSLj+cade2G146+DGEQ/ELjXYGK9s2jlSufLNV8QcxguvvTdRCIOekDtNoQzbgVU1Hz2GcQ4PIHrtc/zJTu+Y8av+s7JTulEVGzmyxKFNyTfzIQMlmmjYk+IznVVihFLE9nLA/DKvIiXANSJq8ius=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022134; c=relaxed/simple;
	bh=3/EBE8y0eWsqQgAQWHdQUp1/R2esxyZXWra23eY5OXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsnmiyr74mDYv/dnKzf+eKHBGtBCxbdNmkL3jBtPgD/eEnQ8GyYIY5RejXbj3xNgeulATbVjRouChIkCKCG6QGcS03UP3xYdrBxnnMs0CII1MP9yxrUXd9dbqEL6UhCbw2UL2+jkFCgK9HnFEE3qP8Ujy0uF1X4SPG2I4FgyzR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocbYh8hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocbYh8hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A418C4CECE;
	Thu, 12 Dec 2024 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022134;
	bh=3/EBE8y0eWsqQgAQWHdQUp1/R2esxyZXWra23eY5OXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocbYh8hvyEG7qzSzMBt8L7Q6nA/VJaz6QSgx6QcSKaGox4D5RbIeDhDNZFva1Ofpm
	 rSDTajbzpQtuZCn+bbLjp3IUPQingHWFKLRKyUeiJ2us/Uf7s/W9X37Vn5xvqzVVl0
	 mfmvbaToaNw3KIuP3VZXHL03r/a1Fw9Q9o23Gkus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/565] =?UTF-8?q?spi:=20zynqmp-gqspi:=20Undo=20runtime=20PM=20changes=20?= =?UTF-8?q?at=20driver=20exit=20time=E2=80=8B?=
Date: Thu, 12 Dec 2024 15:55:23 +0100
Message-ID: <20241212144316.544731928@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 237979daf9e67..1847e3485dfea 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1200,6 +1200,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 
 clk_dis_all:
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
@@ -1230,6 +1231,7 @@ static void zynqmp_qspi_remove(struct platform_device *pdev)
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
-- 
2.43.0



