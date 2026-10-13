Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770C13F6C42;
	Tue, 13 Oct 2026 12:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894509; cv=none; b=h/yNw9MSZisab+RgyxH7Jx1QBUmpzY023FcNdjcONCA7IaENnj/5nhEBA4nJeu21j31mthpu+gAnV900ZVpUgK0vF2dVxqR6uM4AYTDlqDL/Oi5Osx9dqMQl3pYBm3HE8f5e3AhM6WxhwaAHVncLz9q7aSKoR0CefLvzpqKMGng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894509; c=relaxed/simple;
	bh=qos2/H/wi5knvJ6MiwhjyNB0O/L2jbYAMdvWUb0akQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNCPHhCzHqns8097YrYg9qPN3IfrUTzJW7bmnxBHQkaP9ibVI6s0pUV+g5Howz0NYThP6VkkUz13kEhJzjmLOKeTfLlHiDjhs56eRFSxkItwJ2HYztjuSileDit42CqKhde6LgMlgdIfus1uL4lda2J5CQ43P2WZb/pFkbfV46Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIUxcFnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIUxcFnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6D41F000FF;
	Tue, 13 Oct 2026 12:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894508;
	bh=/BOGVWKQCQjOh4qwAqYYOg1yhuJnm0VIf59UbpeXD/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIUxcFnWRbWwOuoea0qx96lbj2anQG8hi9mZUjHanwd6tpjvnNj9N7ZUlEZuPZork
	 S4/eTE922ZWzDQRuKLFNI9lZciDVY2KMCAJhEtS9SZUO6XlGwaiGDiCm8f7cvui5kK
	 3F5lLRTELw+k5tjpfK+AD6XM51oYG6zD10GhtbSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 577/621] spi: sg2044-nor: Return transfer errors
Date: Tue, 13 Oct 2026 13:39:32 +0200
Message-ID: <20261013112934.500227148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <gaohan@iscas.ac.cn>

[ Upstream commit e130c54fbb603f9aeacf5029789b4a2c8c48f416 ]

The transfer helpers return errors, but both dispatchers discard them.
Return these errors to the SPI memory layer instead of reporting success.

Fixes: de16c322eefb ("spi: sophgo: add SG2044 SPI NOR controller driver")
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20261001-fix-sg204xspi-v2-1-014dbaf22b5e@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sg2044-nor.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-sg2044-nor.c b/drivers/spi/spi-sg2044-nor.c
index 37f1cfe10be46..8aeba7d9a2120 100644
--- a/drivers/spi/spi-sg2044-nor.c
+++ b/drivers/spi/spi-sg2044-nor.c
@@ -307,15 +307,15 @@ static ssize_t sg2044_spifmc_tran_cmd(struct sg2044_spifmc *spifmc,
 	return 0;
 }
 
-static void sg2044_spifmc_trans(struct sg2044_spifmc *spifmc,
-				const struct spi_mem_op *op)
+static int sg2044_spifmc_trans(struct sg2044_spifmc *spifmc,
+			       const struct spi_mem_op *op)
 {
 	if (op->data.dir == SPI_MEM_DATA_IN)
-		sg2044_spifmc_read(spifmc, op);
+		return sg2044_spifmc_read(spifmc, op);
 	else if (op->data.dir == SPI_MEM_DATA_OUT)
-		sg2044_spifmc_write(spifmc, op);
+		return sg2044_spifmc_write(spifmc, op);
 	else
-		sg2044_spifmc_tran_cmd(spifmc, op);
+		return sg2044_spifmc_tran_cmd(spifmc, op);
 }
 
 static ssize_t sg2044_spifmc_trans_reg(struct sg2044_spifmc *spifmc,
@@ -389,19 +389,20 @@ static int sg2044_spifmc_exec_op(struct spi_mem *mem,
 				 const struct spi_mem_op *op)
 {
 	struct sg2044_spifmc *spifmc;
+	int ret;
 
 	spifmc = spi_controller_get_devdata(mem->spi->controller);
 
 	mutex_lock(&spifmc->lock);
 
 	if (op->addr.nbytes == 0)
-		sg2044_spifmc_trans_reg(spifmc, op);
+		ret = sg2044_spifmc_trans_reg(spifmc, op);
 	else
-		sg2044_spifmc_trans(spifmc, op);
+		ret = sg2044_spifmc_trans(spifmc, op);
 
 	mutex_unlock(&spifmc->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct spi_controller_mem_ops sg2044_spifmc_mem_ops = {
-- 
2.53.0



