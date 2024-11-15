Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB8185924;
	Fri, 15 Nov 2024 06:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653836; cv=none; b=UGtraxZiVpxlkkhOkz6OT7ltTQqLuQLIkgD/ickhEOJ5HuFthMfftodWUXNHFMU0r9GQt6PsyYcZbJRXiUobmCdeGSWqOvZgVQKduDNdKO4uUwpNUX8dYQlF0ocpOQKkRQOIs1ubCs99ulX/DzmofQuZGNc2vEnXXDwrJCMgNCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653836; c=relaxed/simple;
	bh=a0WsMdOsRfxH/kOqi8zfl90T8Kmffqp8OYICIlqyKJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XYK7EfkUv2jivgIluaDwTh0bKuMvzejZ8bE4I+4eztDB+24UZ83BZ7Q/2Iuansls9nsiGFn7mGo5/I6waUmFgFb8DGNf62DUgKdECn7FU7DiDznQ25QpvHeD1R8l1Kt3ndDw9Vb9DrY3qyYtkrD1dSk36HqXTuyYgPlay/aHI5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwHdPfr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwHdPfr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157EEC4CECF;
	Fri, 15 Nov 2024 06:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653836;
	bh=a0WsMdOsRfxH/kOqi8zfl90T8Kmffqp8OYICIlqyKJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwHdPfr0JsF3HWc55BZ17dZJuzeUvyYjzUTjnkEd/xZ+O1dQVkB1xOVHO5Pbw28Qp
	 H4qCr9AhiJt8f3TluFzWpafl5U6zbbdq5m+dwAR+mRgJZcoT4UKH24bW4lifVlKevW
	 6aA1jdO4Wi4O9XJAjdgYpZgMnlLT6pIrLd8B4iZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lukas Wunner <lukas@wunner.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 49/82] spi: fix use-after-free of the add_lock mutex
Date: Fri, 15 Nov 2024 07:38:26 +0100
Message-ID: <20241115063727.326163828@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2892,12 +2892,6 @@ void spi_unregister_controller(struct sp
 
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
@@ -2906,6 +2900,12 @@ void spi_unregister_controller(struct sp
 
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
 


