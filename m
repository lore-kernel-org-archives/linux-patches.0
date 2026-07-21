Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EF73E7141;
	Tue, 21 Jul 2026 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655022; cv=none; b=tD951q5GMaG9jORldnP13SsirKscR0WazvE5hStXrjHa5wSgUjTIvRz7nSuZxenDxCtaB2u0YId+p/st1bgggX2WjQWpukH15EyYudqYnkhf2K9cXrZ7imR/3uLerZ/x6S7Kou3ohzhCeqB1Ddjk9hmzxg7CJUr/lKcnT3Wb5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655022; c=relaxed/simple;
	bh=MxE4t/vLc/FFFmD68zQSNatbATmcje2Le3DWuX5Lx40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcM4O0ZKnzwqHUafxrWot+8BpUwFyVCgHMO8gfv9uLNkhg63rX0GT0UXyUq4K1kmeE7vwcORoK8czsk5OZcPtxr6jIkhaTE9bgqWeIk50aTD6CoJO/BsnPgd8F/yxuVT4D5ZUV0sXAX+NqbYYi934fLAg0SpmCF6z8b267DRKvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVRXOoBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVRXOoBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C739B1F000E9;
	Tue, 21 Jul 2026 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655021;
	bh=CfDy9bvz0KZZrL+X6ZHLHpqoaGGolhkuQg8ny4afMrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVRXOoBPzYzmdA6oQAD0jiVrnm/67B8xBjuppXV57SNvP+kwVnXyIjWpbK+bOW/B1
	 Nfe1kZDI4T7n+Mz+nX6E8kqX+tUuNxJZe0vddqdMuLpbkWwkkInx4TWpfU++AMovQ7
	 Z1Fh7unD/TW7hwO4VVE5eAhNY7xgrquRj3YHaPR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 7.1 1925/2077] ieee802154: ca8210: fix pointer truncation in kfifo on 64-bit
Date: Tue, 21 Jul 2026 17:26:38 +0200
Message-ID: <20260721152638.116144282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
@@ -595,7 +595,7 @@ static int ca8210_test_int_driver_write(
 	fifo_buffer = kmemdup(buf, len, GFP_KERNEL);
 	if (!fifo_buffer)
 		return -ENOMEM;
-	kfifo_in(&test->up_fifo, &fifo_buffer, 4);
+	kfifo_in(&test->up_fifo, &fifo_buffer, sizeof(fifo_buffer));
 	wake_up_interruptible(&priv->test.readq);
 
 	return 0;
@@ -2526,6 +2526,7 @@ static ssize_t ca8210_test_int_user_read
 	struct ca8210_priv *priv = filp->private_data;
 	unsigned char *fifo_buffer;
 	unsigned long bytes_not_copied;
+	unsigned int copied;
 
 	if (filp->f_flags & O_NONBLOCK) {
 		/* Non-blocking mode */
@@ -2539,7 +2540,8 @@ static ssize_t ca8210_test_int_user_read
 		);
 	}
 
-	if (kfifo_out(&priv->test.up_fifo, &fifo_buffer, 4) != 4) {
+	copied = kfifo_out(&priv->test.up_fifo, &fifo_buffer, sizeof(fifo_buffer));
+	if (copied != sizeof(fifo_buffer)) {
 		dev_err(
 			&priv->spi->dev,
 			"test_interface: Wrong number of elements popped from upstream fifo\n"


