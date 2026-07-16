Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC62F31E85C;
	Thu, 16 Jul 2026 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210231; cv=none; b=mLTTjK/D51aN6tlHHKsCB/4cNq5F7z0oVNE0dInV0D6ljReUbXpcJ0NHmyk3mkdghqcHleUbtaEFHjrfrkM1XYyzPVbbXdseFrrrRkWTNe0pqaPN4ntMbhH7NEJnkWCZy1+RRYVXRcKEIy5CLUc6Me8VTKz8c/x1RxEnSFK0RS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210231; c=relaxed/simple;
	bh=WxbIZErdTzBGME6A5srjmmWoKknvb49UqK6gBh9ZZl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/3qsBfrHMoqnTdLr+tsMQBw5bwHw3/luzd2r4JKpmAqvlYRrHSICntvpTTUv06qmLdkmmGfOwhXVvrbV/97CJfF7F5EK1p8iGASriL7fADit9gHiGBZGLV0IgtAYaXt8BJ3UIJKiO7TwqIPsRPBwZ1gKA20f/GkvuZvCh4VoHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mjv3sazv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mjv3sazv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0C21F000E9;
	Thu, 16 Jul 2026 13:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210229;
	bh=B8KTr36x+R6uEQ4BLLrAEeKHhjvJxBmxQSkBwqTxThw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mjv3sazvjDIDMycRCaQYUlAmm004Fz0e0jAV7b/KvGyokXFKxq1U489t3/r/pleIW
	 AOvBEwAAgAZ8rTb0Wc+Ozr11mc2Txn4vY+M0WezsuGGobzF/Pvz+eutFhTFwFY43pp
	 +DR2Oy8FUKOs6xnTLEEKd8jT4uUQvW6vuF57YP/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 485/518] Input: iforce - bound the device-reported force-feedback effect index
Date: Thu, 16 Jul 2026 15:32:33 +0200
Message-ID: <20260716133058.461204131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 0e9943d2e4c63496b6ca84bc66fd3c71d40558e2 upstream.

iforce_process_packet() handles a status report (packet id 0x02) by
taking a force-feedback effect index straight from the device wire and
using it to address the per-effect state array:

	i = data[1] & 0x7f;
	if (data[1] & 0x80) {
		if (!test_and_set_bit(FF_CORE_IS_PLAYED,
				      iforce->core_effects[i].flags))
			...
	} else if (test_and_clear_bit(FF_CORE_IS_PLAYED,
				      iforce->core_effects[i].flags)) {
		...
	}

The index is masked only with 0x7f, so it ranges 0..127, but
core_effects[] holds only IFORCE_EFFECTS_MAX (32) entries.  For an index
of 32..127 the test_and_set_bit()/test_and_clear_bit() is an
out-of-bounds single-bit read-modify-write past the array.  core_effects[]
is the second-to-last member of struct iforce, so the write lands in the
trailing members and beyond the embedding kzalloc()'d iforce_serio /
iforce_usb object.

data[1] is unvalidated device payload on both transports (the USB
interrupt endpoint and serio), and the status path is not gated on force
feedback being present, so a malicious or counterfeit device can set or
clear a bit at an attacker-chosen offset past the object.

Reject an out-of-range index instead of indexing with it.  Bound against
the array dimension IFORCE_EFFECTS_MAX rather than dev->ff->max_effects so
the check guarantees memory safety regardless of how many effects the
device registered.  A legitimate "effect started/stopped" status always
carries an index below IFORCE_EFFECTS_MAX, so well-formed devices are
unaffected; the neighbouring mark_core_as_ready() loop is already bounded
and is left untouched.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260613-b4-disp-4828d263-v1-1-02320e1a89dd@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/iforce/iforce-packets.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/input/joystick/iforce/iforce-packets.c
+++ b/drivers/input/joystick/iforce/iforce-packets.c
@@ -186,14 +186,18 @@ void iforce_process_packet(struct iforce
 
 		/* Check if an effect was just started or stopped */
 		i = data[1] & 0x7f;
-		if (data[1] & 0x80) {
-			if (!test_and_set_bit(FF_CORE_IS_PLAYED, iforce->core_effects[i].flags)) {
-				/* Report play event */
-				input_report_ff_status(dev, i, FF_STATUS_PLAYING);
+		if (i < IFORCE_EFFECTS_MAX) {
+			if (data[1] & 0x80) {
+				if (!test_and_set_bit(FF_CORE_IS_PLAYED,
+						      iforce->core_effects[i].flags)) {
+					/* Report play event */
+					input_report_ff_status(dev, i, FF_STATUS_PLAYING);
+				}
+			} else if (test_and_clear_bit(FF_CORE_IS_PLAYED,
+						      iforce->core_effects[i].flags)) {
+				/* Report stop event */
+				input_report_ff_status(dev, i, FF_STATUS_STOPPED);
 			}
-		} else if (test_and_clear_bit(FF_CORE_IS_PLAYED, iforce->core_effects[i].flags)) {
-			/* Report stop event */
-			input_report_ff_status(dev, i, FF_STATUS_STOPPED);
 		}
 
 		for (j = 3; j < len; j += 2)


