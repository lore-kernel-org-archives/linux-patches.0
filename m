Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5489339FFD;
	Fri, 24 Nov 2023 18:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILBppNkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D119AC433C8;
	Fri, 24 Nov 2023 18:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849657;
	bh=CimODmEVjWVoI67ndJpr7lQefNmR5kBvkMdnoqTUs6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILBppNkSZruMg7soohKto5qcK/Rz9tM/iJg0JSOELGW7q35YyEEckzQJePu2wUutQ
	 hVhFp6BaopBnG4gWM1QUkrazuVlsZ2TXWiMVjqGmc9wAovDTnVOViYoypWGNDnDh6B
	 +pZ/IpY+qwAHQi50b9jQ0aNT4UJ6NubzltHVv67c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Hasemeyer <markhas@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 244/530] spi: Fix null dereference on suspend
Date: Fri, 24 Nov 2023 17:46:50 +0000
Message-ID: <20231124172035.483901186@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Hasemeyer <markhas@chromium.org>

commit bef4a48f4ef798c4feddf045d49e53c8a97d5e37 upstream.

A race condition exists where a synchronous (noqueue) transfer can be
active during a system suspend. This can cause a null pointer
dereference exception to occur when the system resumes.

Example order of events leading to the exception:
1. spi_sync() calls __spi_transfer_message_noqueue() which sets
   ctlr->cur_msg
2. Spi transfer begins via spi_transfer_one_message()
3. System is suspended interrupting the transfer context
4. System is resumed
6. spi_controller_resume() calls spi_start_queue() which resets cur_msg
   to NULL
7. Spi transfer context resumes and spi_finalize_current_message() is
   called which dereferences cur_msg (which is now NULL)

Wait for synchronous transfers to complete before suspending by
acquiring the bus mutex and setting/checking a suspend flag.

Signed-off-by: Mark Hasemeyer <markhas@chromium.org>
Link: https://lore.kernel.org/r/20231107144743.v1.1.I7987f05f61901f567f7661763646cb7d7919b528@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c       |   56 +++++++++++++++++++++++++++++++++---------------
 include/linux/spi/spi.h |    1 
 2 files changed, 40 insertions(+), 17 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3323,33 +3323,52 @@ void spi_unregister_controller(struct sp
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 
+static inline int __spi_check_suspended(const struct spi_controller *ctlr)
+{
+	return ctlr->flags & SPI_CONTROLLER_SUSPENDED ? -ESHUTDOWN : 0;
+}
+
+static inline void __spi_mark_suspended(struct spi_controller *ctlr)
+{
+	mutex_lock(&ctlr->bus_lock_mutex);
+	ctlr->flags |= SPI_CONTROLLER_SUSPENDED;
+	mutex_unlock(&ctlr->bus_lock_mutex);
+}
+
+static inline void __spi_mark_resumed(struct spi_controller *ctlr)
+{
+	mutex_lock(&ctlr->bus_lock_mutex);
+	ctlr->flags &= ~SPI_CONTROLLER_SUSPENDED;
+	mutex_unlock(&ctlr->bus_lock_mutex);
+}
+
 int spi_controller_suspend(struct spi_controller *ctlr)
 {
-	int ret;
+	int ret = 0;
 
 	/* Basically no-ops for non-queued controllers */
-	if (!ctlr->queued)
-		return 0;
-
-	ret = spi_stop_queue(ctlr);
-	if (ret)
-		dev_err(&ctlr->dev, "queue stop failed\n");
+	if (ctlr->queued) {
+		ret = spi_stop_queue(ctlr);
+		if (ret)
+			dev_err(&ctlr->dev, "queue stop failed\n");
+	}
 
+	__spi_mark_suspended(ctlr);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(spi_controller_suspend);
 
 int spi_controller_resume(struct spi_controller *ctlr)
 {
-	int ret;
-
-	if (!ctlr->queued)
-		return 0;
+	int ret = 0;
 
-	ret = spi_start_queue(ctlr);
-	if (ret)
-		dev_err(&ctlr->dev, "queue restart failed\n");
+	__spi_mark_resumed(ctlr);
 
+	if (ctlr->queued) {
+		ret = spi_start_queue(ctlr);
+		if (ret)
+			dev_err(&ctlr->dev, "queue restart failed\n");
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(spi_controller_resume);
@@ -4153,8 +4172,7 @@ static void __spi_transfer_message_noque
 	ctlr->cur_msg = msg;
 	ret = __spi_pump_transfer_message(ctlr, msg, was_busy);
 	if (ret)
-		goto out;
-
+		dev_err(&ctlr->dev, "noqueue transfer failed\n");
 	ctlr->cur_msg = NULL;
 	ctlr->fallback = false;
 
@@ -4170,7 +4188,6 @@ static void __spi_transfer_message_noque
 		spi_idle_runtime_pm(ctlr);
 	}
 
-out:
 	mutex_unlock(&ctlr->io_mutex);
 }
 
@@ -4193,6 +4210,11 @@ static int __spi_sync(struct spi_device
 	int status;
 	struct spi_controller *ctlr = spi->controller;
 
+	if (__spi_check_suspended(ctlr)) {
+		dev_warn_once(&spi->dev, "Attempted to sync while suspend\n");
+		return -ESHUTDOWN;
+	}
+
 	status = __spi_validate(spi, message);
 	if (status != 0)
 		return status;
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -566,6 +566,7 @@ struct spi_controller {
 #define SPI_CONTROLLER_MUST_RX		BIT(3)	/* Requires rx */
 #define SPI_CONTROLLER_MUST_TX		BIT(4)	/* Requires tx */
 #define SPI_CONTROLLER_GPIO_SS		BIT(5)	/* GPIO CS must select slave */
+#define SPI_CONTROLLER_SUSPENDED	BIT(6)	/* Currently suspended */
 
 	/* Flag indicating if the allocation of this struct is devres-managed */
 	bool			devm_allocated;


