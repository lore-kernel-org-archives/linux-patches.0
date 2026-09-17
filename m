Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896E950B41B;
	Thu, 17 Sep 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667744; cv=none; b=Elz7/ly/3xMScRwCQt5In0yoemlXCFnA3JLcx+B7uberYacGPsRKO2mgPV0mrxH1MlQOTutYwjMfuSU4Tbnqt9F+a4HLei0gW4Gq+uIpbmIea01Cwz+aypyqxNkGBgRKichirf/aZxwLigcDHCOE8RFv5YmwYJSTjlXxnB6LFOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667744; c=relaxed/simple;
	bh=MoXFpbHwf0G+oxSImLhtchh+dnGbNh5qtMAfp0CtVe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiO8mlDiUufLcD5FUAx48TwLscYmLi77wlfAN8tARH6guu+QkuJrSIEgqwzA7/XqXrL7maFZwYEjqtiNViHmWQSncO8kz9V0U1G0019Po98QwpLNdk+RaWBUD/9+K5v7vxCW7SZPQxyFA4rdp6ivU9EUvGAxatUy6YLfBmLIqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5HUY6Y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5HUY6Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB811F00893;
	Thu, 17 Sep 2026 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667742;
	bh=jNmSYOtnXbuAK3j0trU0z63Y3rSgltWchoCD/4x144I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5HUY6Y8Svagf5qyAxXilLxozavX1Zrw8V4H8HN6AD8D6HCz3c+FwGGUiClkj+FDi
	 /wqhoTWoL4s9xbOtqPCwlI0zLZb2Hv1Og72mrwcfStBmyXCtvUozCqlnb91cYJWi1L
	 x8k0bYQc30U1p9Oq0xl/8mnIwpTyhUby0fNZlZA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0194/1102] iio: accel: mma8452: switch to non-devm request_threaded_irq()
Date: Thu, 17 Sep 2026 16:02:17 +0100
Message-ID: <20260917151544.438800784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c863359c02dd0..ab659cf7bfdcd 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1689,18 +1689,16 @@ static int mma8452_probe(struct i2c_client *client)
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
@@ -1709,7 +1707,7 @@ static int mma8452_probe(struct i2c_client *client)
 
 	ret = iio_device_register(indio_dev);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto free_irq;
 
 	ret = mma8452_set_freefall_mode(data, false);
 	if (ret < 0)
@@ -1720,6 +1718,10 @@ static int mma8452_probe(struct i2c_client *client)
 unregister_device:
 	iio_device_unregister(indio_dev);
 
+free_irq:
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
+
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 
@@ -1745,6 +1747,9 @@ static void mma8452_remove(struct i2c_client *client)
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



