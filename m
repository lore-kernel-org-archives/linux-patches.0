Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BE729D26C;
	Tue, 17 Mar 2026 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766935; cv=none; b=rdY1pSYbAgvHT3kh0hLqQNBrYJRXpPCuZZfdMhuFUS6kdlc/i4r/j2hNzishC7QPaJpvROKAxPL3L1uasygSySCaKzHg95L1gaZFpM/S8lmwffmw/ij+5DsAukcJOCl+Llmp2j4ij/66pSJ2K5xsevLRr+kK8CR/rx/vSGf7X6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766935; c=relaxed/simple;
	bh=256NaqfI2mIzJWmWzRLsbDdnB1z8HDleVQD0VPktt+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxRQZBAov6hNdmW8pDYzgq+M5dFdP9qIrKc8LpH4WGidgR9OGvJRVShquwx5MYZuEMae8aeTGaR2L9WJPIFUZjMFt2PDqVBp1ipjgJOZ5SsH/9kcskhrqQptKhVtb/W7537tVScCxTqgytIPhj1vtaMKbIoNHQ46+KlYWinRpvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5Okw8AA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5Okw8AA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5D2C4CEF7;
	Tue, 17 Mar 2026 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766935;
	bh=256NaqfI2mIzJWmWzRLsbDdnB1z8HDleVQD0VPktt+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5Okw8AA7XdtswoulPo8q68OPWAfuwBwz9qjO1Mq7gDJRG/5RdZLLyEWhqS5SpVbI
	 lI8a36fEja0QY5lTMfyZ2EU9P4MQb9wRMFFrVEPEWjtDvQ0cDtVsNrGzt9UoeYb1MR
	 t50TVbGCSvtBzSxOkXr6jjStCzq1GhgwAa6uVspQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Sabau <radu.sabau@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 355/378] iio: imu: adis: Fix NULL pointer dereference in adis_init
Date: Tue, 17 Mar 2026 17:35:12 +0100
Message-ID: <20260317163020.045337863@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Sabau <radu.sabau@analog.com>

commit 9990cd4f8827bd1ae3fb6eb7407630d8d463c430 upstream.

The adis_init() function dereferences adis->ops to check if the
individual function pointers (write, read, reset) are NULL, but does
not first check if adis->ops itself is NULL.

Drivers like adis16480, adis16490, adis16545 and others do not set
custom ops and rely on adis_init() assigning the defaults. Since struct
adis is zero-initialized by devm_iio_device_alloc(), adis->ops is NULL
when adis_init() is called, causing a NULL pointer dereference:

    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
    pc : adis_init+0xc0/0x118
    Call trace:
     adis_init+0xc0/0x118
     adis16480_probe+0xe0/0x670

Fix this by checking if adis->ops is NULL before dereferencing it,
falling through to assign the default ops in that case.

Fixes: 3b29bcee8f6f ("iio: imu: adis: Add custom ops struct")
Signed-off-by: Radu Sabau <radu.sabau@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -526,7 +526,7 @@ int adis_init(struct adis *adis, struct
 
 	adis->spi = spi;
 	adis->data = data;
-	if (!adis->ops->write && !adis->ops->read && !adis->ops->reset)
+	if (!adis->ops)
 		adis->ops = &adis_default_ops;
 	else if (!adis->ops->write || !adis->ops->read || !adis->ops->reset)
 		return -EINVAL;


