Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B2E32E692;
	Wed,  3 Dec 2025 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777039; cv=none; b=T9FcECfW4tzE2McF5oq0a8dJPEATRck3iE/baRs96F6kkPxPD4XafGbSmpp4GyLpoWVXLLo6Qt2vTBp3a2is4V3SFACGYcnCZHqGznsSX6lq+GMlLjosNpTGtbSOfFDYOvHHx4GixtyfbcfojEBHTlxDmftrN/q6xFKMnwiBUPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777039; c=relaxed/simple;
	bh=wzF3iDCGy+RNEvWHJZW1nlfulCgv5Rhh7RlRkC/DxsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dSgggCoC2vMsiGO1zsLqMZ/nuk6+3UK8GBf5cb8/UmfZxz1+OfzcNZ0a3/mYQDMICZGY4nFPzNTCgvz/sYe6w0FHxYgpUXGWQU7270T+J1y2K8pnqA1k0+xBHisdxHQvZ0rwQ86bgJD3mMU07OnzCUJBZNKcNrJyDjpFqTiGBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjzHRje+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjzHRje+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916C3C4CEF5;
	Wed,  3 Dec 2025 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777038;
	bh=wzF3iDCGy+RNEvWHJZW1nlfulCgv5Rhh7RlRkC/DxsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjzHRje+fVnyN+0a/2gNOsslyb/N4bvP5viUtSX24JXXidlsxyzHkxslIq53uJTMp
	 9VUQyujP3n3oedZUBrJw0SEa2cu22mIo4lMUJq/3JO02iRvK4Cei7OBdBIrGfVWFRe
	 tnDlTGYpqeCJC+xrVMnePvkDMQMEZrlJXByOfTN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 063/146] iio: accel: bmc150: Fix irq assumption regression
Date: Wed,  3 Dec 2025 16:27:21 +0100
Message-ID: <20251203152348.772808622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 3aa385a9c75c09b59dcab2ff76423439d23673ab upstream.

The code in bmc150-accel-core.c unconditionally calls
bmc150_accel_set_interrupt() in the iio_buffer_setup_ops,
such as on the runtime PM resume path giving a kernel
splat like this if the device has no interrupts:

Unable to handle kernel NULL pointer dereference at virtual
  address 00000001 when read

PC is at bmc150_accel_set_interrupt+0x98/0x194
LR is at __pm_runtime_resume+0x5c/0x64
(...)
Call trace:
bmc150_accel_set_interrupt from bmc150_accel_buffer_postenable+0x40/0x108
bmc150_accel_buffer_postenable from __iio_update_buffers+0xbe0/0xcbc
__iio_update_buffers from enable_store+0x84/0xc8
enable_store from kernfs_fop_write_iter+0x154/0x1b4

This bug seems to have been in the driver since the beginning,
but it only manifests recently, I do not know why.

Store the IRQ number in the state struct, as this is a common
pattern in other drivers, then use this to determine if we have
IRQ support or not.

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bmc150-accel-core.c |    5 +++++
 drivers/iio/accel/bmc150-accel.h      |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -526,6 +526,10 @@ static int bmc150_accel_set_interrupt(st
 	const struct bmc150_accel_interrupt_info *info = intr->info;
 	int ret;
 
+	/* We do not always have an IRQ */
+	if (data->irq <= 0)
+		return 0;
+
 	if (state) {
 		if (atomic_inc_return(&intr->users) > 1)
 			return 0;
@@ -1699,6 +1703,7 @@ int bmc150_accel_core_probe(struct devic
 	}
 
 	if (irq > 0) {
+		data->irq = irq;
 		ret = devm_request_threaded_irq(dev, irq,
 						bmc150_accel_irq_handler,
 						bmc150_accel_irq_thread_handler,
--- a/drivers/iio/accel/bmc150-accel.h
+++ b/drivers/iio/accel/bmc150-accel.h
@@ -58,6 +58,7 @@ enum bmc150_accel_trigger_id {
 
 struct bmc150_accel_data {
 	struct regmap *regmap;
+	int irq;
 	struct regulator_bulk_data regulators[2];
 	struct bmc150_accel_interrupt interrupts[BMC150_ACCEL_INTERRUPTS];
 	struct bmc150_accel_trigger triggers[BMC150_ACCEL_TRIGGERS];


