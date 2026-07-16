Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B6A42FCD2;
	Thu, 16 Jul 2026 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212461; cv=none; b=DrGXSnYtRVi2MT+iqQx6QF57VHYFtXf18Qu/9gMBxHO6jysMR7Gptvmxu8eGLsDmQ72u5P4LqUVNx++Jc8JpPpGURThbJBE78lT75QVrADyKZw6IzfDjQLFZ+dGXoy/yLrHY2GQbzpM6FzO7+IG7WbJ2SgqjizVGy3vvBq5OBGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212461; c=relaxed/simple;
	bh=6otqPC0SWzf5rPMG4tdF0qS3ZUhg6zzJ+m8Ab+fheHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEsYPLIwe3vVvXg0S6HXE7VyiXsn1lqoxzxDcGVHaCRQhbBiB2ooRp3bqZNpabp3I5SN7Cp5PfSy/dtoI9TI6eYFsvU2FL3a2ZsAldXgIPO9+LSEvHliK3ETyta8dMFNDrWgbAZrVHs6M+yPpfkqTsc5leVu9R52E2+v0GFOkGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSNYJHog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSNYJHog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13201F000E9;
	Thu, 16 Jul 2026 14:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212460;
	bh=kjYepyMxHejmPy5pHuazfqPe9OuvK9vZVY4E8AcT4O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSNYJHogt3kPfBlhyNnXjn+d8dDt75OL6QhzXKFWQh3kwaavXLeAoylrWyTzDcADl
	 /6rPCrqLedHVTIQYBgFh8q8iKhSERYH0pU8sB//tOUhS0MSObU77NACUSv2Df37NXM
	 cb6LLuzg8WDg5iC576sZ1xhkTqtO22uUgaY1/d9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 337/349] Input: touchwin - reset the packet index on every complete packet
Date: Thu, 16 Jul 2026 15:34:31 +0200
Message-ID: <20260716133040.851608937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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


