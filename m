Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D18372624;
	Tue, 22 Jul 2025 13:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192077; cv=none; b=F4bvpXViDWxwY93tH/rZNjxRoFCCJtpTerntRHVhJW9ZeTdS7TfiCK9XaGBVfJhVColgMgIssyTZ8Ret3CZvo8zU7zLZteuFbf6wV2UyyOn7DMJ9Jgs2fVtK7BptnVU/APcVMrj8DCNyfsROM51UzyDkUvsoKavofxfOsV6yD+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192077; c=relaxed/simple;
	bh=mDoF7L2y3Ypw62wFfRs8vvPc6TeRqijWahwDXlGk6Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx+g8kv8r8rQABV++taYA3/KSnliF52TEmkgSVAuubuO1ozFZk8UULreEWvXWd6H82UdpqC02EEx8+cCI0WSL3lMnSAL6FmVZBbspfgMR+4b+ORfJMWXq3Db1kQlV/7z96Q3Ie++qIHz7Kv/ndL9tM7QcjPvYdIdtVcnw95JUb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZrcKIIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZrcKIIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DACC4CEEB;
	Tue, 22 Jul 2025 13:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192077;
	bh=mDoF7L2y3Ypw62wFfRs8vvPc6TeRqijWahwDXlGk6Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZrcKIIr++dGMvkKYUGOLH4WxFjdViv5AaPfKEKZjlwllZkoM8G7/bbX9QIYKMG1u
	 0W7bRmHsZKKu/rNRmBnPIfPDzMDKdEyMBDyXl5q0hX8xoLjmeqQ7GmoerdLPyFiAAS
	 ZJ5o8rkGtJ4qZwZ+B3ILC/oE1GZsedcWspsMC+S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.1 37/79] comedi: das6402: Fix bit shift out of bounds
Date: Tue, 22 Jul 2025 15:44:33 +0200
Message-ID: <20250722134329.733028047@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


