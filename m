Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879B1E1C1A;
	Sun,  7 Sep 2025 20:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276823; cv=none; b=VgO5TlA4PRGOr2eGaKH7eVyU9nDgMGvUXsyl3lBBi1S64zWe1gnktH1q+41gDkFexnfsGc4rwwg2o61zHm1QAoIXRGtXWcPARpbAgh1Rj2fm/YVll4BOJvCGIBrkWa6QB4GUOtVmtlEeptyfwLxU1npN+e3dv5ODZfj1Sk+KhMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276823; c=relaxed/simple;
	bh=QZLTYNsLXQmw2hFCdasjjObk/do61j69fM2mjIf9rDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qURBIC7OXqb3D1cSyUfQdqYXm1c0TezLsVVkV3sHbrb244iSZAUTUbpBDdSjdU7n/bTu766qsOnT/fP4yODSFc/pwM51EjnUGVuEP8VP3CKOCRvYE1k2Gh0XqLm660P6KmwqUfNuup6s22TXgwlCiV5BeUbO/vUVZu7BVZI7Bt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDynahrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDynahrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16C6C4CEF0;
	Sun,  7 Sep 2025 20:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276823;
	bh=QZLTYNsLXQmw2hFCdasjjObk/do61j69fM2mjIf9rDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDynahrGukbVS01xaGS2GQpjEg+u0Vxn3LcoJjPplruck2QhLoWqLiv/kM9T2pkEk
	 GQWBo76fRU6I4q1t84RUniruSFbASLSoKHmrabnxY/qmS0bdln188Biqe5P1Q/l6SD
	 fQCh6t8etUvT49LTP9y+JV87Pjp/OjjpiMGBR1E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 121/121] spi: fsl-qspi: Fix double cleanup in probe error path
Date: Sun,  7 Sep 2025 21:59:17 +0200
Message-ID: <20250907195612.957747535@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit 5d07ab2a7fa1305e429d9221716582f290b58078 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-qspi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -943,17 +943,14 @@ static int fsl_qspi_probe(struct platfor
 
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
 


