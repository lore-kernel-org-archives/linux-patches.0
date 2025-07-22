Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC185A32;
	Tue, 22 Jul 2025 13:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192400; cv=none; b=sgcsWLgPjgsbq4DkjLOFVPyAko//zFmNerg2W40EGYye79Dn34TKGzCFnwkZ2tHlHxA/3YlIhdEtvYiYNE73F3DrZQFLaCJ0KlkiuB913Dj4RjwmZUyCQRybWynePFX1vN1EZJNTCvAKH6GWNuSMO3geP3+sxY9Lda8ktAh5bq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192400; c=relaxed/simple;
	bh=eLGZU3cf28R4t5D8ECn+nPWneOlStHAocv9FOaB3XTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYSldJ4OZg4wQkZbKcoMKudvI7/ayJ7PEFY54w5gVecipJgv96jB0ucXrDNYr7yPn3U36AcXt0nt7Jif3knabqV5UF1NmmXMSjLo3JsxJsS4d8jEtIoC7qJNl1zbb4hhUIoxSl/FMIMUNAUJyoXfasduJZd4iQLmnpSN5EXam80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg6/gmm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg6/gmm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299A1C4CEEB;
	Tue, 22 Jul 2025 13:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192400;
	bh=eLGZU3cf28R4t5D8ECn+nPWneOlStHAocv9FOaB3XTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg6/gmm4OUpyiwuI9gWqp0SvfVXq48FfNdh6huuyq8gDK00B3K3in6OyhXZB/g3g3
	 EpE78/tSsFC6AkMKrFTVnY64Xhv5rqgy2G1cHfIBGia2lcOs9YhaLlhOBzaC6u9M5P
	 UslhiUGsSrZEU85TLfnvgcczE5XL6YLlj8dLD/Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.6 054/111] comedi: das6402: Fix bit shift out of bounds
Date: Tue, 22 Jul 2025 15:44:29 +0200
Message-ID: <20250722134335.397441703@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 70f2b28b5243df557f51c054c20058ae207baaac upstream.

When checking for a supported IRQ number, the following test is used:

	/* IRQs 2,3,5,6,7, 10,11,15 are valid for "enhanced" mode */
	if ((1 << it->options[1]) & 0x8cec) {

However, `it->options[i]` is an unchecked `int` value from userspace, so
the shift amount could be negative or out of bounds.  Fix the test by
requiring `it->options[1]` to be within bounds before proceeding with
the original test.  Valid `it->options[1]` values that select the IRQ
will be in the range [1,15]. The value 0 explicitly disables the use of
interrupts.

Fixes: 79e5e6addbb1 ("staging: comedi: das6402: rewrite broken driver")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707135737.77448-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/das6402.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/comedi/drivers/das6402.c
+++ b/drivers/comedi/drivers/das6402.c
@@ -567,7 +567,8 @@ static int das6402_attach(struct comedi_
 	das6402_reset(dev);
 
 	/* IRQs 2,3,5,6,7, 10,11,15 are valid for "enhanced" mode */
-	if ((1 << it->options[1]) & 0x8cec) {
+	if (it->options[1] > 0 && it->options[1] < 16 &&
+	    (1 << it->options[1]) & 0x8cec) {
 		ret = request_irq(it->options[1], das6402_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {


