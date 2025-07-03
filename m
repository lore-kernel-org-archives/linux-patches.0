Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E352EE299;
	Thu,  3 Jul 2025 14:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554535; cv=none; b=CEf5dJZnlV8Q6igZ03LpMJePFJYv4dpUKJfeEQ3Wym3graWDcMzYIYwUnnNiBF82I4z2zOx1CUBxMOV1UQcggkDDAYMQ+nbPTjNnSjG3K4nYTJRAiUsOi0IOUnEM/WDdm0qr54p/gbwq+zc/ptEqoK+R/N4OaWiSO/wVieMlzlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554535; c=relaxed/simple;
	bh=xEa2onxehLLm1lSEbpCWYj+cCqA015sF32T99m1ex+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBfcl5gAIIVEnGNVblo5IX4/C+EwFj+jL1r/ELMPVaJvV90EGgoM1lW6WcH+7Td1FooklrqnPzz2oKgWdlSoy2z32SCdO8CUNzT0ywdnf0mWUpj/P7mXCNNY1eXfhpcVUB7C0ENnYIJD1HhpW+E28p06XvimCXQKw25LTwiIMfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLVXdPxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLVXdPxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B441C4CEE3;
	Thu,  3 Jul 2025 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554535;
	bh=xEa2onxehLLm1lSEbpCWYj+cCqA015sF32T99m1ex+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLVXdPxW9vQZ+2Sd2ZZfCAJj8VHy6RAeZLoeZxIKRFjBE4CQvNasQTIxyw9kAp9+n
	 pgopEfR0vkUQhIIMbJ9xlD/q36TBq+F5EL+HjszH6LbIL2LGdtH0EFmYBzJ9z7U2n5
	 RRyB2txvESt3udCg2bjljAZVfqkomFGx2n6KTT0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/218] spi: fsl-qspi: Fix double cleanup in probe error path
Date: Thu,  3 Jul 2025 16:42:46 +0200
Message-ID: <20250703144004.932689395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 5d07ab2a7fa1305e429d9221716582f290b58078 ]

Commit 40369bfe717e ("spi: fsl-qspi: use devm function instead of driver
remove") introduced managed cleanup via fsl_qspi_cleanup(), but
incorrectly retain manual cleanup in two scenarios:

- On devm_add_action_or_reset() failure, the function automatically call
  fsl_qspi_cleanup(). However, the current code still jumps to
  err_destroy_mutex, repeating cleanup.

- After the fsl_qspi_cleanup() action is added successfully, there is no
  need to manually perform the cleanup in the subsequent error path.
  However, the current code still jumps to err_destroy_mutex on spi
  controller failure, repeating cleanup.

Skip redundant manual cleanup calls to fix these issues.

Cc: stable@vger.kernel.org
Fixes: 40369bfe717e ("spi: fsl-qspi: use devm function instead of driver remove")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Link: https://patch.msgid.link/20250410-spi-v1-1-56e867cc19cf@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-qspi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index 5c59fddb32c1b..2f54dc09d11b1 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -949,17 +949,14 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 
 	ret = devm_add_action_or_reset(dev, fsl_qspi_cleanup, q);
 	if (ret)
-		goto err_destroy_mutex;
+		goto err_put_ctrl;
 
 	ret = devm_spi_register_controller(dev, ctlr);
 	if (ret)
-		goto err_destroy_mutex;
+		goto err_put_ctrl;
 
 	return 0;
 
-err_destroy_mutex:
-	mutex_destroy(&q->lock);
-
 err_disable_clk:
 	fsl_qspi_clk_disable_unprep(q);
 
-- 
2.39.5



