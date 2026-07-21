Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1E42CAF1;
	Tue, 21 Jul 2026 19:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663990; cv=none; b=RBL7ulxvxySSVMLjB6zg+MJ1s9CAjwZMZUhz+13g63Y5CdORq/BnHIoawJBt/yKKuqwOi9aftBfS7YM1cz+7yPjCI7+s4s3EO71VjIjnxFY0HpebsqftC+bEvLDny21pME00eD3v7M74au40VYAWnntrMh1UlrXM7mI4TRnOM1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663990; c=relaxed/simple;
	bh=0GBV6Iljzf7C42CDeWbMVKKWTKd0iKLXNZYzQqIafFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEHK8OEsswuTFLGoQOPxWYhebgL8Do4VarWP7vyD99XVegyvnhrMIFpSY9r/c9XAvP6umlvW4vBcc4uoUz+wDQj7y71Nuk8IjPHccbhlwpJzmXkAf+th272xs+CwobuyxHmJyzq3nP3x2kTSJI3AA7zJh/dWIfy8b3AgtWX8aV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFyOYYiX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFyOYYiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DA51F00A3A;
	Tue, 21 Jul 2026 19:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663988;
	bh=s2YMgHTEJINPwNdawTLRz8tse4CquyIORdebNcpV2eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFyOYYiXPNG1uLApWBPQWXawQLnvlt3jr25+ZWEpkhn+1BDuGnF6mb5vXc8+H9lrl
	 lsxBHBiC2dd2f9KflQ0ZFJQF3c7tSN+w+hRtGulEiw9Os/oDnOyWVmwN2ZSk0myFWu
	 yqDAyuovRW2W/Q577bI+bIcxjs+RCozaxkFYlvY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1032/1276] Input: ims-pcu - fix out-of-bounds read in ims_pcu_irq() debug logging
Date: Tue, 21 Jul 2026 17:24:35 +0200
Message-ID: <20260721152509.086692506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 403b0a6970b1084bb27907c0f8225801fdd0fe1d upstream.

The debug logging in ims_pcu_irq() unconditionally prints data from
pcu->urb_in_buf. However, if the interrupt fired for pcu->urb_ctrl, the
actual data resides in pcu->urb_ctrl_buf. If urb->actual_length for the
control URB exceeds pcu->max_in_size, this leads to an out-of-bounds
read.

Fix this by printing from the correct buffer associated with the URB.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1559,7 +1559,7 @@ static void ims_pcu_irq(struct urb *urb)
 	}
 
 	dev_dbg(pcu->dev, "%s: received %d: %*ph\n", __func__,
-		urb->actual_length, urb->actual_length, pcu->urb_in_buf);
+		urb->actual_length, urb->actual_length, urb->transfer_buffer);
 
 	if (urb == pcu->urb_in)
 		ims_pcu_process_data(pcu, urb);


