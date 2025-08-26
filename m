Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA8352098;
	Tue, 26 Aug 2025 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217134; cv=none; b=Kty75mjY0vdqASLlXsNIKAUi2cXwDxKxh0A8VsCo0VEra2MP7LGEI+PWvxt4R2QRd5NORiA/Hz88o0yILliTqGMG/WsEY/nmwl/l3JQrqJ27JfJ7fYmAJs0EgkjMK8Lkdls5yglAqDtWmYO/xrG/4J1ULjGgBqpItCla9B8yur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217134; c=relaxed/simple;
	bh=zqxARwGVGfeU0iAd92I6ZmtqHCk2OTMybRgCzhBzqvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2Iu+OnRCEQYBDTzgiOw7NJ2VKwg8Z8Vb8Jai1kZle2o1a84dnoZIJD4CT7SlIwZ71Gma4pszpKXhA4ranVRgthTWgxnOXRVUPUWc8xQpTU0HAJS2KzMGKj3RjD79GPG7ybVXmTQp/ddHmKUEJEQYiO5FWlO/X2IqK1bETxlkJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a33F/soh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a33F/soh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E7DC4CEF1;
	Tue, 26 Aug 2025 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217134;
	bh=zqxARwGVGfeU0iAd92I6ZmtqHCk2OTMybRgCzhBzqvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a33F/sohOyMKf3U+UVhlHv2qp4WVkG+E3PdaACwJjVXzyWdNmEMX8G/7ySa2p1AdX
	 cf4B8ByrOrRTf40WkEAdqn9MyFzc2AIupM4rQR7HFxJbOXo5fxKVI1I4Qm4o7x221V
	 X9eFBGa1EocwUlqhvgAOrPnx8xpGISCzxPMqmwAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 028/523] comedi: aio_iiro_16: Fix bit shift out of bounds
Date: Tue, 26 Aug 2025 13:03:58 +0200
Message-ID: <20250826110925.291098270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 66acb1586737a22dd7b78abc63213b1bcaa100e4 upstream.

When checking for a supported IRQ number, the following test is used:

	if ((1 << it->options[1]) & 0xdcfc) {

However, `it->options[i]` is an unchecked `int` value from userspace, so
the shift amount could be negative or out of bounds.  Fix the test by
requiring `it->options[1]` to be within bounds before proceeding with
the original test.  Valid `it->options[1]` values that select the IRQ
will be in the range [1,15]. The value 0 explicitly disables the use of
interrupts.

Fixes: ad7a370c8be4 ("staging: comedi: aio_iiro_16: add command support for change of state detection")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707134622.75403-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/aio_iiro_16.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -178,7 +178,8 @@ static int aio_iiro_16_attach(struct com
 	 * Digital input change of state interrupts are optionally supported
 	 * using IRQ 2-7, 10-12, 14, or 15.
 	 */
-	if ((1 << it->options[1]) & 0xdcfc) {
+	if (it->options[1] > 0 && it->options[1] < 16 &&
+	    (1 << it->options[1]) & 0xdcfc) {
 		ret = request_irq(it->options[1], aio_iiro_16_cos, 0,
 				  dev->board_name, dev);
 		if (ret == 0)


