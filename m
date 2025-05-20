Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37559242D98;
	Tue, 20 May 2025 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749623; cv=none; b=E+YH8g1GSJ/GLqZotBZUwfB8KH7LOKXxhk1MmnC+HZtVvjAZ1A8nI/9v/jVsrdZHEJPJGxDXAxLtU8Rfl4JEaYdS09Q9C98PJpua0YdA6A/SoqdDyKWpEyLPoXagJ+t7ef6/m46vb1iASBE1gMZdy9rjEImHX8njfbj6FjNs/CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749623; c=relaxed/simple;
	bh=If50mxer0qKRhG0hEo8JLT5DziJIiw8HuGS6smiO/Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uk0hjAr4AilGxUu/NxTsSHvIepdmSivgRJFYPVGLfHxpp9WiczNgehuaICkV4rk6hMJgBC7hUWpsQ4k/EEkSZW5osWxP93m67DX+AO+y+d6iEX/aPl4pzmogG+DVWrJJLtkpkQsM7tc7eCVmb1+b7y9w5wdlRpNebdIXf2+QnLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMtKc2YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMtKc2YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274FBC4CEE9;
	Tue, 20 May 2025 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749622;
	bh=If50mxer0qKRhG0hEo8JLT5DziJIiw8HuGS6smiO/Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMtKc2YAex3Dez7ZaAaf0pzvneJAZqbEHHDYY/BtDzu39n9P2tCMS27Aj2j9lMxFY
	 2a7S72C0yPhvtee0yanr+4P9xLtOwNjivt9LAD6ByuzMQNkzvd4fD9sKVKr0neR+i1
	 Ivkaa2Zbvvn7RxZvTolBfu6sskM/CUPRbbaQNAQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Zhaoyang Li <lizy04@hust.edu.cn>
Subject: [PATCH 6.1 96/97] spi: cadence-qspi: fix pointer reference in runtime PM hooks
Date: Tue, 20 May 2025 15:51:01 +0200
Message-ID: <20250520125804.416806731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

commit 32ce3bb57b6b402de2aec1012511e7ac4e7449dc upstream.

dev_get_drvdata() gets used to acquire the pointer to cqspi and the SPI
controller. Neither embed the other; this lead to memory corruption.

On a given platform (Mobileye EyeQ5) the memory corruption is hidden
inside cqspi->f_pdata. Also, this uninitialised memory is used as a
mutex (ctlr->bus_lock_mutex) by spi_controller_suspend().

Fixes: 2087e85bb66e ("spi: cadence-quadspi: fix suspend-resume implementations")
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://msgid.link/r/20240222-cdns-qspi-pm-fix-v4-1-6b6af8bcbf59@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Zhaoyang Li <lizy04@hust.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1775,10 +1775,9 @@ static int cqspi_remove(struct platform_
 static int cqspi_suspend(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
-	struct spi_master *master = dev_get_drvdata(dev);
 	int ret;
 
-	ret = spi_master_suspend(master);
+	ret = spi_master_suspend(cqspi->master);
 	cqspi_controller_enable(cqspi, 0);
 
 	clk_disable_unprepare(cqspi->clk);
@@ -1789,7 +1788,6 @@ static int cqspi_suspend(struct device *
 static int cqspi_resume(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
-	struct spi_master *master = dev_get_drvdata(dev);
 
 	clk_prepare_enable(cqspi->clk);
 	cqspi_wait_idle(cqspi);
@@ -1798,7 +1796,7 @@ static int cqspi_resume(struct device *d
 	cqspi->current_cs = -1;
 	cqspi->sclk = 0;
 
-	return spi_master_resume(master);
+	return spi_master_resume(cqspi->master);
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(cqspi_dev_pm_ops, cqspi_suspend, cqspi_resume);


