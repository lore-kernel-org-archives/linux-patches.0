Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429CD14B092;
	Thu, 17 Apr 2025 18:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915005; cv=none; b=EzpSIHsBobT7DWDAuqgMV06HlxRUrdV5D8ufgyG4PXfHwHSDWiHgg8C8AKwn9fYWmNildlibWcIIlGS7y+xoYBf4HJcSE8qRMt5dXvkK9078gBCdV7B/Sp/LwxiVOevLJ1IQYnsckhe/pJvfW6gqD214pFrlT0KQ5giwxu4cad4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915005; c=relaxed/simple;
	bh=t+6C7S7KwrdQxZIIEXtZkRC8hCgbNjPAfZz63H8ExdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt4cJchLmGm7AvR/wSktloTMtBr9Rtr3arR4sI1OtiROmsuOkyitr3sg8HVKks1r8KtvRbu67kp5YLJvE6ObKzvK2e39uj/0VJv5eK4+foqLwvxfTjn007tW/8iC0etEi7N45vDi4lUKm4xEZjMV2MLcFUcmKSx0HDSB08XXhIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OI9Nn1q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OI9Nn1q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44688C4CEEA;
	Thu, 17 Apr 2025 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915004;
	bh=t+6C7S7KwrdQxZIIEXtZkRC8hCgbNjPAfZz63H8ExdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OI9Nn1q1LIDp4Ygq9S+sf7YmNLCkNIi2Uhru8p75Hi5p/AgWRCe9U0gyG9aZ5q/+7
	 Jej3vnhMqV5/HjhCx07usrDcy6p6CaCs1kvFJpJoCEK3gcSgnlZlVXbArzJh58SDae
	 4ju43aR7kANTq+KEb/xg/XvXZK+5EYCm1vOZx9Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 401/414] spi: fsl-qspi: Fix double cleanup in probe error path
Date: Thu, 17 Apr 2025 19:52:39 +0200
Message-ID: <20250417175127.610252237@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


