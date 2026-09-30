Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33B94F7CC3;
	Wed, 30 Sep 2026 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790856; cv=none; b=TcA/3d2NvstngnlxMDn1zHAuknO/a57veCroGvRmUi2X1+EtdsiY94ScZpLi/X7gvWXZL24VN0EpaA48e9kfDxmNa+rHK3Ny0tzMgACmpuTsx0b6AWHrwZrXCGGmgxFdcGa2lGdPGMU+cRK9FBhvY9+4kOEvywBQhXGHuaxM2U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790856; c=relaxed/simple;
	bh=ewb/KpRwxf2AkJO69u5auDs7eNxjWOACzS0xQNgwNM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5I7QvndVi2gMnWf5LvhjH0YlTmJsKdB7J9cMpRe/28JyGAVWuFfUWOqQInw+c36R4qRHFYID/KWbPLYY5um+t2pL7Lbbw/gvDIsudAVcuRzLhyjly+3hHR+emOUHQ8FWnou88y9Fhp2gAm1oy8Qryehdg2mDAPUqJky2nLJbdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4pABfDv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4pABfDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4CB1F000FF;
	Wed, 30 Sep 2026 17:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790855;
	bh=C7lKmW2GG/3zFDgVdKeuQzS/Dd0mtWicKllmtDLwdqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4pABfDvb66WW3vUkQ3WmjQVV+nlEN4T4PdZgqcrmhyQmeNTqWyaaZqNX7KuETfFR
	 5cfNXVZ1h6H2IauLlIvSGlgfPLEwl9rVDf2FpNUBYMdJRBc9pu5qLP41cID6Yl5JQt
	 Ui7UV4U+b4nQX0tqJ163yrYiSxAKfgh+1Bi0qOqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/752] iio: accel: mma8452: switch to non-devm request_threaded_irq()
Date: Wed, 30 Sep 2026 17:19:28 +0200
Message-ID: <20260930152400.288357994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aa369bdd9c555..72f7c89599674 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1673,18 +1673,16 @@ static int mma8452_probe(struct i2c_client *client,
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
@@ -1693,7 +1691,7 @@ static int mma8452_probe(struct i2c_client *client,
 
 	ret = iio_device_register(indio_dev);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto free_irq;
 
 	ret = mma8452_set_freefall_mode(data, false);
 	if (ret < 0)
@@ -1704,6 +1702,10 @@ static int mma8452_probe(struct i2c_client *client,
 unregister_device:
 	iio_device_unregister(indio_dev);
 
+free_irq:
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
+
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 
@@ -1729,6 +1731,9 @@ static int mma8452_remove(struct i2c_client *client)
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



