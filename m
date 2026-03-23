Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D523B95F2;
	Mon, 23 Mar 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274627; cv=none; b=jXtCrxvBFIUCDTYlVPw+XmqVcpIrPcJVCFR4ixUnEbN5XWcLuNAYdO24dIQRUXvdLbWzyKu6SA+CdzN8yVqlWKkCTZX18Fbb0iaqvSoBXLvg6KXHMkgkfK2J9MpFhuGQ+nI7kP3Y+GP5xkpVrbfyEkXF6I42L1V67ivjvM3j3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274627; c=relaxed/simple;
	bh=+HNobCyjw9Qu6tkhltCztx/6Oy0sssVbZVkcwczxKOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obPZ39Ch8XrRWpd0kz2iNdazIHEMurY2LG87IuvRlXQCUatnW0DYQyGWXtzo0us/+PdRe7XiqkVA3uITTHaJ9mdJ1TEDLwFMqLVnhdnWAtWuU98rgSFyGsBed9FsEv5/1O6RgPEUJ2fysHdPCyog7ZBsqVgUuQvWzVyTyb05wOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0HU9FXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0HU9FXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF806C4CEF7;
	Mon, 23 Mar 2026 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274627;
	bh=+HNobCyjw9Qu6tkhltCztx/6Oy0sssVbZVkcwczxKOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0HU9FXOLfMUUx7hl24UN3OmDB8jgfKe+hii4Ay6s8eU+35CO2ifVe6a7yJl4MM2o
	 lG1SYZFxhEL/1//+WbwhCj2bW4dXbZTl2436xcmvz5udyfwLZ2ydFm4Zt6V6YjQ7hJ
	 3/pTc6MFBXNJdwsQQwSkL1Oacjn4HiaagAzG6XHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 057/212] spi: fix statistics allocation
Date: Mon, 23 Mar 2026 14:44:38 +0100
Message-ID: <20260323134505.572354121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dee0774bbb2abb172e9069ce5ffef579b12b3ae9 upstream.

The controller per-cpu statistics is not allocated until after the
controller has been registered with driver core, which leaves a window
where accessing the sysfs attributes can trigger a NULL-pointer
dereference.

Fix this by moving the statistics allocation to controller allocation
while tying its lifetime to that of the controller (rather than using
implicit devres).

Fixes: 6598b91b5ac3 ("spi: spi.c: Convert statistics to per-cpu u64_stats_t")
Cc: stable@vger.kernel.org	# 6.0
Cc: David Jander <david@protonic.nl>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260312151817.32100-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2914,6 +2914,8 @@ static void spi_controller_release(struc
 	struct spi_controller *ctlr;
 
 	ctlr = container_of(dev, struct spi_controller, dev);
+
+	free_percpu(ctlr->pcpu_statistics);
 	kfree(ctlr);
 }
 
@@ -3057,6 +3059,12 @@ struct spi_controller *__spi_alloc_contr
 	if (!ctlr)
 		return NULL;
 
+	ctlr->pcpu_statistics = spi_alloc_pcpu_stats(NULL);
+	if (!ctlr->pcpu_statistics) {
+		kfree(ctlr);
+		return NULL;
+	}
+
 	device_initialize(&ctlr->dev);
 	INIT_LIST_HEAD(&ctlr->queue);
 	spin_lock_init(&ctlr->queue_lock);
@@ -3347,13 +3355,6 @@ int spi_register_controller(struct spi_c
 		if (status)
 			goto del_ctrl;
 	}
-	/* Add statistics */
-	ctlr->pcpu_statistics = spi_alloc_pcpu_stats(dev);
-	if (!ctlr->pcpu_statistics) {
-		dev_err(dev, "Error allocating per-cpu statistics\n");
-		status = -ENOMEM;
-		goto destroy_queue;
-	}
 
 	mutex_lock(&board_lock);
 	list_add_tail(&ctlr->list, &spi_controller_list);
@@ -3366,8 +3367,6 @@ int spi_register_controller(struct spi_c
 	acpi_register_spi_devices(ctlr);
 	return status;
 
-destroy_queue:
-	spi_destroy_queue(ctlr);
 del_ctrl:
 	device_del(&ctlr->dev);
 free_bus_id:


