Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839FE3BB12D;
	Sat, 17 Oct 2026 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256790; cv=none; b=tsbMjM9iolxKRTjbcAPi6f4Jd9qDeFh9r2ZlR3dkowgNcOtEEg+1KCzYLpKRJYWnAUZL2U63ukGi9xJbIXSzmIkW7icjHtsXTUgMX6r7tq7bW7S5cS+jC/hbQiFkXdWDlmvQnuBVAzS46qojPUGnAtlmywNZ3+hG+2OSvWEsQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256790; c=relaxed/simple;
	bh=cEGD/TgIH3xP69VplqNffE18N5dpV4SXG3/8cK8A7Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZD1JW3exh228/G4TKy8L8BbaBUogfYI+cdZB1/8/2IcyMdku7Ab3Kbbvanz6fqDn9OpHfjcsFAsRGn8SKUc3RbLLY89JijxCvRVHgdZdk3E9vK5czr70MH3pnvAUiFKRVM9YGYtihfI6w+MUZlEbxAuQLM1vKfYnTkS9UAnEj5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoKRdpq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoKRdpq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8636F1F000C4;
	Sat, 17 Oct 2026 17:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256788;
	bh=R39UBOa1zmfNlN1HyYexvLs6VOJDI7uFuXgxXQ20ZCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoKRdpq6Uodq+h52wsBuESECzyOXgJ+KrgJVUzIsGopd7bpL5P25mHZQfLr1DTOjw
	 xNkR3pktNYBR3H68ooRlnN9KuqWs9Tk1BkYaLcf9fc8VYfAzo2yXCzdOHG9CgMYPqF
	 3YOg78ySweDvuBc0U4huxoQ6zaV+7AKPOuwuy6lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0353/1674] iio: trigger: cancel reenable_work before freeing trigger
Date: Sat, 17 Oct 2026 17:43:45 +0200
Message-ID: <20261017160440.184701366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,6 +519,8 @@ static void iio_trig_release(struct devi
 	struct iio_trigger *trig = to_iio_trigger(device);
 	int i;
 
+	cancel_work_sync(&trig->reenable_work);
+
 	if (trig->subirq_base) {
 		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
 			irq_modify_status(trig->subirq_base + i,


