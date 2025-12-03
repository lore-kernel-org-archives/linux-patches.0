Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EFB34A3AB;
	Wed,  3 Dec 2025 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777660; cv=none; b=FDX0RLkX0TH4CUBKfYGiMW5IUxgvP82QnmjqXo2puD9VV44ZDsvFT7kDjvDX3Q/AA6+QF0WpZc51P9o82x3sOIL9vnsNIMcCVMnTixicludE+sj8iVyCm4d1YjgM8TDwp0jysMrSpFfA54z0CCen5NYrbG/DwQA4Yef6B+9NEDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777660; c=relaxed/simple;
	bh=D3/4w6brNs5bizkoOMiAZue+HBrWZ7/BVcHfbuuQLDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th9moj4Ga3gPqq3G/GfOW7B124M9GXmTOGv1LWS2zwkJ1KlW3mDjf4liGQXhGaW/JNSonOyjGE5nArziuPXxLdH/TXkg6NpbSEi9GQtFc7gVvYCARQ5Zw5CzKnCfGQOIF3Vd28yx5D9gcz6HG2M22ej/5EWdkc1zAAUEU1A6MwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGPCA8HU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGPCA8HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25E8C116B1;
	Wed,  3 Dec 2025 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777660;
	bh=D3/4w6brNs5bizkoOMiAZue+HBrWZ7/BVcHfbuuQLDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGPCA8HUhlvA4LLly1awGC/m/qbnCii5B+EZelIxot4qc4WT78J/5pn7AvMLHfTYr
	 qD4CIawEPRnP4ebKidlQ+8xfdYkuMl86rcA9x8zKr5PXp2dm1AMtyhhS9IPFFus2tz
	 7X0bhGsoi8ZJca7+2/v0CXA/qv8CykyYKJpUlcSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/392] media: imon: make send_packet() more robust
Date: Wed,  3 Dec 2025 16:24:17 +0100
Message-ID: <20251203152418.036552063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit eecd203ada43a4693ce6fdd3a58ae10c7819252c ]

syzbot is reporting that imon has three problems which result in
hung tasks due to forever holding device lock [1].

First problem is that when usb_rx_callback_intf0() once got -EPROTO error
after ictx->dev_present_intf0 became true, usb_rx_callback_intf0()
resubmits urb after printk(), and resubmitted urb causes
usb_rx_callback_intf0() to again get -EPROTO error. This results in
printk() flooding (RCU stalls).

Alan Stern commented [2] that

  In theory it's okay to resubmit _if_ the driver has a robust
  error-recovery scheme (such as giving up after some fixed limit on the
  number of errors or after some fixed time has elapsed, perhaps with a
  time delay to prevent a flood of errors).  Most drivers don't bother to
  do this; they simply give up right away.  This makes them more
  vulnerable to short-term noise interference during USB transfers, but in
  reality such interference is quite rare.  There's nothing really wrong
  with giving up right away.

but imon has a poor error-recovery scheme which just retries forever;
this behavior should be fixed.

Since I'm not sure whether it is safe for imon users to give up upon any
error code, this patch takes care of only union of error codes chosen from
modules in drivers/media/rc/ directory which handle -EPROTO error (i.e.
ir_toy, mceusb and igorplugusb).

