Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA282ECD1D;
	Sat, 12 Sep 2026 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221634; cv=none; b=QQ5T+WQDpOKJz2/Y9dVvjOcevjjAPQdkA/+caQfUsi5ET02fXIbzrP/JnpTY4e3vPC+jEy9hkt7R3mGWwYTtK+FNLgWNtxShpcpEI1AlfBFXz2AeGPNFW59m6jJAmoI2DPbnDpEFv5XvK95UePZHgxZ8+BMD7N74sMI1ecwTg8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221634; c=relaxed/simple;
	bh=yRcvpNZwuWOaY/pEgPvA+g9fkuAR1p2FE1bR63OqiJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfV8NxFmLWLyuFWmqFkBMllA53X48kKeNVd4h1TfENLpAe2az2rRVNw0wNNOn7iqGvw9yOw/Y5YxhprLcwCry9Rb3m7PJ8ym+GejQCTvlUsf+IdQYTjD74vhA6R1gf27715qOvyEFg7XzZXAp4HdHB9O6ViZJLxtQ4bGMNm2Vsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5Y+hORa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5Y+hORa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20311F000FF;
	Sat, 12 Sep 2026 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221633;
	bh=3SyyL5dK6aKVTfVb1taZ+/M6HVlfCm7xPt9vFnPbIwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5Y+hORaHrsCzgPnE/ZPMEf8aeXh5Mm28P3VYqEBpYlkhanF/BeB/WqMiiBjoOiyT
	 qbr3zvZJ8sUhhWdpsLfzNET6KuqspUQaTf9CAcn7sM7CdEKvSFqPmOzBd7eLgLMGf+
	 d601tkixCPfsRRAqeIzODkpAcrDCEgA1MDrTY1UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0422/1424] iio: srf04: fix pm_runtime handling on probe error path
Date: Sat, 12 Sep 2026 08:47:34 +0200
Message-ID: <20260912065616.733182480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


