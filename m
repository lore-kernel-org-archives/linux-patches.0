Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE3641735B;
	Tue, 21 Jul 2026 20:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665271; cv=none; b=rE6ZrS4htNmGR18+yUnOZ1ulqpskL99DiB5T7aqNRyLS4kHwWEC2o8IrFKLi5eRWvAB7Z6QjmtRn32lzrgHJcn6yNQZ++YJY39nW+XwUj5/YBShip92vk2x/uMAnbqatRuPaOF7pjs1/Z4twfLqqX+vy7ElBegGhJ7zn3drIf4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665271; c=relaxed/simple;
	bh=bUDEO2nlxZHFc1Q3w1dSX+Ig5K7QK+zI+Y9XMRjme2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORWScASO1YDIHL48Wuzydos2SwblbWVedJZjNtd0BLiLA6X0nhctch0lxAk4+2LBypBOLBcxljrs5TKDudVfI0j5UU8SNqQ/cYat4TNqWxZorGV9chOy/mksG4exKaePop7SC4/e3xKs2lPrlWgwAVFGdh4xSH3HmA/UNx4D6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXTRtZik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXTRtZik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD301F00A3A;
	Tue, 21 Jul 2026 20:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665270;
	bh=FPDvEB0WeLjFatk0Ap39ZfGbdS2SOYT830/iFDBKmWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXTRtZikC+Qo0NsbiG9WJXjhKzNuoB2Fm3wYnkVt4LgZp/1KWl0RNAgihuGPr7elw
	 HCqGHZ9ehD2mKTmd53bKr4bpobfbelIaDfrRV7KJgSvuqMiRqxkuy6U0gU4M87QfGN
	 Ju4ZXeXgB7spAerIX+mlhYLAKLBSYDzwk9kw91n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0242/1266] USB: serial: keyspan_pda: fix information leak
Date: Tue, 21 Jul 2026 17:11:19 +0200
Message-ID: <20260721152447.232693616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6bfc8d01ac4068eced509f8fc74d0cd205e4dcec upstream.

The write() callback is supposed to return the number of characters
accepted or a negative errno. Since the addition of write fifo support
the keyspan_pda implementation will however return the number characters
submitted to the device if the write urb is not already in use. If this
number is larger than the number of characters passed to write(), the
line discipline continues writing data from beyond the tty write buffer.

Fix the information leak by making sure that keyspan_pda_write_start()
returns zero on success as intended.

Fixes: 034e38e8f687 ("USB: serial: keyspan_pda: add write-fifo support")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -518,7 +518,7 @@ static int keyspan_pda_write_start(struc
 	if (count == room)
 		schedule_work(&priv->unthrottle_work);
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_write_bulk_callback(struct urb *urb)


