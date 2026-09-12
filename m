Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67083AC17;
	Sat, 12 Sep 2026 15:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228256; cv=none; b=ErqIlr/I0nQnwfzOgRDXCv1VA9Y05oNzPR1RH1H5Qz6Ek/7darLzl+Z/J80qXImw58x7H70QjwBt5TjPBc58qPTkzdsLQ68HqI2dTt2ocfUKPkrMYJ0WxJ7DaFkzQTyxcy1Hi4cG0x28kl2c3LWl9af6zEm15XaqdEm0k6zNDOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228256; c=relaxed/simple;
	bh=hEz1j44zl18uhjW1cnDwLWtoBnM/CYiaVPp/SkPKU3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqRzJ38eDqLZ/SMgCq8DN2qQy8bSbndld6O62K+f1HOvo1Edlo4wv8IyDwP4sLY9M3IgvIPaddjum0gTLdp+M6mOuPI1yUoek+F8JHuveqxKEf6vTzWfFZCwjGB0szlD07JW2VzudgCtyrm8RpoN5faDzVyZRIkXAWQrsJEiSbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+ji3437; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+ji3437"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572811F000FF;
	Sat, 12 Sep 2026 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228255;
	bh=UH5r/+DX2l9+0iPRLN4nDtu+xuBSG1RDCVpsAqHPlj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+ji3437/Pyk21iL3sJCh0d3P9v6j8bu7ve42ilwOWplfP8472QTzTLUpF7iq5jCf
	 HrFH2eRtcYH4JNqZFVZAJQ7i/k8f1foAVlxisDyhJ56teCZavvW+v4tEcCTeoQcfYu
	 ANcHiEWGde0dBM3MgRCOfC9vVepypbr5lNDr1O+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0348/1191] iio: srf04: fix pm_runtime handling on probe error path
Date: Sat, 12 Sep 2026 08:51:16 +0200
Message-ID: <20260912065556.044847373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit a40b2e7a17f26e38ab054363c9c7cde149588357 upstream.

When pm_runtime_set_active() fails during probe, the driver logs the
error and unregisters the IIO device, but then falls through and still
calls pm_runtime_enable() before returning the error.

Since probe returns an error, srf04_remove() is never called, so
runtime PM is left enabled without a matching pm_runtime_disable().
This leaks the enable and triggers an "Unbalanced pm_runtime_enable!"
warning on a subsequent bind of the device.

Return the error right after unregistering the IIO device so that
runtime PM is not enabled on the failure path.

Fixes: 2251157b335b ("iio: srf04: add power management feature")
Cc: stable@vger.kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/srf04.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/proximity/srf04.c
+++ b/drivers/iio/proximity/srf04.c
@@ -335,6 +335,7 @@ static int srf04_probe(struct platform_d
 		if (ret) {
 			dev_err(data->dev, "pm_runtime_set_active: %d\n", ret);
 			iio_device_unregister(indio_dev);
+			return ret;
 		}
 
 		pm_runtime_enable(data->dev);


