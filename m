Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712883B8120;
	Tue, 21 Jul 2026 21:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668654; cv=none; b=Q9Bc9dQBMaTAMSKDCeIJKENfExM/enCFGwCUrt8Q/2MLwmTu39aRz/5c0PktBxCNSQcfjfzWKME4uHfvuf20i5clVWWezfQq6WtmMpnrmMbBq2WzGDWxfqV+pDMIlF/xWgaVjXQZT7tQo4JVkqvd6B4v4e2L6Piv09Xlkis4uRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668654; c=relaxed/simple;
	bh=FYexQfBwS9+kLaVipdiSEzv8VRiYox7RzdNr/9EppLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYHPOwNtS4fCgksSgyJ3Yn1G9jIXpJFYrXJUwHDL8onSWZDqS3E7bat6nud5Sh/fxnlqYPCJlX0gSZCfg5xs7rJ45Yt+66GGgIHukMO/P7tApqbXtn23dLjUcp8jRI9ajxSIip6IkAcN5zGEQoNmd1cZvCC7uaLlIHoMmWpJeZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsyprcvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsyprcvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E0E1F000E9;
	Tue, 21 Jul 2026 21:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668652;
	bh=/xk68a8OKpJUSWFsozDD6UdapRnzl4zKZmK9ap2v+6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsyprcvAnwiD9uuWdvq81Hlrlo/u+H2GodLs2dbrFBt7rZV+OIp5xQcxqrHbGSYrD
	 LmT+S0rqIvd+EZGuY/El+Vb0guVaWRUAwW9EqPy1aLj46IXmhcEXOii6oY/nA1WiSv
	 rFOhL6Pj2iYeE2FQIT+JWDuoBNW9eyo4FJ729fww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0240/1067] Input: touchwin - reset the packet index on every complete packet
Date: Tue, 21 Jul 2026 17:14:01 +0200
Message-ID: <20260721152429.970152194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


