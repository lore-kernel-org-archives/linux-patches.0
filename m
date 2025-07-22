Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8892E4271;
	Tue, 22 Jul 2025 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192397; cv=none; b=Nj5pmGnYFdjI5GmWAM5UWrY8znA4KJcroFSWlebP6lvWP2IoEgl3q6pP0vvR3rnhWRe/+JFxNzgMjynj7899uIaAAB4g00Zekp8AWpLVHfywhKm0kzSJhx/4+ryTa2TpL/hWhdeSM4YlTnlAyEJZZRt2xvKkZ6CaX8OVcy1iga0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192397; c=relaxed/simple;
	bh=6xjlvjWidahJB7eHf+Ae9nvh1Knory30d1lHQ5qYM4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYTSR70UTDyIe6ylp1maoQJ7qdeWttCcRQTgw1EW+uurXdmBcdTbTjLFdrdoXK8ZUGswrMJwp17FYcxfbHsX1l8Yd3M1BTZy7BvBoOe86W2nHDBPmsRxIny4t8b9bMguxoRB3iJCUOLSRnlG/RIILQCPsz5K0q5rep6xQW2IAGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw/4gB1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw/4gB1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BE7C4CEEB;
	Tue, 22 Jul 2025 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192397;
	bh=6xjlvjWidahJB7eHf+Ae9nvh1Knory30d1lHQ5qYM4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw/4gB1RaK3vW4OSN8dt3bhdIFBkt0D/OLsQvoc8LAd8CsxXy50d2nkOOnn22mLUT
	 TL6+XYnc0B/fHIWlNb4slQLvfovw6oYsJarBSQhOIJRvZ8nL3GKAar3P/0p7iB1WeA
	 W37PVOxC0NxwePJdoDVoL4XnV3E8VBmUbzMirnFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c52293513298e0fd9a94@syzkaller.appspotmail.com,
	"Enju, Kohei" <enjuk@amazon.co.jp>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.6 053/111] comedi: das16m1: Fix bit shift out of bounds
Date: Tue, 22 Jul 2025 15:44:28 +0200
Message-ID: <20250722134335.360622235@linuxfoundation.org>
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
 drivers/comedi/drivers/das16m1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/comedi/drivers/das16m1.c
+++ b/drivers/comedi/drivers/das16m1.c
@@ -522,7 +522,8 @@ static int das16m1_attach(struct comedi_
 	devpriv->extra_iobase = dev->iobase + DAS16M1_8255_IOBASE;
 
 	/* only irqs 2, 3, 4, 5, 6, 7, 10, 11, 12, 14, and 15 are valid */
-	if ((1 << it->options[1]) & 0xdcfc) {
+	if (it->options[1] >= 2 && it->options[1] <= 15 &&
+	    (1 << it->options[1]) & 0xdcfc) {
 		ret = request_irq(it->options[1], das16m1_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)


