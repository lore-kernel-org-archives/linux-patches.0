Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7812ED17E;
	Tue, 22 Jul 2025 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193424; cv=none; b=IeneLhYXLYqSsst+aETU0r5AD7AUtLSOnsaYmhjAJBXS0RwPVTekICqWiadRsNugQ7SD1WGiS5aUjs7WRQsnNFMnSuhkwdcVfJaRIEieo63LYPM2Pe++S/ziyZXACFTay3ufc2M0MVM5quQm2SbSBAw3rbImSCwny0UU+A86sEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193424; c=relaxed/simple;
	bh=J/djvQaR8W65dsThNV69F6NcJfO+WrxR14IFkMS2zbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0iLuURLlAdDOLqstCSjfpDf2MWUg9y5+0FqGzVUibi9FUy/6acNyKRF49MJXcOQ9gNgv0jZ3QPY6rHHMTfqZJi5xBWUR02wsE2c3MGK9zZ/nlVmZ+G2z3j5d+4i7F3hqTeC1r4/Eo8fU613Nx3KEv0Qz31B35DiHcu8gp+GMhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ib8LhKO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ib8LhKO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23287C4CEEB;
	Tue, 22 Jul 2025 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193424;
	bh=J/djvQaR8W65dsThNV69F6NcJfO+WrxR14IFkMS2zbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ib8LhKO1J9gjTaQRbYqtPMOBvS7oy4zq6f1OoleHsveBcCIqtfbkoxQpp2Tc6Y4C+
	 +XFIIrCxI2CUdxOWDEMgMExH2ZWmIIKkQ1NgDM3pYXJIJPNDXPxxCU5flhS2YfeWQO
	 rEaBecUwD8HBE3Wq1rayqTdx25PL/9bekuhqJH0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32de323b0addb9e114ff@syzkaller.appspotmail.com,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.15 088/187] comedi: pcl812: Fix bit shift out of bounds
Date: Tue, 22 Jul 2025 15:44:18 +0200
Message-ID: <20250722134349.004854144@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


