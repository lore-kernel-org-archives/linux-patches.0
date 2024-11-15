Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57D13BBEB;
	Fri, 15 Nov 2024 06:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653041; cv=none; b=UShQ7xj7piMwy1ihE6DcvmijsyBFjgAk7t592bnQ5ri63OWj6ZriLp21kL68khoBDQR+6GIUMlVy0pg4yFol0/xUSPS921kI8fDQ7gXfBs2KGCl3O4H5EgTCGMuHsa0D6mJWJMyCBZ1xREzQJPrxZwLipta97NKvDOT+cbENWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653041; c=relaxed/simple;
	bh=KRudr+lpCrf/n6CBqCzBDBJathAFgC2s/Lk7Bl3o0es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOqIW3SLVwofIyxe6qccSNBL0SV8PvRRJGxwMTGlOLsj/ybD7PXCMK4JceTms7eItw5y2o3z5sZdKkQ8zl47Cnc43lQaZ/1955YaXVEWZFc5Dscyy2eOis9Kwv3rYX00ZsCWrV0lhvxaI9QXYXNAuGrCgxWT9yuQbQrCsSa+7aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iH5D3uhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iH5D3uhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23960C4CECF;
	Fri, 15 Nov 2024 06:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653041;
	bh=KRudr+lpCrf/n6CBqCzBDBJathAFgC2s/Lk7Bl3o0es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iH5D3uhhZB/+BAfp6wGko5tznTfKi1UEuvMzFqEVH34OzeLBosP0iWgL7SGxy8GYv
	 zyy9iFUMzyNDQ9MuLMM7/ElrWYiiu4kjpv1IYh+ELzKBw1N82VBqS4EhK1UFW81/a4
	 QBsyE6pmQXUBBbbGS1C8QOxpQWdw+dEX+fORXE1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lukas Wunner <lukas@wunner.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 36/66] spi: fix use-after-free of the add_lock mutex
Date: Fri, 15 Nov 2024 07:37:45 +0100
Message-ID: <20241115063724.149498736@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <michael@walle.cc>

commit 6c53b45c71b4920b5e62f0ea8079a1da382b9434 upstream.

Commit 6098475d4cb4 ("spi: Fix deadlock when adding SPI controllers on
SPI buses") introduced a per-controller mutex. But mutex_unlock() of
said lock is called after the controller is already freed:

  spi_unregister_controller(ctlr)
  -> put_device(&ctlr->dev)
    -> spi_controller_release(dev)
  -> mutex_unlock(&ctrl->add_lock)

Move the put_device() after the mutex_unlock().

Fixes: 6098475d4cb4 ("spi: Fix deadlock when adding SPI controllers on SPI buses")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.15
Link: https://lore.kernel.org/r/20211111083713.3335171-1-michael@walle.cc
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2670,12 +2670,6 @@ void spi_unregister_controller(struct sp
 
 	device_del(&ctlr->dev);
 
-	/* Release the last reference on the controller if its driver
-	 * has not yet been converted to devm_spi_alloc_master/slave().
-	 */
-	if (!ctlr->devm_allocated)
-		put_device(&ctlr->dev);
-
 	/* free bus id */
 	mutex_lock(&board_lock);
 	if (found == ctlr)
@@ -2684,6 +2678,12 @@ void spi_unregister_controller(struct sp
 
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
 		mutex_unlock(&ctlr->add_lock);
+
+	/* Release the last reference on the controller if its driver
+	 * has not yet been converted to devm_spi_alloc_master/slave().
+	 */
+	if (!ctlr->devm_allocated)
+		put_device(&ctlr->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 


