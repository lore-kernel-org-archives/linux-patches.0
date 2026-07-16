Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BD822301;
	Thu, 16 Jul 2026 13:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210236; cv=none; b=tDjmOGhutERMfLL3UnNhE8v/jsnTY66xnWbQqnPHoZ+2RH31fbWA2V3k8pxGqxv/Z0MLMGcxKkJCuagF2WfroSJJzjDvJucBFwKiw+W0Sh990/h9X2txhkvCawP+R/QtOd2nphebTy0w7PxR6AcFueEAXRWLuuA21rStzXTqPYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210236; c=relaxed/simple;
	bh=X0qQY6konPrBHBraY+lozsHC8kGq5v/YPDaGtQeHXXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2hckHXXQrKW7KWfoUMp3NkWC4ruTJWm0IABlIIrljqC1clCvCT8BNfUrIThT5BBiTqCxV0dpopgHoruEN+lfAUZzNrai100O8itlBO3htnz/t7iqhwM0TAiEnsea9kDzBmG8PCFjjdkw9CZbWsbLMtEgGUoczN+yM5bl6afyPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdjNStGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdjNStGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F251F000E9;
	Thu, 16 Jul 2026 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210235;
	bh=+72X+O9oCU68e1fm4HJkjDOHVbPDDBb2FoXleDoXLG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdjNStGeavvZvCwGmf9WMSIcgFTtEPn3yKXpFsESYyBgkeruaUA442tpu0zYxGo1S
	 gZX2FRr7RaLCcf8HLhGP+P5vfx+2rDI5RjVJe0yX5wSy7dL63QyGOPri3pWlKqvX9l
	 D5D3CsD1AknopslDjCkSfi3Rc5s+rQ7XOWgP+eYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Featherston <mark@embeddedTS.com>,
	Kris Bahnsen <kris@embeddedTS.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 487/518] Input: ads7846 - dont use scratch for tx_buf when clearing register
Date: Thu, 16 Jul 2026 15:32:35 +0200
Message-ID: <20260716133058.504133554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Kris Bahnsen <kris@embeddedTS.com>

commit 856668312685d9a8f32d49a135a89c429d309f81 upstream.

The workaround for XPT2046 clears the command register, giving the
touchscreen controller a NOP. The change incorrectly re-uses the
req->scratch variable which is used as rx_buf for xfer[5], so by
the time xfer[6] occurs, the contents of req->scratch may not be
0. It was found that the touchscreen controller can end up in
a completely unresponsive state due to it being given a command
the driver does not expect.

Instead, rely on the spi_transfer behavior of tx_buf being NULL to
transmit all 0 bits and use the scratch variable for the rx_buf for
both the 1 byte command to and 2 byte response from the controller.

Also relocates the scratch member of struct ser_req to force it
into a different cache line to prevent any potential issues of
DMA stepping on unrelated data in other struct members due to
sharing the same cache line.

This change was tested on real TSC2046 and ADS7843 controllers,
but not the XPT2046 the workaround was originally created for.
Confirming that the original modification to clear the command
register does not impact either real controller.

Fixes: 781a07da9bb94 ("Input: ads7846 - add dummy command register clearing cycle")
Cc: stable@vger.kernel.org
Co-developed-by: Mark Featherston <mark@embeddedTS.com>
Signed-off-by: Mark Featherston <mark@embeddedTS.com>
Signed-off-by: Kris Bahnsen <kris@embeddedTS.com>
Link: https://patch.msgid.link/20260507164943.760009-1-kris@embeddedTS.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ads7846.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -325,7 +325,6 @@ struct ser_req {
 	u8			ref_on;
 	u8			command;
 	u8			ref_off;
-	u16			scratch;
 	struct spi_message	msg;
 	struct spi_transfer	xfer[8];
 	/*
@@ -333,6 +332,7 @@ struct ser_req {
 	 * transfer buffers to live in their own cache lines.
 	 */
 	__be16 sample ____cacheline_aligned;
+	u16			scratch;
 };
 
 struct ads7845_ser_req {
@@ -403,8 +403,7 @@ static int ads7846_read12_ser(struct dev
 	spi_message_add_tail(&req->xfer[5], &req->msg);
 
 	/* clear the command register */
-	req->scratch = 0;
-	req->xfer[6].tx_buf = &req->scratch;
+	req->xfer[6].rx_buf = &req->scratch;
 	req->xfer[6].len = 1;
 	spi_message_add_tail(&req->xfer[6], &req->msg);
 


