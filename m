Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D961283FC8;
	Mon, 23 Mar 2026 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282808; cv=none; b=c8dTHHFWwihE3DfUmPu4V3KCnm0RBCt/mUd7H7ZTRyQC7+PJYS+ZX7lIbw3fpuqSFmmci1TVGy9eNKKTRfiHJj5Q7YbHf9aQyCjSHHBpcwk6afEdZ9+atgnL+T2sIjyX1UKXRsfGUgPkBfmDE39MGs4dawszhauNJ9WgvQ1rpzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282808; c=relaxed/simple;
	bh=9m0e/xk108lhMi3iT0oJ/x+Fj0m9RlGlk0Zm/BGYZ3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BM6tr21cOgYvGNODkjMm/L3eQvsZ6f5jAqh0EpLxI5bc+jBvdSsoK5Tg2G3ZdpHPWV1BNkiPscGZy2DdxfH2VFYRWcQhCot1YCGDLzztfv2GIsWwWYouAqplCzcPo9FmEOLh0MNRwFH31obMwqqPwUS/WTMU5lkjDWSbij7O0hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2ZVjrRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2ZVjrRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9357BC4CEF7;
	Mon, 23 Mar 2026 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282807;
	bh=9m0e/xk108lhMi3iT0oJ/x+Fj0m9RlGlk0Zm/BGYZ3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2ZVjrRH1KErPearOQvmS4IxWfogZdyfzD2k3fh47U5hYCFcbp4K+ebXDzuBnXas8
	 duIxOZcWy5wdBNbgtUhMtVyVjbIaqS+q/HJYA1Q12lI5U3QdtGCE+LIgCtUt4RK24U
	 38pelYlbsYVqb7crsYnHDg7bhVRdtFi1Lx96OxUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 294/481] spi: fix statistics allocation
Date: Mon, 23 Mar 2026 14:44:36 +0100
Message-ID: <20260323134532.273383734@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2768,6 +2768,8 @@ static void spi_controller_release(struc
 	struct spi_controller *ctlr;
 
 	ctlr = container_of(dev, struct spi_controller, dev);
+
+	free_percpu(ctlr->pcpu_statistics);
 	kfree(ctlr);
 }
 
@@ -2922,6 +2924,12 @@ struct spi_controller *__spi_alloc_contr
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
@@ -3215,13 +3223,6 @@ int spi_register_controller(struct spi_c
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
@@ -3234,8 +3235,6 @@ int spi_register_controller(struct spi_c
 	acpi_register_spi_devices(ctlr);
 	return status;
 
-destroy_queue:
-	spi_destroy_queue(ctlr);
 del_ctrl:
 	device_del(&ctlr->dev);
 free_bus_id:


