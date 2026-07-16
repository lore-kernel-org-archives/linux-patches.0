Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5E23FE653;
	Thu, 16 Jul 2026 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212511; cv=none; b=aj7tSV2/ORjPbtB7hA5mUVijWDh88skm8TCY2htliRinmLFf5RA5C1VOeALACXCyxxcggsKmQtft2jzix1604L62O3XbwWYKJFiT+rtidhADPJEhUD2abW7v/7Bjbyfab4MtIE8JfmZa1LjoM0e2LIBb45ERTN0ljhocKp5gz7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212511; c=relaxed/simple;
	bh=8Gf4a6OmZJuWnDi4+qobt88xFpbVgktm45k8f4FfJEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIb8FHN4xQMAFRjACPuVjEnMqJOzBADhz4Rrmpx7wX0N3C9HMC6OLQK0p98lq2uerZypbfjD2R62TLSZ1+1S+NcyNIPNHL7Au2b6FqnfFBtba3d01oVY9lvF7KMPWwEk59LqtG9Nrvs2f3BQi19f0NbPoz3rd3TC6PNGXKmIxU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yW1ydphA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yW1ydphA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA4B1F000E9;
	Thu, 16 Jul 2026 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212510;
	bh=9ZD5ZjLVZNF2GEhICMXq5dKR20bBjts8ys4+gnonOBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yW1ydphATn6R+7I/1v2WkxmOKOFaVVgtpuNmXt6zv83M5zdQIc7+rAXqzd0LJdm69
	 MZho9r4cpj8guzrwV+d/C0VJ4SIWY4gwWMiZI0ZzrhDYpFWx0KJJKT+aH6gGNIFQyt
	 HvCTypmW6fow1gUDwAuePCLL2JD+46nx+YM+480o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 335/349] Input: iforce - bound the device-reported force-feedback effect index
Date: Thu, 16 Jul 2026 15:34:29 +0200
Message-ID: <20260716133040.809606575@linuxfoundation.org>
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
@@ -192,14 +192,18 @@ void iforce_process_packet(struct iforce
 
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