Second problem is that when usb_rx_callback_intf0() once got -EPROTO error
before ictx->dev_present_intf0 becomes true, usb_rx_callback_intf0() always
resubmits urb due to commit 8791d63af0cf ("[media] imon: don't wedge
hardware after early callbacks"). Move the ictx->dev_present_intf0 test
introduced by commit 6f6b90c9231a ("[media] imon: don't parse scancodes
until intf configured") to immediately before imon_incoming_packet(), or
the first problem explained above happens without printk() flooding (i.e.
hung task).

Third problem is that when usb_rx_callback_intf0() is not called for some
reason (e.g. flaky hardware; the reproducer for this problem sometimes
prevents usb_rx_callback_intf0() from being called),
wait_for_completion_interruptible() in send_packet() never returns (i.e.
hung task). As a workaround for such situation, change send_packet() to
wait for completion with timeout of 10 seconds.

Link: https://syzkaller.appspot.com/bug?extid=592e2ab8775dbe0bf09a [1]
Link: https://lkml.kernel.org/r/d6da6709-d799-4be3-a695-850bddd6eb24@rowland.harvard.edu [2]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 61 +++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 0257a4f293ecc..a70f449f35290 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -650,12 +650,15 @@ static int send_packet(struct imon_context *ictx)
 		smp_rmb(); /* ensure later readers know we're not busy */
 		pr_err_ratelimited("error submitting urb(%d)\n", retval);
 	} else {
-		/* Wait for transmission to complete (or abort) */
-		retval = wait_for_completion_interruptible(
-				&ictx->tx.finished);
-		if (retval) {
+		/* Wait for transmission to complete (or abort or timeout) */
+		retval = wait_for_completion_interruptible_timeout(&ictx->tx.finished, 10 * HZ);
+		if (retval <= 0) {
 			usb_kill_urb(ictx->tx_urb);
 			pr_err_ratelimited("task interrupted\n");
+			if (retval < 0)
+				ictx->tx.status = retval;
+			else
+				ictx->tx.status = -ETIMEDOUT;
 		}
 
 		ictx->tx.busy = false;
@@ -1756,14 +1759,6 @@ static void usb_rx_callback_intf0(struct urb *urb)
 	if (!ictx)
 		return;
 
-	/*
-	 * if we get a callback before we're done configuring the hardware, we
-	 * can't yet process the data, as there's nowhere to send it, but we
-	 * still need to submit a new rx URB to avoid wedging the hardware
-	 */
-	if (!ictx->dev_present_intf0)
-		goto out;
-
 	switch (urb->status) {
 	case -ENOENT:		/* usbcore unlink successful! */
 		return;
@@ -1772,16 +1767,29 @@ static void usb_rx_callback_intf0(struct urb *urb)
 		break;
 
 	case 0:
-		imon_incoming_packet(ictx, urb, intfnum);
+		/*
+		 * if we get a callback before we're done configuring the hardware, we
+		 * can't yet process the data, as there's nowhere to send it, but we
+		 * still need to submit a new rx URB to avoid wedging the hardware
+		 */
+		if (ictx->dev_present_intf0)
+			imon_incoming_packet(ictx, urb, intfnum);
 		break;
 
+	case -ECONNRESET:
+	case -EILSEQ:
+	case -EPROTO:
+	case -EPIPE:
+		dev_warn(ictx->dev, "imon %s: status(%d)\n",
+			 __func__, urb->status);
+		return;
+
 	default:
 		dev_warn(ictx->dev, "imon %s: status(%d): ignored\n",
 			 __func__, urb->status);
 		break;
 	}
 
-out:
 	usb_submit_urb(ictx->rx_urb_intf0, GFP_ATOMIC);
 }
 
@@ -1797,14 +1805,6 @@ static void usb_rx_callback_intf1(struct urb *urb)
 	if (!ictx)
 		return;
 
-	/*
-	 * if we get a callback before we're done configuring the hardware, we
-	 * can't yet process the data, as there's nowhere to send it, but we
-	 * still need to submit a new rx URB to avoid wedging the hardware
-	 */
-	if (!ictx->dev_present_intf1)
-		goto out;
-
 	switch (urb->status) {
 	case -ENOENT:		/* usbcore unlink successful! */
 		return;
@@ -1813,16 +1813,29 @@ static void usb_rx_callback_intf1(struct urb *urb)
 		break;
 
 	case 0:
-		imon_incoming_packet(ictx, urb, intfnum);
+		/*
+		 * if we get a callback before we're done configuring the hardware, we
+		 * can't yet process the data, as there's nowhere to send it, but we
+		 * still need to submit a new rx URB to avoid wedging the hardware
+		 */
+		if (ictx->dev_present_intf1)
+			imon_incoming_packet(ictx, urb, intfnum);
 		break;
 
+	case -ECONNRESET:
+	case -EILSEQ:
+	case -EPROTO:
+	case -EPIPE:
+		dev_warn(ictx->dev, "imon %s: status(%d)\n",
+			 __func__, urb->status);
+		return;
+
 	default:
 		dev_warn(ictx->dev, "imon %s: status(%d): ignored\n",
 			 __func__, urb->status);
 		break;
 	}
 
-out:
 	usb_submit_urb(ictx->rx_urb_intf1, GFP_ATOMIC);
 }
 
-- 
2.51.0



