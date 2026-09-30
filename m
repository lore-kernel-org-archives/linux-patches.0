Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CB34D90B7;
	Wed, 30 Sep 2026 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784361; cv=none; b=GwgZphfKd3Je8brOPqioy+sDP9FcQcpAZN6IXQ5fb2l0BQ+w0PYBqov9nXvMeUgtOtGWI0sfZpd58fBxaZigawhB0MLFvyImyadMXo0qwR/3man521oU/k9nxNI7XbZ300FObp5zxzohWdEe5ffsg6gOS92oG45yBQTRLn8627A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784361; c=relaxed/simple;
	bh=iPgAn39OoxJ71fjziW2PshiL1gruzFL523VH+e1RneI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUlVZOK6H7TOEk9IY5g552PCZnDBkLmZjCK6GCe9tzteExWsGxZBtDbAghnl9QeVsxbgVDYw9y/xDAZW5e1Aj4sf4qXwxiz2ESNCgIeHm4jv23opMtGD6vZSdPDi5mdDgCkU4EiZYoy7kRmdZRDiP8xwPRSYNHdaARdaMkLrEk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3ab6bRb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3ab6bRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DF71F000FF;
	Wed, 30 Sep 2026 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784357;
	bh=z9oXDcvW0y0pbUjogzt2OmAYzJhXIYpml1JRqEul5Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3ab6bRbGhn157Hk1a0b19Y3dWeCYl5JLdA4gskzntjEsFk7huLyK0zk/Ut0xHOjE
	 Ydk7E/jfEGAJaRxHSRdKCzQTmSyHn0z1QDq52MfqV5x1gNkAjDoyXrj6rUl6PIRFet
	 pThQcLaXcCjphVLOVQ9IzvN/huP7iUsvm6J/W+fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/982] iio: accel: mma8452: switch to non-devm request_threaded_irq()
Date: Wed, 30 Sep 2026 17:14:24 +0200
Message-ID: <20260930152419.564402105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

[ Upstream commit 0a6726ec20cd4c0101f2de0ca485a11676224dea ]

Avoid using devm_request_threaded_irq() as the driver requires explicit
error-handling path(s). Using devm_* API together with goto-based
unwinding breaks the expected LIFO resource release model.

Add explicit IRQ cleanup in the driver teardown paths to follow kernel
resource management conventions.

Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 28002c714ea98..7be63b5965993 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1695,18 +1695,16 @@ static int mma8452_probe(struct i2c_client *client,
 		goto trigger_cleanup;
 
 	if (client->irq) {
-		ret = devm_request_threaded_irq(&client->dev,
-						client->irq,
-						NULL, mma8452_interrupt,
-						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-						client->name, indio_dev);
+		ret = request_threaded_irq(client->irq, NULL, mma8452_interrupt,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					   client->name, indio_dev);
 		if (ret)
 			goto buffer_cleanup;
 	}
 
 	ret = pm_runtime_set_active(&client->dev);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto free_irq;
 
 	pm_runtime_enable(&client->dev);
 	pm_runtime_set_autosuspend_delay(&client->dev,
@@ -1715,7 +1713,7 @@ static int mma8452_probe(struct i2c_client *client,
 
 	ret = iio_device_register(indio_dev);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto free_irq;
 
 	ret = mma8452_set_freefall_mode(data, false);
 	if (ret < 0)
@@ -1726,6 +1724,10 @@ static int mma8452_probe(struct i2c_client *client,
 unregister_device:
 	iio_device_unregister(indio_dev);
 
+free_irq:
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
+
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 
@@ -1751,6 +1753,9 @@ static void mma8452_remove(struct i2c_client *client)
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
+
 	iio_triggered_buffer_cleanup(indio_dev);
 	mma8452_trigger_cleanup(indio_dev);
 	mma8452_standby(iio_priv(indio_dev));
-- 
2.53.0



