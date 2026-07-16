Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1493B2D18;
	Thu, 16 Jul 2026 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209270; cv=none; b=VUpx86ZrRJ/3Plsi8VCUBrZzgyh8SCb8dDnqFPzb//CygFC87unbcwGBlQxmufxfJ7El8ESyppyq8GaMncmfssqFZJyfodeNO2tR0oj9HMYJZFnzO+6O8O3XD9TvLoRrz4B9IQR8hQBinKwflbSAFtGAr2VCbyqMK0dlAyc3PPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209270; c=relaxed/simple;
	bh=I2bGbQFxopDKXTck+zO4cS6oe4HEeymKVC/htyuXb+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVdTsXSAuvodFKdLcj3my1y0WaCVJKil4TAmnz94G/iCiUwtChy6wxfRNIgPBYFFDk7p6yGMjFr1FIy2CtvkqMTF4qD3AhsSIRd1bD8yhKCUiRaA45AAmiGbOBXvDFduBP9OglSZ2mRIrgA3TH/Dc/fWQAeFRcsmgrW7AAxBtbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ww80GSvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ww80GSvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3671F000E9;
	Thu, 16 Jul 2026 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209268;
	bh=EdLDDFX5DIOchOiTDqYHhnfcx3IxMCJVVs3jB7kXcVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ww80GSvj2T9wOu35FBtIfT3nZvAgSeZ9tG/QI8DW1i1cs3lWRTwwmHb7sX/Uc9SoW
	 AHhiwozWEhItOP707XV1FjzMK214wQByObfD5BlcS2i8BYn5TtGp71IjUzmOqZa/E5
	 R2hQqltsVxQ35PUGV1Xf3RSxSWmYzZtLsGnuUsl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 078/518] iio: temperature: tmp006: use devm_iio_trigger_register
Date: Thu, 16 Jul 2026 15:25:46 +0200
Message-ID: <20260716133049.494597620@linuxfoundation.org>
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

commit 3c5eed894efd93d68d7f6a359a81ddef0e928774 upstream.

tmp006_probe() allocates the DRDY trigger with devm_iio_trigger_alloc()
but registers it with plain iio_trigger_register(). The driver has no
.remove() callback, so on module unload the trigger stays in the global
trigger list while its memory is freed by devm, leaving a dangling
entry.

Switch to devm_iio_trigger_register() so the registration is undone in
the same devm scope as the allocation.

Fixes: 91f75ccf9f03 ("iio: temperature: tmp006: add triggered buffer support")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/tmp006.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/tmp006.c
+++ b/drivers/iio/temperature/tmp006.c
@@ -350,7 +350,7 @@ static int tmp006_probe(struct i2c_clien
 
 		data->drdy_trig->ops = &tmp006_trigger_ops;
 		iio_trigger_set_drvdata(data->drdy_trig, indio_dev);
-		ret = iio_trigger_register(data->drdy_trig);
+		ret = devm_iio_trigger_register(&client->dev, data->drdy_trig);
 		if (ret)
 			return ret;
 


