Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B744569F04;
	Wed,  9 Sep 2026 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962359; cv=none; b=HnidRN0KnM0mgV0OjCcOCReQQJUx8906C9sttIFyLiXBgSK1BpfJLJz4xiXJZeZyM5m0XsofAWzIF3w1K3VRV6alUX6w6POp5WrxGXZGspm432bpD5NVE+stimz4702RSrhsYAYo4WuQ546JHyRdBKq+MpbmX6BJzORL+PVV5lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962359; c=relaxed/simple;
	bh=viWLrawkEytnixmBSMSFPIIVTAZ94QCEn048T5R0Spc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8IuRzQFwtNMExP1B9oX0vIXwRx1QGreTsV57jvwUvsTzGt+L2kZUVJZGK0Zg2zj9shU0uA5Sy1tW4EBNz3EpYHdtZLQ1TxpXVRCKe20zcX84SC5ElvivYN4iovZSP3qyljeS3xeVf4+CtIaJJF1tPC3g0kldZAa2uC/42zoxCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OehJB+Wp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OehJB+Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832201F00A3A;
	Wed,  9 Sep 2026 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962358;
	bh=rHbQphr1QWLaql0u1ZxIl5pF0sGlhK0DyvqdqfxNyyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OehJB+Wp8wSQF9lrO8lXTrKp+sN2Y3m1gWaBzGsXYUlfHxyUVK9zpPCYhOchXMy+e
	 lr1DKXr7rLQkvQWSGkqlcclUrJhtm1bxaIJj0hznf4x4VaRF8VQUAhDA/o+Iz/NqoU
	 rxOOry9PPa/F94iyJSNT2bCZUqR2KDnSJ4mFVGXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 264/556] iio: buffer: Fix potential use-after-free in anonymous buffer release
Date: Wed,  9 Sep 2026 15:39:04 +0200
Message-ID: <20260909134239.831393098@linuxfoundation.org>
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

From: Lars-Peter Clausen <lars@metafoo.de>

commit 6288b593e76eb10329326f2cd51e32557203b9e5 upstream.

An anonymous buffer handle holds a reference to the underlying IIO device.
The reference is dropped in the buffer handle's release function. If the
device has been removed, either through unbind or hot-unplug, the buffer
handle might hold the last reference.

The release function takes the mutex for the buffer using a guard, which
means the unlock happens after all the code in the function, including
`iio_device_put()`. If the anonymous buffer holds the last reference this
might free both the IIO device and the buffer, which contains the mutex,
leading to use-after-free when the mutex is unlocked.

Fix this by using a scoped guard just around the buffer dmabuf list access,
making sure the mutex is unlocked before releasing the IIO device.

Version 10 of the patch that introduced this issue used this exact scheme
of first unlocking and then dropping the reference [1]. During review it
was suggested to use a guard instead, and version 11 made that change [2].

Reported-by: codex:gpt-5.6
Fixes: 3e26d9f08fbe ("iio: core: Add new DMABUF interface infrastructure")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/linux-iio/20240605110845.86740-4-paul@crapouillou.net #[1]
Link: https://lore.kernel.org/linux-iio/20240618100302.72886-4-paul@crapouillou.net #[2]
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1619,12 +1619,16 @@ static int iio_buffer_chrdev_release(str
 
 	wake_up(&buffer->pollq);
 
-	guard(mutex)(&buffer->dmabufs_mutex);
-
-	/* Close all attached DMABUFs */
-	list_for_each_entry_safe(priv, tmp, &buffer->dmabufs, entry) {
-		list_del_init(&priv->entry);
-		iio_buffer_dmabuf_put(priv->attach);
+	/*
+	 * The mutex must be unlocked before iio_device_put(), which might drop the
+	 * last reference and free the buffer.
+	 */
+	scoped_guard(mutex, &buffer->dmabufs_mutex) {
+		/* Close all attached DMABUFs */
+		list_for_each_entry_safe(priv, tmp, &buffer->dmabufs, entry) {
+			list_del_init(&priv->entry);
+			iio_buffer_dmabuf_put(priv->attach);
+		}
 	}
 
 	kfree(ib);


