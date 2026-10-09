Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896664E8DFB;
	Fri,  9 Oct 2026 14:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557048; cv=none; b=rFI/PvVeDlvv3puFz8VW534ZMy/ciXOibYPM5qW4GWGmCT33yN+O0Nc2RoiVpYnUATXrSXpzGxrwnkZDAtxKf5Uuz0g01tBTHu2IKTJUx28nEikJETt4G2WFNQLb+bMqApoHEilmB8/ClMS50xcTjc/DKHXsxbYKbJIN0UCUjCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557048; c=relaxed/simple;
	bh=asL9NtqB4YvhyM4uO2Es4bLH9Y/etw8Cu2hefP7f/Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDwBvgz0BbEBCT85Zgt29eHJ0FmCLRBQgAB5ep0b9wq02qEf4LKOdxX9sFaAM3Txjr8Ge3Pz4eWA4NjdGd0JF/bTM2hP/7oUziClZqAqoE5cUx+Q0vgMh6cLJTj+QTm1fWTe2kduMLf7VpqhB83yTLK/FrD17RmQE1B22/dNL/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIeS6FHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIeS6FHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ABF1F000FF;
	Fri,  9 Oct 2026 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557046;
	bh=nz0TY9TFc1lGiW8fEkS96V2zlleX9EHsurIo6BfzV34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIeS6FHY3nyWcV/Cca48xlXRIgcPj0dM1Ro/TF9c6lmf6Hvf1c/snGfCMV8yCeQuO
	 QNFjf3QL3Cz9BeVUpkx77KL28VgrRGAtLsr5BAPlhzAmSaJqGQ4sZwW1noNeF2FN9R
	 tduYM7fRTs+lOP/oUYk2z2eNaLvdeRhrDOHvhWDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 338/403] iio: trigger: cancel reenable_work before freeing trigger
Date: Fri,  9 Oct 2026 16:11:39 +0200
Message-ID: <20261009141000.159961346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 2a57b9246cecd5dd797a42eb310d6c8816f26d9e upstream.

iio_trigger_notify_done_atomic() defers ->reenable() into
trig->reenable_work on the system workqueue, and the worker dereferences
the owning trigger through container_of().  Nothing cancels this work
before iio_trig_release() frees the trigger, so a worker armed by the
last in-flight IRQ can outlive the free and touch freed memory.

Cancel it at the top of iio_trig_release(), which every free path
reaches through the device core's final put_device().

Found by an in-house static analysis tool.

Fixes: 9020ef659885 ("iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -509,6 +509,8 @@ static void iio_trig_release(struct devi
 	struct iio_trigger *trig = to_iio_trigger(device);
 	int i;
 
+	cancel_work_sync(&trig->reenable_work);
+
 	if (trig->subirq_base) {
 		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
 			irq_modify_status(trig->subirq_base + i,


