Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4984482F2;
	Wed, 20 Dec 2023 16:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9qExJ6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1AFC433C8;
	Wed, 20 Dec 2023 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089080;
	bh=atVqQjV4/bJZuIS5xUaLwXZFOy0ycqYvHKYg3ClAWNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9qExJ6MzN6CsSjFyRCXlXval4S/k3I9HkPIZ0rE4rtbtQlorqAFYyH7A03McLBnB
	 Oq/b7Cl7dfSocxgjEGCs2iZmtEWGe/SmorKmj5WYt0jls5hjDS1LMyUXScldT7wZkm
	 69VtOUvC3cdCLkICNMAnyq+WQCDqlfa9yFhb+4ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.15 155/159] Revert "drm/bridge: lt9611uxc: fix the race in the error path"
Date: Wed, 20 Dec 2023 17:10:20 +0100
Message-ID: <20231220160938.544132917@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Pundir <amit.pundir@linaro.org>

This reverts commit d0d01bb4a56093fa214c0949e9e7ccb9fb437795.

This and the dependent fixes broke display on RB5.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -927,9 +927,9 @@ retry:
 	init_waitqueue_head(&lt9611uxc->wq);
 	INIT_WORK(&lt9611uxc->work, lt9611uxc_hpd_work);
 
-	ret = request_threaded_irq(client->irq, NULL,
-				   lt9611uxc_irq_thread_handler,
-				   IRQF_ONESHOT, "lt9611uxc", lt9611uxc);
+	ret = devm_request_threaded_irq(dev, client->irq, NULL,
+					lt9611uxc_irq_thread_handler,
+					IRQF_ONESHOT, "lt9611uxc", lt9611uxc);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
 		goto err_disable_regulators;
@@ -965,8 +965,6 @@ retry:
 	return lt9611uxc_audio_init(dev, lt9611uxc);
 
 err_remove_bridge:
-	free_irq(client->irq, lt9611uxc);
-	cancel_work_sync(&lt9611uxc->work);
 	drm_bridge_remove(&lt9611uxc->bridge);
 
 err_disable_regulators:
@@ -983,7 +981,7 @@ static int lt9611uxc_remove(struct i2c_c
 {
 	struct lt9611uxc *lt9611uxc = i2c_get_clientdata(client);
 
-	free_irq(client->irq, lt9611uxc);
+	disable_irq(client->irq);
 	cancel_work_sync(&lt9611uxc->work);
 	lt9611uxc_audio_exit(lt9611uxc);
 	drm_bridge_remove(&lt9611uxc->bridge);


