Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524BA17E015;
	Fri, 15 Nov 2024 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653038; cv=none; b=RNAz+vV7cORSOfMqGzYyhxEqvyA6JSU4qGz3mPIXjvSWjjQyqPmbZ7HUyOHxyB/Ao6QuLFiWq+cCCprjzMzgClNlhNtoBTBAVerHQ9R1dG7iKuWGYBIL1SuxDjSKqzZRRHf9xLsqPEY0ULjl3xZvNvTtb9wdxTF+FYpLz1LIR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653038; c=relaxed/simple;
	bh=syXHNysSx+S3L+Ft6dGK1EhvoaX/v9eJmW9AMTvj8wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxoq+Vo/BhUF5fWQqeCJvTKPCdNvJKeY7kVlyr1JH/yBc7Kr11jMyOyWql4QTSNtJGD3+o/e4xiek4FMmGZ56xqfTbpdoWdsrscD98jnUpibtwUUxTOMZVaSHkRvjj7usnsXfKwZufyOrR4z05RzevI1KgjoFw47z7BZHfTDAuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHP0oqS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHP0oqS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA48C4CECF;
	Fri, 15 Nov 2024 06:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653038;
	bh=syXHNysSx+S3L+Ft6dGK1EhvoaX/v9eJmW9AMTvj8wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHP0oqS4IeqGKsUoJIZS4yAgqw+mJo9aY4TffSQgQDh2CIADZyWWJXgmvcXK0/IMC
	 w128KZgWbDYHIi8XMfo8Ox3Er2IIC5P1p4cBqM8b1yEHFTfMPgh2vDQ0dayneIzxlF
	 QyE/ypnjmZfNFm6ApGVlBeDvhI/gghvJfKtJX4/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Hardik Gohil <hgohil@mvista.com>
Subject: [PATCH 5.4 35/66] spi: Fix deadlock when adding SPI controllers on SPI buses
Date: Fri, 15 Nov 2024 07:37:44 +0100
Message-ID: <20241115063724.112494538@linuxfoundation.org>
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
@@ -580,7 +574,7 @@ int spi_add_device(struct spi_device *sp
 	 * chipselect **BEFORE** we call setup(), else we'll trash
 	 * its configuration.  Lock against concurrent add() calls.
 	 */
-	mutex_lock(&spi_add_lock);
+	mutex_lock(&ctlr->add_lock);
 
 	status = bus_for_each_dev(&spi_bus_type, NULL, spi, spi_dev_check);
 	if (status) {
@@ -624,7 +618,7 @@ int spi_add_device(struct spi_device *sp
 	}
 
 done:
-	mutex_unlock(&spi_add_lock);
+	mutex_unlock(&ctlr->add_lock);
 	return status;
 }
 EXPORT_SYMBOL_GPL(spi_add_device);
@@ -2512,6 +2506,7 @@ int spi_register_controller(struct spi_c
 	spin_lock_init(&ctlr->bus_lock_spinlock);
 	mutex_init(&ctlr->bus_lock_mutex);
 	mutex_init(&ctlr->io_mutex);
+	mutex_init(&ctlr->add_lock);
 	ctlr->bus_lock_flag = 0;
 	init_completion(&ctlr->xfer_completion);
 	if (!ctlr->max_dma_len)
@@ -2657,7 +2652,7 @@ void spi_unregister_controller(struct sp
 
 	/* Prevent addition of new devices, unregister existing ones */
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
-		mutex_lock(&spi_add_lock);
+		mutex_lock(&ctlr->add_lock);
 
 	device_for_each_child(&ctlr->dev, NULL, __unregister);
 
@@ -2688,7 +2683,7 @@ void spi_unregister_controller(struct sp
 	mutex_unlock(&board_lock);
 
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
-		mutex_unlock(&spi_add_lock);
+		mutex_unlock(&ctlr->add_lock);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -483,6 +483,9 @@ struct spi_controller {
 	/* I/O mutex */
 	struct mutex		io_mutex;
 
+	/* Used to avoid adding the same CS twice */
+	struct mutex		add_lock;
+
 	/* lock and mutex for SPI bus locking */
 	spinlock_t		bus_lock_spinlock;
 	struct mutex		bus_lock_mutex;


