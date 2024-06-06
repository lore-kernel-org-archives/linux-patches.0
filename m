Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D84198E9A;
	Thu,  6 Jun 2024 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683507; cv=none; b=ImXCN5jYTq9DG7XM5+wOLui0P907ydOfzlbwx31mE/MAdhOn9+G8/+AoEPGQ/RgT04C/tq72wNlmnShtkdhwMqD4MdH9NbgQMqJKUzK6zPMud7SHjVX3x9rmyQ1RQ4lHpvvI11M6zstbOA8MxjKHwWfFP5Fzs+5+I9r9Z9sGLxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683507; c=relaxed/simple;
	bh=lPMmsLXrCMD87bDX71WoTE8HaFHuB/Hf3O9wVcx/bo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQTQeX+LwNqxlNRPr8nqLQUL3OOWNvHp25eH3EvXnOrQVQ0GczdOrjupGjJCRHri5BodAedgQLlRSJ2ExuVm4scSoKzjr7kcQ8bg/do3XpV32Wobb2v5uoNe8si5TpsSVmO/v4v5Ao1j+lClIbgIOok9TOq71vdbTaeEFR00JzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgbNQ7s0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgbNQ7s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB3C32781;
	Thu,  6 Jun 2024 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683507;
	bh=lPMmsLXrCMD87bDX71WoTE8HaFHuB/Hf3O9wVcx/bo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgbNQ7s0/WCqh5SgwbFhfBtGviobY3VUiNyMz4OAxHH20hMUtrX+QmdFlI3IBJzvf
	 JvZz5X9I6k/8a5MZuFWXQoNWrayglJd62TzU2AalQF07ipRKE3fAd9QOp9yWwd+8cd
	 Pk8guH6iY2NQ9/PhvCc8tR159Sb75rm/EbZFKKz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 449/744] iio: buffer-dmaengine: export buffer alloc and free functions
Date: Thu,  6 Jun 2024 16:02:01 +0200
Message-ID: <20240606131746.901505212@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 9c446288d7b31402adb454535cb2c3cbdb55bb88 ]

Export iio_dmaengine_buffer_free() and iio_dmaengine_buffer_alloc().
This is in preparation of introducing IIO backends support. This will
allow us to allocate a buffer and control it's lifetime from a device
different from the one holding the DMA firmware properties. Effectively,
in this case the struct device holding the firmware information about
the DMA channels is not the same as iio_dev->dev.parent (typical case).

While at it, namespace the buffer-dmaengine exports and update the
current user of these buffers.

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240210-iio-backend-v11-4-f5242a5fb42a@analog.com
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: cf1c833f89e7 ("iio: adc: adi-axi-adc: only error out in major version mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/adi-axi-adc.c                      | 1 +
 drivers/iio/buffer/industrialio-buffer-dmaengine.c | 8 +++++---
 include/linux/iio/buffer-dmaengine.h               | 3 +++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index c247ff1541d28..0f21d1d98b9fa 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -447,3 +447,4 @@ module_platform_driver(adi_axi_adc_driver);
 MODULE_AUTHOR("Michael Hennerich <michael.hennerich@analog.com>");
 MODULE_DESCRIPTION("Analog Devices Generic AXI ADC IP core driver");
 MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS(IIO_DMAENGINE_BUFFER);
diff --git a/drivers/iio/buffer/industrialio-buffer-dmaengine.c b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
index 5f85ba38e6f6e..0d53c0a07b0d6 100644
--- a/drivers/iio/buffer/industrialio-buffer-dmaengine.c
+++ b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
@@ -159,7 +159,7 @@ static const struct iio_dev_attr *iio_dmaengine_buffer_attrs[] = {
  * Once done using the buffer iio_dmaengine_buffer_free() should be used to
  * release it.
  */
-static struct iio_buffer *iio_dmaengine_buffer_alloc(struct device *dev,
+struct iio_buffer *iio_dmaengine_buffer_alloc(struct device *dev,
 	const char *channel)
 {
 	struct dmaengine_buffer *dmaengine_buffer;
@@ -210,6 +210,7 @@ static struct iio_buffer *iio_dmaengine_buffer_alloc(struct device *dev,
 	kfree(dmaengine_buffer);
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_NS_GPL(iio_dmaengine_buffer_alloc, IIO_DMAENGINE_BUFFER);
 
 /**
  * iio_dmaengine_buffer_free() - Free dmaengine buffer
@@ -217,7 +218,7 @@ static struct iio_buffer *iio_dmaengine_buffer_alloc(struct device *dev,
  *
  * Frees a buffer previously allocated with iio_dmaengine_buffer_alloc().
  */
-static void iio_dmaengine_buffer_free(struct iio_buffer *buffer)
+void iio_dmaengine_buffer_free(struct iio_buffer *buffer)
 {
 	struct dmaengine_buffer *dmaengine_buffer =
 		iio_buffer_to_dmaengine_buffer(buffer);
@@ -227,6 +228,7 @@ static void iio_dmaengine_buffer_free(struct iio_buffer *buffer)
 
 	iio_buffer_put(buffer);
 }
+EXPORT_SYMBOL_NS_GPL(iio_dmaengine_buffer_free, IIO_DMAENGINE_BUFFER);
 
 static void __devm_iio_dmaengine_buffer_free(void *buffer)
 {
@@ -288,7 +290,7 @@ int devm_iio_dmaengine_buffer_setup(struct device *dev,
 
 	return iio_device_attach_buffer(indio_dev, buffer);
 }
-EXPORT_SYMBOL_GPL(devm_iio_dmaengine_buffer_setup);
+EXPORT_SYMBOL_NS_GPL(devm_iio_dmaengine_buffer_setup, IIO_DMAENGINE_BUFFER);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("DMA buffer for the IIO framework");
diff --git a/include/linux/iio/buffer-dmaengine.h b/include/linux/iio/buffer-dmaengine.h
index 5c355be898149..cbb8ba957fade 100644
--- a/include/linux/iio/buffer-dmaengine.h
+++ b/include/linux/iio/buffer-dmaengine.h
@@ -10,6 +10,9 @@
 struct iio_dev;
 struct device;
 
+struct iio_buffer *iio_dmaengine_buffer_alloc(struct device *dev,
+					      const char *channel);
+void iio_dmaengine_buffer_free(struct iio_buffer *buffer);
 int devm_iio_dmaengine_buffer_setup(struct device *dev,
 				    struct iio_dev *indio_dev,
 				    const char *channel);
-- 
2.43.0



