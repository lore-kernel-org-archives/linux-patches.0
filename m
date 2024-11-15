Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B41885B3;
	Fri, 15 Nov 2024 06:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653830; cv=none; b=lgor9aKKLDZvCDvsb5+0Ofen4WH8LVQNDNGc77IspKHS6Vvbrh8ul1B4PSU0sfc8vRfYNwGzVqGQ5ISkpE/AVADX0WjyXI/f2K8oxsLZzM+1IKmxxdvRw0Ov3Zls8JGH4P3pXU151Xk/e2PtnkEznNPBHqJh5rFY+FfUy3gWDKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653830; c=relaxed/simple;
	bh=3AEHGZeRrlR2ZFtbkmSqc8zwz+y0Znz5EkdJKsg54P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lodafqZm0OLS+e570Fkg5y50nt/Vu2loHfcLtvXsc3B47ayp1zCVUsx6C5vcCjatZyOsbO2B5gUkZIIqPAZ/L46KNIqZXzYbFrZPHEglLQlS9HE2ezGU+x+tHyMJu9FlZsFn4YeTbZsyG96a6isP3SM/edcV4Nee9yTUsc9Udts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsq4lpr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsq4lpr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B2FC4CECF;
	Fri, 15 Nov 2024 06:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653830;
	bh=3AEHGZeRrlR2ZFtbkmSqc8zwz+y0Znz5EkdJKsg54P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsq4lpr0S20zSz7+vHNT4ghFHp1N002PGKyYuXBn+tdOhpGUGxR/VGOAYtgUmKbPI
	 Yrd6/N1bmFVdDqam+A+n60I68IjAzikgXq7KJnC+zQRaNeVEnCDJg/P+O/WCHnreSC
	 Yyo0hVdulUuEekUG6mvcOXBDccyxUs+JKjry0OG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Hardik Gohil <hgohil@mvista.com>
Subject: [PATCH 5.10 48/82] spi: Fix deadlock when adding SPI controllers on SPI buses
Date: Fri, 15 Nov 2024 07:38:25 +0100
Message-ID: <20241115063727.291008727@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 6098475d4cb48d821bdf453c61118c56e26294f0 upstream.

Currently we have a global spi_add_lock which we take when adding new
devices so that we can check that we're not trying to reuse a chip
select that's already controlled.  This means that if the SPI device is
itself a SPI controller and triggers the instantiation of further SPI
devices we trigger a deadlock as we try to register and instantiate
those devices while in the process of doing so for the parent controller
and hence already holding the global spi_add_lock.  Since we only care
about concurrency within a single SPI bus move the lock to be per
controller, avoiding the deadlock.

This can be easily triggered in the case of spi-mux.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Hardik Gohil <hgohil@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c       |   15 +++++----------
 include/linux/spi/spi.h |    3 +++
 2 files changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -472,12 +472,6 @@ static LIST_HEAD(spi_controller_list);
  */
 static DEFINE_MUTEX(board_lock);
 
-/*
- * Prevents addition of devices with same chip select and
- * addition of devices below an unregistering controller.
- */
-static DEFINE_MUTEX(spi_add_lock);
-
 /**
  * spi_alloc_device - Allocate a new SPI device
  * @ctlr: Controller to which device is connected
@@ -581,7 +575,7 @@ int spi_add_device(struct spi_device *sp
 	 * chipselect **BEFORE** we call setup(), else we'll trash
 	 * its configuration.  Lock against concurrent add() calls.
 	 */
-	mutex_lock(&spi_add_lock);
+	mutex_lock(&ctlr->add_lock);
 
 	status = bus_for_each_dev(&spi_bus_type, NULL, spi, spi_dev_check);
 	if (status) {
@@ -625,7 +619,7 @@ int spi_add_device(struct spi_device *sp
 	}
 
 done:
-	mutex_unlock(&spi_add_lock);
+	mutex_unlock(&ctlr->add_lock);
 	return status;
 }
 EXPORT_SYMBOL_GPL(spi_add_device);
@@ -2734,6 +2728,7 @@ int spi_register_controller(struct spi_c
 	spin_lock_init(&ctlr->bus_lock_spinlock);
 	mutex_init(&ctlr->bus_lock_mutex);
 	mutex_init(&ctlr->io_mutex);
+	mutex_init(&ctlr->add_lock);
 	ctlr->bus_lock_flag = 0;
 	init_completion(&ctlr->xfer_completion);
 	if (!ctlr->max_dma_len)
@@ -2879,7 +2874,7 @@ void spi_unregister_controller(struct sp
 
 	/* Prevent addition of new devices, unregister existing ones */
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
-		mutex_lock(&spi_add_lock);
+		mutex_lock(&ctlr->add_lock);
 
 	device_for_each_child(&ctlr->dev, NULL, __unregister);
 
@@ -2910,7 +2905,7 @@ void spi_unregister_controller(struct sp
 	mutex_unlock(&board_lock);
 
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
-		mutex_unlock(&spi_add_lock);
+		mutex_unlock(&ctlr->add_lock);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -528,6 +528,9 @@ struct spi_controller {
 	/* I/O mutex */
 	struct mutex		io_mutex;
 
+	/* Used to avoid adding the same CS twice */
+	struct mutex		add_lock;
+
 	/* lock and mutex for SPI bus locking */
 	spinlock_t		bus_lock_spinlock;
 	struct mutex		bus_lock_mutex;


