Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0061B87E8;
	Tue, 26 Aug 2025 13:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215509; cv=none; b=bwEJo0QV9wEPHwUItiMlUJtI16c1cFdbETJ/rpAm+XVhXYwyMksdxubTqza22r4sV1xWLQf2hkqQ6uwizPoN+rRHzvZkFg/ylWcdNW8EDOImiGz7BRM4SOCKO6yI8OmdFAEQSKq7WOAJ+CRZ3tm3+P7puR8XquP8Uwd/0n8H0Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215509; c=relaxed/simple;
	bh=IYDUuIdJGyil3cXSrdXfypmbJFr9RO4kKd2uWDUW5RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8016nBbEliYApESnf2iNWg6FLlVx6El8hK6cu5Gp6VGy8sQ9ddsJrqGh0CcnRxw4/IyJMrgZzp7u3gOJEoxJNWJTw+1Rd9+l24NcmFyz3U04xkObCBFQxkHaSd6FLFMbGnip0chyGSgNlnJNzpwq5or1o9ZB6v86Gv/KlKjr9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkV2tU/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkV2tU/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11585C4CEF1;
	Tue, 26 Aug 2025 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215509;
	bh=IYDUuIdJGyil3cXSrdXfypmbJFr9RO4kKd2uWDUW5RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkV2tU/FwqgtfamXFJFYO2BYHbf5cCqBwawP4oqrLJ5qjzxBf3Vg8j7sV+xiNvo8E
	 wrPj1HiqNskwv52BBwowyf3RVErh0kTlg8V/N8y5Mf7iWfKjKQz/MihbswO06YGij6
	 IP8kO5zZmANeDLyF4J3HKCSh9Ux6gZGYsBXDwFtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32de323b0addb9e114ff@syzkaller.appspotmail.com,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 029/644] comedi: pcl812: Fix bit shift out of bounds
Date: Tue, 26 Aug 2025 13:02:00 +0200
Message-ID: <20250826110947.228966843@linuxfoundation.org>
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
@@ -1151,7 +1151,8 @@ static int pcl812_attach(struct comedi_d
 		if (!dev->pacer)
 			return -ENOMEM;
 
-		if ((1 << it->options[1]) & board->irq_bits) {
+		if (it->options[1] > 0 && it->options[1] < 16 &&
+		    (1 << it->options[1]) & board->irq_bits) {
 			ret = request_irq(it->options[1], pcl812_interrupt, 0,
 					  dev->board_name, dev);
 			if (ret == 0)


