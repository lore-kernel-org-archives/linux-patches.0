Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE3E2DA775;
	Wed,  9 Sep 2026 14:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962417; cv=none; b=m6xuvA8+2DeX+eRWLTf2Wlyy0S58C80H8IqrsGaTXPQuktzEmOUS8iiW1oLfgCWXIklw1eSl5JRJNFZSIPGyuhIHRaIS5ZJJYI8xmoLUdXiBsJREZkDCjHIhp529V9XhlDm9DL45jGCvcIoR4ltGSRXjM0o6D0iRxhJEo7rMpsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962417; c=relaxed/simple;
	bh=DpPp9rL1HoQVV3sIOfCgK9Ic3YR1ulNK95OL/TIy55Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThuIcbbfWc7YfJiwrmYNqwxrigdKcBt11zpP0wPTdGK7Z5Gmuy4ADOHe+/ggdeKP+4OmvmVclbhq0jn9uUbSh0rmTDDkadMKo5ts3D1OKvi6zImuYfqY+Cdq88DUiVo/BYHbkcegQ5QABe6Fv3GTqR/+KbprvLe1JgxdSe1YCMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjYbewPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjYbewPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C617A1F00A3A;
	Wed,  9 Sep 2026 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962416;
	bh=b0uPNh+Se3szdHY9tXioeQ6YbdcexPpRsxxhMwPQzLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjYbewPRExlq/pcMx68somZX9895Cya4m7Q0aTv7ykYhyU64dUckai42qLOYIUcv/
	 3rdWcY5rkiv/jNfkCFn9WGPHm8ieK5Vnd955/gdAmoyr29k8fqfCvB4q8avunHO2j0
	 X/gn2X/vyPc8OtfTNBEXHz1UFWzqezHKmIof3Qcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 282/556] iio: srf04: fix pm_runtime handling on probe error path
Date: Wed,  9 Sep 2026 15:39:22 +0200
Message-ID: <20260909134240.575596276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,6 +330,7 @@ static int srf04_probe(struct platform_d
 		if (ret) {
 			dev_err(data->dev, "pm_runtime_set_active: %d\n", ret);
 			iio_device_unregister(indio_dev);
+			return ret;
 		}
 
 		pm_runtime_enable(data->dev);


