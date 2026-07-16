Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47AA3161AD;
	Thu, 16 Jul 2026 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211499; cv=none; b=sFj7FFMYUkHRQFR55gheIBsr39QaGUeW23IlENaXtLSLHtiznYwf69yWJqHlyKmC/odYuCSkCN7ODPU+99BxsPMDJxwWVKOrxgGxqRATQTv6zZWjQAqMkUuyYZ49iqmA2Fx/9wXd6c2LcsLg4kzS5sGGOng00Ll7ZKBAqoeEF/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211499; c=relaxed/simple;
	bh=G42PTTF3PFD1rYtgFs7Y7IPbYLJJbhmIaOEt/CRF19I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1MgwG2P2+5ofd6z251Dx2a5TimLfFdOPpLJAdwxDVtltKy32gxv5nCeT2O/gyCG6IpzduY2wXbX1P6I2Clw88CkWchrfuqNO/SixJYaMOACfJuOFJzkr5YW09LbD0QJ5A2DILjbS43RCg/f4EhjF+o1XD6Ay/3jrfkG/7y9jdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxT0DzQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxT0DzQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EFE1F000E9;
	Thu, 16 Jul 2026 14:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211498;
	bh=P+2tXxspCz4/ujZ4YepR4deBVve6tseKWmZzKFqzboI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxT0DzQCr0KM/R63WTpRFDVS8f67fLNUgX/3SCSBKuqm7PCSuy/N/PiA5r5KJhMub
	 /TnXu3jaarBmBvJUqO78EPZBWJ1Yjju3iLW/36Ti5vqntT3WNfJIp/XAv1pHqYAows
	 Lq+UU3R+MIXXsBNzLBc5FfXFYhXMAnxTXsofDNX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Featherston <mark@embeddedTS.com>,
	Kris Bahnsen <kris@embeddedTS.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 450/480] Input: ads7846 - dont use scratch for tx_buf when clearing register
Date: Thu, 16 Jul 2026 15:33:17 +0200
Message-ID: <20260716133054.556514586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -329,7 +329,6 @@ struct ser_req {
 	u8			ref_on;
 	u8			command;
 	u8			ref_off;
-	u16			scratch;
 	struct spi_message	msg;
 	struct spi_transfer	xfer[8];
 	/*
@@ -337,6 +336,7 @@ struct ser_req {
 	 * transfer buffers to live in their own cache lines.
 	 */
 	__be16 sample ____cacheline_aligned;
+	u16			scratch;
 };
 
 struct ads7845_ser_req {
@@ -408,8 +408,7 @@ static int ads7846_read12_ser(struct dev
 	spi_message_add_tail(&req->xfer[5], &req->msg);
 
 	/* clear the command register */
-	req->scratch = 0;
-	req->xfer[6].tx_buf = &req->scratch;
+	req->xfer[6].rx_buf = &req->scratch;
 	req->xfer[6].len = 1;
 	spi_message_add_tail(&req->xfer[6], &req->msg);
 


