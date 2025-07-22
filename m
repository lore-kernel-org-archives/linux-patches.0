Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A52E1724;
	Tue, 22 Jul 2025 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192842; cv=none; b=ABdCg3suCtEJkbRooCj7sLHYEMYyDTpcGgKRbGsGdbAttDF3gp1C3jtzFbKKgp5cJf66pjrhgFFqG++4lPh4xXrKcrh3tmrCJJvK2BLxHB+0/zud5T8qtcj9s+vRkKcfiBNAzPFPEX0ccDaY5SIrD0Fqcqx7AQAusQv6V0PjgMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192842; c=relaxed/simple;
	bh=tF6ammELxN6GS7q1tp89O++eF78UQJoNCD1jvps2aeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnEgmLW4LDtbDqbHeSFwuvYYca4WeagDjK5JDKdcbLh6sF3ZDepaQhs41CE3wN9Git5zXRCqfVw7Sm9dVIOLPrUWMl2ml5GfKWxkpzWBzhZTxqv9gGae2xSmcw1C/Lxfb4rt0/KKZ8CVWCyrrO9ySqG8ND0QUH+gHBCJ2vbqcus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSm4qDbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSm4qDbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ACDC4CEEB;
	Tue, 22 Jul 2025 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192842;
	bh=tF6ammELxN6GS7q1tp89O++eF78UQJoNCD1jvps2aeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSm4qDbg3wKUvNbG88/BpG/ydMBwOcrwyDeQtuGC/4Jj2bjyfPMe6vyCmaXeiDNdJ
	 j2VCWYnXDr09pkW2Kcw//fLxGRDS0rGfmfoAY2WxFgC5KgAlDy97g+YoVmq2kOrv/O
	 XD7N1RaTh95A5zWWa49mebqfBsMI7FeYxOo6HWV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32de323b0addb9e114ff@syzkaller.appspotmail.com,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 074/158] comedi: pcl812: Fix bit shift out of bounds
Date: Tue, 22 Jul 2025 15:44:18 +0200
Message-ID: <20250722134343.533927243@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit b14b076ce593f72585412fc7fd3747e03a5e3632 upstream.

When checking for a supported IRQ number, the following test is used:

	if ((1 << it->options[1]) & board->irq_bits) {

However, `it->options[i]` is an unchecked `int` value from userspace, so
the shift amount could be negative or out of bounds.  Fix the test by
requiring `it->options[1]` to be within bounds before proceeding with
the original test.  Valid `it->options[1]` values that select the IRQ
will be in the range [1,15]. The value 0 explicitly disables the use of
interrupts.

Reported-by: syzbot+32de323b0addb9e114ff@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=32de323b0addb9e114ff
Fixes: fcdb427bc7cf ("Staging: comedi: add pcl821 driver")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707133429.73202-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/pcl812.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/comedi/drivers/pcl812.c
+++ b/drivers/comedi/drivers/pcl812.c
@@ -1149,7 +1149,8 @@ static int pcl812_attach(struct comedi_d
 		if (IS_ERR(dev->pacer))
 			return PTR_ERR(dev->pacer);
 
-		if ((1 << it->options[1]) & board->irq_bits) {
+		if (it->options[1] > 0 && it->options[1] < 16 &&
+		    (1 << it->options[1]) & board->irq_bits) {
 			ret = request_irq(it->options[1], pcl812_interrupt, 0,
 					  dev->board_name, dev);
 			if (ret == 0)


