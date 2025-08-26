Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091EC2F84F;
	Tue, 26 Aug 2025 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215517; cv=none; b=EJQvb7nttoF0+Ixx7rv1tJj8TkbYAqj4DZSIMGJbJcHPrcFcIucZHA0NSlAe/Jva92IBk5XomVHx33d2Bp5NaE/c+/sdLWrGRvlRs11zQhx0rB/KbXYP4cqp5dXGG9JJHwqk2UpxWjhDNC7JcC6sLK4IX+gyNI8eeyqeK6MTrbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215517; c=relaxed/simple;
	bh=g+9XDGDbp2C8LlnhXRbdb2HOxzbk9oOb1nndXdZc+cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu5TcC5vPahhsyP+J6C0YRdaPJQeRji9rAG8loUTsR6X2GE2J1t6LvsgBH3NXQ32ehjXCYteObOpx3cNn8vNrUgqFR+Ft316GZRMftuAsFb9YOQrBAZ7Kfl7qsl/3gqKOcoi9n8ykbkWhYDuSLbKYSf/RNVSmrgQ/OsI1Rixx18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDmTpB/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDmTpB/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9011AC4CEF1;
	Tue, 26 Aug 2025 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215516;
	bh=g+9XDGDbp2C8LlnhXRbdb2HOxzbk9oOb1nndXdZc+cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDmTpB/KlL+WDw3M60HkF84T4g3z1gPEckCB26TR35XVSrD/HpRE/KbohGg6YCDeV
	 Nc4fc/ZPKN4W1qTV8za1wb57bYKES5VmcKUM43ba71k5/GiCm6KsMfr/94seDPafv3
	 dPHDqSZH/HkRcm0xOKzS2lPc9bncF2AXmQ9rFCzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 032/644] comedi: das6402: Fix bit shift out of bounds
Date: Tue, 26 Aug 2025 13:02:03 +0200
Message-ID: <20250826110947.307113045@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -569,7 +569,8 @@ static int das6402_attach(struct comedi_
 	das6402_reset(dev);
 
 	/* IRQs 2,3,5,6,7, 10,11,15 are valid for "enhanced" mode */
-	if ((1 << it->options[1]) & 0x8cec) {
+	if (it->options[1] > 0 && it->options[1] < 16 &&
+	    (1 << it->options[1]) & 0x8cec) {
 		ret = request_irq(it->options[1], das6402_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {


