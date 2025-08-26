Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E169352094;
	Tue, 26 Aug 2025 14:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218507; cv=none; b=FUfft1W2VgCiCjUYEvesvJNwIxB6wBe0tB9nmviUXAeodZkTGXQ0pdhwVO3zph99oCt5pgod3MSVFqUpdelYKq+kwXZLiMgGG5im9CaFuk+zWTSt23f5YJlKlUZ4QG5KsjK1MElwz6m1fp3DJseFjNckW/wAnxqLO5fMxzymmXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218507; c=relaxed/simple;
	bh=rXyzydIKHQ42ChXPlQ0wH3aeKzftd/L6F4Pp+8m/ECg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPn+KWZ58OwhP8GFcRxfvhAAc25bxP3pYD5Rfu9qXxINaw31id9Gk5x0URH0TvSf/g3+QXlwFjoCsYMhZJiQ4b7xmiszIVshU9jQMaeS/e24otKLc9HLS538wPZhwgaSewRlJ9+gICxpMSIGc7sHaRBHBzyX7gxe7wRIBxymVtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zs/cBqsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zs/cBqsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3ACDC4CEF1;
	Tue, 26 Aug 2025 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218507;
	bh=rXyzydIKHQ42ChXPlQ0wH3aeKzftd/L6F4Pp+8m/ECg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs/cBqsGU2kVwElRkA7EmgcCnY/AobX2WnHkFx3mYuyYjrq7ozN+fIsXj5N1YMQrm
	 7mboS0FFVu7nwLITKE+DRbPi7t0boibAs14J8CtMh2lHY2EuEwqPv/RPVn2xFOJB+0
	 ADAziKetgSjW7mNLDNVdPQlqjTnUGS7qQuWi8zAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c52293513298e0fd9a94@syzkaller.appspotmail.com,
	"Enju, Kohei" <enjuk@amazon.co.jp>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 027/403] comedi: das16m1: Fix bit shift out of bounds
Date: Tue, 26 Aug 2025 13:05:53 +0200
Message-ID: <20250826110906.546034822@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit ed93c6f68a3be06e4e0c331c6e751f462dee3932 upstream.

When checking for a supported IRQ number, the following test is used:

	/* only irqs 2, 3, 4, 5, 6, 7, 10, 11, 12, 14, and 15 are valid */
	if ((1 << it->options[1]) & 0xdcfc) {

However, `it->options[i]` is an unchecked `int` value from userspace, so
the shift amount could be negative or out of bounds.  Fix the test by
requiring `it->options[1]` to be within bounds before proceeding with
the original test.

Reported-by: syzbot+c52293513298e0fd9a94@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c52293513298e0fd9a94
Fixes: 729988507680 ("staging: comedi: das16m1: tidy up the irq support in das16m1_attach()")
Tested-by: syzbot+c52293513298e0fd9a94@syzkaller.appspotmail.com
Suggested-by: "Enju, Kohei" <enjuk@amazon.co.jp>
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707130908.70758-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das16m1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -523,7 +523,8 @@ static int das16m1_attach(struct comedi_
 	devpriv->extra_iobase = dev->iobase + DAS16M1_8255_IOBASE;
 
 	/* only irqs 2, 3, 4, 5, 6, 7, 10, 11, 12, 14, and 15 are valid */
-	if ((1 << it->options[1]) & 0xdcfc) {
+	if (it->options[1] >= 2 && it->options[1] <= 15 &&
+	    (1 << it->options[1]) & 0xdcfc) {
 		ret = request_irq(it->options[1], das16m1_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)


