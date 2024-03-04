Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102A8200CD;
	Mon,  4 Mar 2024 21:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587597; cv=none; b=k9VI1tFLs9dhL4X6EH2p17ts6aLnlKVBYi+2e3pqrzm30MMdI6DbNlcqNHIjkkMJChMIBqVa6Gn2Hl4U5Cq6byN5vDyJy8EGCdup2qNpA5GEkxaRioxs3AehhlQE+0lwaKKhMkvqO5tVtAK4hZ6oRqLjzF/xBHbmowLJ8yZpAqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587597; c=relaxed/simple;
	bh=pTDTeZ/uiYPR5wGv0KCfOx6++bzXqq86Jfef6lCfATs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwgpjsiHG9BKoJDOLZcGJdagVK+UA4tjP39LOi345WxhMVpkz9o6ObkAfGiRZ3RU8k8Ew1R1W4OSLqek4gRUZ2fpxWWwZgjSyvAGR3Q0Zgbkr4GTq2NZaylrggkeo/YM3mGnt2xyB067DujcYqZv6LD6osxA4G0gTKeAUE6WYOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3jjlMZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3jjlMZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D15C433C7;
	Mon,  4 Mar 2024 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587596;
	bh=pTDTeZ/uiYPR5wGv0KCfOx6++bzXqq86Jfef6lCfATs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3jjlMZpdFwSoDFoIqEe13Bsx9Y71rPqImgsJUkSv9E7MVJ/YmkcMflxeqSUvXWQf
	 vpWgPdPbmYB0Kl0gbJxV9dRJh9YMMtqLiuRKAj8iytJSPnMHNY+62vIkSRR8PIdunL
	 bmT/ptUpx5BLW8gBO6F+0wLQnzyk/fPwY7LZQVV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 009/162] spi: cadence-qspi: remove system-wide suspend helper calls from runtime PM hooks
Date: Mon,  4 Mar 2024 21:21:14 +0000
Message-ID: <20240304211552.125642394@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 959043afe53ae80633e810416cee6076da6e91c6 ]

The ->runtime_suspend() and ->runtime_resume() callbacks are not
expected to call spi_controller_suspend() and spi_controller_resume().
Remove calls to those in the cadence-qspi driver.

Those helpers have two roles currently:
 - They stop/start the queue, including dealing with the kworker.
 - They toggle the SPI controller SPI_CONTROLLER_SUSPENDED flag. It
   requires acquiring ctlr->bus_lock_mutex.

Step one is irrelevant because cadence-qspi is not queued. Step two
however has two implications:
 - A deadlock occurs, because ->runtime_resume() is called in a context
   where the lock is already taken (in the ->exec_op() callback, where
   the usage count is incremented).
 - It would disallow all operations once the device is auto-suspended.

Here is a brief call tree highlighting the mutex deadlock:

spi_mem_exec_op()
        ...
        spi_mem_access_start()
                mutex_lock(&ctlr->bus_lock_mutex)

        cqspi_exec_mem_op()
                pm_runtime_resume_and_get()
                        cqspi_resume()
                                spi_controller_resume()
                                        mutex_lock(&ctlr->bus_lock_mutex)
                ...

        spi_mem_access_end()
                mutex_unlock(&ctlr->bus_lock_mutex)
        ...

Fixes: 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support")
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://msgid.link/r/20240222-cdns-qspi-pm-fix-v4-2-6b6af8bcbf59@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 0d184d65dce76..731775d34d393 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1930,14 +1930,10 @@ static void cqspi_remove(struct platform_device *pdev)
 static int cqspi_suspend(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
-	int ret;
 
-	ret = spi_controller_suspend(cqspi->host);
 	cqspi_controller_enable(cqspi, 0);
-
 	clk_disable_unprepare(cqspi->clk);
-
-	return ret;
+	return 0;
 }
 
 static int cqspi_resume(struct device *dev)
@@ -1950,8 +1946,7 @@ static int cqspi_resume(struct device *dev)
 
 	cqspi->current_cs = -1;
 	cqspi->sclk = 0;
-
-	return spi_controller_resume(cqspi->host);
+	return 0;
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(cqspi_dev_pm_ops, cqspi_suspend,
-- 
2.43.0



