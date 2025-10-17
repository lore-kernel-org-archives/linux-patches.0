Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E235330B37;
	Fri, 17 Oct 2025 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715588; cv=none; b=qHvRiPmsKiRFnkO+w+kaNUsJNDkjJaaZbzUVKxzn3rjeIRKdcO7N3wceb7o4duUw8hKZDZZr51WZo+y+QKpYE9QPELgTDFEPwM4zV9pWz1TEYXzO2j9gYdMqSv8oLZ5PBUEFSGGhW4d/FPtOcmiAdc32uMjrH5za0nW1Exz6URE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715588; c=relaxed/simple;
	bh=oo+oGRk6SMfz+59cVQT0pWToIfN2hwnmbYtlRBFx57s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoWRmKZblOlqZHRMX+pt6rD0WVoq7loD6r5j46f9Yf/+v30fUyU0PlPTUpsm+IXz2KNBsiR9uQdkw/8mbd5DUGU6xwPxnI5StRakRC905DiAErWfX1QyARHP9j7EEs2E66N4Y/XXkuYLSkYkcmoCk+y6IIiW1AWuRwJ+KaXCoTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMI4hQCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMI4hQCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FF5C4CEE7;
	Fri, 17 Oct 2025 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715588;
	bh=oo+oGRk6SMfz+59cVQT0pWToIfN2hwnmbYtlRBFx57s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMI4hQCWYEXaogi2SdKwV6XlZgPTqMakO0SCdWQdBo8Sjx/e7RjuqGPQ6H8bK7eR4
	 KHMP2kinvryKkb2ewgXk4Xs+5nMiVhL66uGFNSrQ5RGWceKTZlzsedR/AccCqCpzTD
	 DiBEIovEvF0NE7AjeEzlBii//leIV/NXxJ9SsCYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 267/371] mmc: mmc_spi: multiple block read remove read crc ack
Date: Fri, 17 Oct 2025 16:54:02 +0200
Message-ID: <20251017145211.738099141@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Chen <rex.chen_1@nxp.com>

commit fef12d9f5bcf7e2b19a7cf1295c6abd5642dd241 upstream.

For multiple block read, the current implementation, transfer packet
includes cmd53 + cmd53 response + block nums*(1byte token +
block length bytes payload + 2bytes CRC + 1byte transfer), the last
1byte transfer of every block is not needed, so remove it.

Why doesn't multiple block read need CRC ack?
For read operation, host side get the payload and CRC value, then
will only check the CRC value to confirm if the data is correct or
not, but not send CRC ack to card. If the data is correct, save it,
or discard it and retransmit if data is error, so the last 1byte
transfer of every block make no sense.

What's the side effect of this 1byte transfer?
As the SPI is full duplex, if add this redundant 1byte transfer, SDIO
card side take it as the token of next block, then all the next sub
blocks sequence distort.

Signed-off-by: Rex Chen <rex.chen_1@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250728082230.1037917-3-rex.chen_1@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmc_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -563,7 +563,7 @@ mmc_spi_setup_data_message(struct mmc_sp
 	 * the next token (next data block, or STOP_TRAN).  We can try to
 	 * minimize I/O ops by using a single read to collect end-of-busy.
 	 */
-	if (multiple || write) {
+	if (write) {
 		t = &host->early_status;
 		memset(t, 0, sizeof(*t));
 		t->len = write ? sizeof(scratch->status) : 1;


