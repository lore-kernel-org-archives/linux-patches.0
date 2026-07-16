Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082042DF137;
	Thu, 16 Jul 2026 13:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209136; cv=none; b=sTLXlNQ6K/7UTBOhmTlBbVJdWju159IXZuOINf2io27PoAGTuxKRtqEsRU6r/S25d8hJ+CbyqokIBk5lJNXe2iLTJt//4DLhS21EuO8o4L0Pg2GwMf4OKNHqHCJIMcuOElV+po2EmpMKmpMDim5a5nL1gG8cJJJ+m8Y6wv+pIno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209136; c=relaxed/simple;
	bh=UctJoTl+i9qj3NPX78Ss7B2TChb134pbfCS+rSKSGqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzYJMYspNMOufhZQRy9hZkhxVtkRCLiBdwEI7a3up+bEWElsNONK09ert3eupgbVJ7KgRi/NdVI5jD6cWuOQhmnnqOr0OOQlpZSGAFV0m2vm43pfEB0JZtTdvXq9nSfcjIzqHj0sITiQAfm4Fo/2x+tXDuApFYYdPRaQdAV2AxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSXXHn7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSXXHn7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AED01F00A3A;
	Thu, 16 Jul 2026 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209134;
	bh=nSxi3PCnJ62EfOxo76Tn4r9PolTh3ijDcnVAi4Ywcj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSXXHn7U5hmXDiXrgi5Kfw1AlWWNJjNqN4ADOD+XSSufFgJBZH9OjL3c4O33IB+Ol
	 vg+gYM7bYM4V3b25QWA9xSefU79QyIML3DcVdWDa84eOSOpsPEvLlN74BFa6hHJlV2
	 ZEJyODRgAAOJ/oF6gag0W+lIWRPGGvvHbVJbjYIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 068/518] iio: light: tsl2591: return actual error from probe IRQ failure
Date: Thu, 16 Jul 2026 15:25:36 +0200
Message-ID: <20260716133049.273816384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

commit a00ffd15674bfaf8b906503c1600e3d8709af56c upstream.

When devm_request_threaded_irq() fails, probe logs the error and
then returns -EINVAL, dropping the real error code and breaking the
deferred-probe flow for -EPROBE_DEFER.

Return ret directly; the IRQ subsystem already prints on failure.

Fixes: 2335f0d7c790 ("iio: light: Added AMS tsl2591 driver implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2591.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/tsl2591.c
+++ b/drivers/iio/light/tsl2591.c
@@ -1137,10 +1137,8 @@ static int tsl2591_probe(struct i2c_clie
 						NULL, tsl2591_event_handler,
 						IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 						"tsl2591_irq", indio_dev);
-		if (ret) {
-			dev_err_probe(&client->dev, ret, "IRQ request error\n");
-			return -EINVAL;
-		}
+		if (ret)
+			return ret;
 		indio_dev->info = &tsl2591_info;
 	} else {
 		indio_dev->info = &tsl2591_info_no_irq;


