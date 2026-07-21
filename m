Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CFF399015;
	Tue, 21 Jul 2026 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674431; cv=none; b=oTtDq4UX5bOgkXYAuYYMaP0AmE6q+RQU76UFtj+b9FVDWOgR79YKuKYiQVRmDsC7s+vQLLC1iXgRR1WwzrTWpdorSYYZPANIkd7LgkooTQi4bgPbgrvfztcVI01snHl225WpnUE8fd6B3vIaUbXXgzXOx51EYsy/gukBGF7kmTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674431; c=relaxed/simple;
	bh=MurggVCtwziLxPYFF4wXpJkk0Yo2g+7ikqhkY7f26Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+9p1/2djUMwrYOIHbnvthW0deeld9PSt0jkitg9M0OLs9S5rAsEskOQQD8oG2C9nYgqm9eU94repDmVfDfRC7uzrwZRbRKlIrw3EWJ4vLr5PWi2H2leDf3B2qlIs62dXTUfiGF5m9jOdwFJ5zBMXvuhG5EY7voZNGr1M+u7Ors=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaxZfx9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaxZfx9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF001F000E9;
	Tue, 21 Jul 2026 22:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674429;
	bh=27ky9UJq8zGGBPaSZOqMYkjCtSt6B68QYhnUTrcF46c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaxZfx9KdDVKdBeBGNispyY6zaj/K+VdrXp3026F6q7v8+jtY3+lRnlzbAAqI/pO8
	 FOR0kOn529YfRaZrGYWeHiFmIFAmnx7Zu2hMWmbmIrbaJym6dFYw/WCCA0Nx2e02Xo
	 GOxpLmRYcA73Rfy1L9pyJtDMWjOZ20gzljdoDaRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.10 536/699] ieee802154: ca8210: fix pointer truncation in kfifo on 64-bit
Date: Tue, 21 Jul 2026 17:24:55 +0200
Message-ID: <20260721152407.790294213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>

commit 6d7f7bcf225b2d566176bf6229dbd1252940cb3c upstream.

ca8210_test_int_driver_write() and ca8210_test_int_user_read() exchange
a kmalloc'd buffer pointer through a struct kfifo, but pass a literal
'4' as the byte count to kfifo_in()/kfifo_out().

This is correct on 32-bit (pointer = 4 bytes), but on 64-bit only the
low 4 bytes of the 8-byte pointer are written into the FIFO. The reader
then reads back 4 bytes into an 8-byte local pointer variable, leaving
the upper 4 bytes uninitialized stack data. The first dereference of
the reconstructed pointer (fifo_buffer[1]) accesses an arbitrary kernel
address and generally results in an oops.

Use sizeof(fifo_buffer) so the byte count matches pointer width on every
architecture.

The driver has no architecture restriction in Kconfig, so any 64-bit
build with CONFIG_IEEE802154_CA8210_DEBUGFS=y is exposed. Issue has
been latent since the driver was added in 2017 because it is most
commonly deployed on 32-bit MCUs.

Found via a custom Coccinelle semantic patch hunting for short-byte
kfifo I/O on byte-mode kfifos used to shuttle pointers.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/20260520105750.30144-1-shitalkumar.gandhi@cambiumnetworks.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/ca8210.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -638,7 +638,7 @@ static int ca8210_test_int_driver_write(
 	fifo_buffer = kmemdup(buf, len, GFP_KERNEL);
 	if (!fifo_buffer)
 		return -ENOMEM;
-	kfifo_in(&test->up_fifo, &fifo_buffer, 4);
+	kfifo_in(&test->up_fifo, &fifo_buffer, sizeof(fifo_buffer));
 	wake_up_interruptible(&priv->test.readq);
 
 	return 0;
@@ -2571,6 +2571,7 @@ static ssize_t ca8210_test_int_user_read
 	struct ca8210_priv *priv = filp->private_data;
 	unsigned char *fifo_buffer;
 	unsigned long bytes_not_copied;
+	unsigned int copied;
 
 	if (filp->f_flags & O_NONBLOCK) {
 		/* Non-blocking mode */
@@ -2584,7 +2585,8 @@ static ssize_t ca8210_test_int_user_read
 		);
 	}
 
-	if (kfifo_out(&priv->test.up_fifo, &fifo_buffer, 4) != 4) {
+	copied = kfifo_out(&priv->test.up_fifo, &fifo_buffer, sizeof(fifo_buffer));
+	if (copied != sizeof(fifo_buffer)) {
 		dev_err(
 			&priv->spi->dev,
 			"test_interface: Wrong number of elements popped from upstream fifo\n"


