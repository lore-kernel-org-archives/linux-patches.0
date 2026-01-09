Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591B22EBBB2;
	Fri,  9 Jan 2026 12:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962290; cv=none; b=Wd8WKb9XVVJFv//0fvH/kjeDLLpCazFYvwwx0KVIRsCrKWYFolgUJZ5uVTnLrlCJrXl3oabhaipKDHezqPbMZe+RMtZTq6O8spb/MDoLaq7MaJ76zgIU6rjFNuzqc3NvQUgE9rrT+n/XN6ykbGLVQwIb8oUTyqs8KxCmoCUrBDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962290; c=relaxed/simple;
	bh=349IrlhydBZaTQetTJmM8iA2730BlGiExxIKmp3kNQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk6s1od9EdI8BTKiQHjT6GaZo/mgp5/vyCgBVaBNcwaCUQMpY6SRHFxUdDsHaYyUvubJ3sdpZHDDypIPB+RRpXLjgRshrhkXcciXAlMuvRgPG+RIoU0+WEGmSh8aI03NhdiOiyBG4VDmr6dayDofIUvEy4jw1BVjlMwjsVNWw7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fa356CLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fa356CLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD88DC4CEF1;
	Fri,  9 Jan 2026 12:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962290;
	bh=349IrlhydBZaTQetTJmM8iA2730BlGiExxIKmp3kNQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa356CLJ0s00AQDm+LiTKzNnE/n6pDlf1IgOKWvuEuw4KZjjz73nDfjn4wbX/xBRt
	 zwHUIz8X9kt72bAxQMjq4zsskK/jlsXng7ZBsSZoEsXtTYm2wQ2ga9pt9EQyHi6dr5
	 RnZDZRDONJpGh/H1mD3+7njNgSKqguVwj3xt+JJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 280/634] spi: cadence-quadspi: add missing clk_disable_unprepare() in cqspi_probe()
Date: Fri,  9 Jan 2026 12:39:18 +0100
Message-ID: <20260109112128.069212948@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5cb475174cce1bfedf1025b6e235e2c43d81144f ]

cqspi_jh7110_clk_init() is called after clk_prepare_enable(cqspi->clk),
if it fails, it should goto label 'probe_reset_failed' to disable
cqspi->clk.

In the error path after calling cqspi_jh7110_clk_init(),
cqspi_jh7110_disable_clk() need be called.

Fixes: 33f1ef6d4eb6 ("spi: cadence-quadspi: Add clock configuration for StarFive JH7110 QSPI")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20231129081147.628004-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1889dd208197 ("spi: cadence-quadspi: Fix clock disable on probe failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index af0ec2a8c647..cb094ac3f211 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1789,7 +1789,7 @@ static int cqspi_probe(struct platform_device *pdev)
 		if (ddata->jh7110_clk_init) {
 			ret = cqspi_jh7110_clk_init(pdev, cqspi);
 			if (ret)
-				goto probe_clk_failed;
+				goto probe_reset_failed;
 		}
 
 		if (of_device_is_compatible(pdev->dev.of_node,
@@ -1836,6 +1836,8 @@ static int cqspi_probe(struct platform_device *pdev)
 probe_setup_failed:
 	cqspi_controller_enable(cqspi, 0);
 probe_reset_failed:
+	if (cqspi->is_jh7110)
+		cqspi_jh7110_disable_clk(pdev, cqspi);
 	clk_disable_unprepare(cqspi->clk);
 probe_clk_failed:
 	pm_runtime_put_sync(dev);
-- 
2.51.0



