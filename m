Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1248C44AB9F;
	Tue, 21 Jul 2026 22:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673403; cv=none; b=aFjbLRNV5L21Qu9VEuwJZa/RbmGpSts4deIT66cxSpyGIg6V6K0EeQNMqdW+ulyAlyz7Yi+sU81KqjAZXy5n+N7NDqEATbInNt+YijYsxhBNSCMb0eLCdNRdeVwrTe4UgGC2B4L2F9gLWbBb8KXBnzqZ5jFCP5u1pjviwfwKuiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673403; c=relaxed/simple;
	bh=7+oNEcwXgmCWuMFGgxzv8er82nXoMb8U482vyKWbj50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDaz4lXH1slF/G3juJ3B6BAZ1kEP30wYpuwSnxySJ54V1sk1JoOSoRikBgSDa39+p0ysK9Ru/llE9+3R2WmldY9+4XcAg9F/eJCq8nAlykYP34q6S3+ZqhBJXlAdNoBlDJp11OF/TKrXT9RcOY9ulCEcVIJnA+CG123ldu5dFeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kg+9P7LG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kg+9P7LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F1E1F000E9;
	Tue, 21 Jul 2026 22:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673402;
	bh=l8Wlb3cYitpE+Ru30AN1eUFftfbI5HSBvZZH92h1Taw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kg+9P7LG2YuvXgx4tnEBxRF825M7P+pcKgsGrptIL6xCg+UEqp60paTbd4Ev3G1VV
	 xXJ71m+J1Pm9RXrlXAGLXkGIgSTgSYRTArSP+nbwVQmRFYtciJUJgJplKkJt+ycjWB
	 LTqJAJaKhYjcAgDmpYxhIfmXG+33AReNsHngMMBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 149/699] Input: touchwin - reset the packet index on every complete packet
Date: Tue, 21 Jul 2026 17:18:28 +0200
Message-ID: <20260721152359.067525272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 478cdd736f2ce3114f90e775d7358136d3977b94 upstream.

tw_interrupt() accumulates each non-zero serial byte into a fixed
three-byte buffer with a running index that is only reset once a full
packet has been received *and* the device's two Y bytes agree:

	tw->data[tw->idx++] = data;
	if (tw->idx == TW_LENGTH && tw->data[1] == tw->data[2]) {
		...
		tw->idx = 0;
	}

The reset is gated on tw->data[1] == tw->data[2], a value the device
controls.  A malicious, malfunctioning or counterfeit Touchwindow
peripheral can stream non-zero bytes whose 2nd and 3rd bytes differ: the
index reaches TW_LENGTH without the equality holding, is never reset, and
keeps growing, so tw->data[tw->idx++] walks off the end of the three-byte
array and the rest of the heap-allocated struct tw, one attacker-chosen
byte at a time -- an unbounded, device-driven heap out-of-bounds write.

Reset the index on every completed packet and report an event only when
the two Y bytes match, like the other serio touchscreen drivers do.

Fixes: 11ea3173d5f2 ("Input: add driver for Touchwin serial touchscreens")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260613-b4-disp-69921bfd-v1-1-82c036899959@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/touchwin.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/input/touchscreen/touchwin.c
+++ b/drivers/input/touchscreen/touchwin.c
@@ -63,12 +63,15 @@ static irqreturn_t tw_interrupt(struct s
 	if (data) {		/* touch */
 		tw->touched = 1;
 		tw->data[tw->idx++] = data;
-		/* verify length and that the two Y's are the same */
-		if (tw->idx == TW_LENGTH && tw->data[1] == tw->data[2]) {
-			input_report_abs(dev, ABS_X, tw->data[0]);
-			input_report_abs(dev, ABS_Y, tw->data[1]);
-			input_report_key(dev, BTN_TOUCH, 1);
-			input_sync(dev);
+		/* a full packet ends the accumulation, valid or not */
+		if (tw->idx == TW_LENGTH) {
+			/* report only if the two Y's are the same */
+			if (tw->data[1] == tw->data[2]) {
+				input_report_abs(dev, ABS_X, tw->data[0]);
+				input_report_abs(dev, ABS_Y, tw->data[1]);
+				input_report_key(dev, BTN_TOUCH, 1);
+				input_sync(dev);
+			}
 			tw->idx = 0;
 		}
 	} else if (tw->touched) {	/* untouch */


