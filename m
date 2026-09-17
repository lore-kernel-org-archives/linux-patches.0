Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F444EDCAD;
	Thu, 17 Sep 2026 16:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664142; cv=none; b=m+yoWcCmEgwBaO08JnXovbHgSAPJxoIVkDq234s7MMaYEWoQ4jjDpACk+k2gIb6ozvmeb9RF/ug9Z7rAsdidFuuPF2MWfa5SuVT+ufmxhTXe8e8+tGYLE+TqCCL/o/c/vY5HgkFHSUbui/a3M7hIOYKWJHuBHgDKncv/ucFt2n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664142; c=relaxed/simple;
	bh=yRJ7MdHLUi0prMNVENze4wLhV3Aq5YKbj86OmG7r908=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV0mLhOXyqpvumBEb5esw9NfoPTO83ro+ncMXVl6Ik02C5EQ5JVkBwDqgFt4FH2fKTdwxxJd56e5nJTFmYyhSrd3btT5OoQU/0Hhrqt1PUpnI1FoGLk7khuvzGTJNHhcVzunZEgG6/vaPX1L14DLiF8WHmkNgBS0HrMb4BdxE3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=javEyzww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="javEyzww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1991F000FF;
	Thu, 17 Sep 2026 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664141;
	bh=AhKmiXYl7SnvC16w68eno75IVWiUCt2Txo+iRXlII/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=javEyzwwAtLMGQsbgzFeZr7KTVf8925rgaAfPG4PT/rQ/eUAhXuMP0HE/iBOgpytF
	 N8IM9QuOpBeRIl6OlF2wyCpvB59siHM0szMxE6umm+MyZgvg9SMM1pXT9/q0ysgFQg
	 oOxyX1BZ3E4JQbUvCoZJVAt8g8UDkcHJ0dzqvjuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0273/1250] iio: accel: mma8452: switch to non-devm request_threaded_irq()
Date: Thu, 17 Sep 2026 16:01:08 +0100
Message-ID: <20260917151559.538576914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index cefc7cf4bd835..279a9b3648860 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1682,18 +1682,16 @@ static int mma8452_probe(struct i2c_client *client)
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
@@ -1702,7 +1700,7 @@ static int mma8452_probe(struct i2c_client *client)
 
 	ret = iio_device_register(indio_dev);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto free_irq;
 
 	ret = mma8452_set_freefall_mode(data, false);
 	if (ret < 0)
@@ -1713,6 +1711,10 @@ static int mma8452_probe(struct i2c_client *client)
 unregister_device:
 	iio_device_unregister(indio_dev);
 
+free_irq:
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
+
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 
@@ -1738,6 +1740,9 @@ static void mma8452_remove(struct i2c_client *client)
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



