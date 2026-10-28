Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211106;
	b=5eDgN9BD3xmMD3MpR2ZJQgIKPSrRppiWQTshaqmJYq/Tb2OTj/4i6NO9cbI7FqVjlPU5
	 wfdu0izK37OBf+zIZD/OvUACmMLyt7hikKIWZOg2Mh7ocwmXCuOWJT99tpHwv9tiligBZ
	 v03nIwo8AldkNxs8ZKfXOjCH7NZH9FcQiPFSwQZfH7Q3m2s42RppU8CRCLO1KfDaCMtTX
	 D1XFNfjGxCWFVGY3IU75vcKIlz6nijpPN7P86nbS7pmLHniRaqwS8pOg+pDodZNEZxL5l
	 EPNNxQiZJUnWtxdtHeOLEtGqkp4TB9FQeI3aTnRZ8betugkXyiV6mctDp6tpPzaCXFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eGnop9lSpAjTVsaaKJaXGK9Hpb5MnyAJQJV/pAh1WUA=;
	b=x2GSR9EVhA6xNlP9BquSmOX9KNmF2Xg3/649CDIIIFMkls4ayF2/56ShRywQRr88X4l8
	 e93fhhLZq43cKNqqTJvfqUofPFRMGr20616jXis/rLV1MhCHeWhka7fO1PYqS/XOApkx1
	 u/9DDHfjHPkgdJOktzS0FE8rEtxoI6uO7KtQg9QS9mUtGo/jaxfjijSpRJ6mNdIy5x1Xc
	 q4o0pTHeTf5yW2yoCv2tO+jM4hPfMkWo4P6mc8d1KdwEmDIPYGk5iJ3wAsKQLFxVkjQBa
	 Vvbq+yAPeSasft8x8Tbpg7av0T7Lj8NFC7RCPOsj4IaTm5vPzqtTj2f+tcR/P8jnGcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KocHjebm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5185860A2617;
	Wed, 28 Oct 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KocHjebm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E961F01825;
	Wed, 28 Oct 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211106;
	bh=eGnop9lSpAjTVsaaKJaXGK9Hpb5MnyAJQJV/pAh1WUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KocHjebmJ+V9FEnrmevbWfVDt8PDoTT7sjX4p++cePS/PyLKiEZvLAiPlmschC2Xv
	 U6x9hqLEEvpbEuYTnUwsYWPJfvrDpfbXTr9SV3OgTwV89GOeAgHlae/fDorvEPFWHp
	 OSJWoXFmP1nBz1YFLbSkVKdanCRd2hfXOIkxfDQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 260/571] iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure
Date: Wed, 28 Oct 2026 17:56:47 +0100
Message-ID: <20261028170014.175590530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit 4daa9ca557b4b98ae1ad38a6d1deaa3e31eb8edf upstream.

pm_runtime_set_active() failing in probe() jumps to error_unreg_buffer,
which only calls iio_triggered_buffer_cleanup() -- it does not undo the
iio_device_register() that already succeeded a few lines above. probe()
then returns the error, the devm-managed indio_dev is freed, but the
iio core still has it registered: the sysfs/chardev nodes stay live and
point at freed memory.

Add an error_unreg_dev label that unregisters the iio device before
falling through to the existing buffer cleanup, mirroring the teardown
order already used in lidar_remove().

Fixes: 4ac4e086fd8c ("iio: pulsedlight-lidar-lite: add runtime PM")
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -299,12 +299,14 @@ static int lidar_probe(struct i2c_client
 
 	ret = pm_runtime_set_active(&client->dev);
 	if (ret)
-		goto error_unreg_buffer;
+		goto error_unreg_dev;
 	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
 	return 0;
 
+error_unreg_dev:
+	iio_device_unregister(indio_dev);
 error_unreg_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 


