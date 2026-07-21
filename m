Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C571935C6A3;
	Tue, 21 Jul 2026 21:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668628; cv=none; b=JaNhVJHj/RGWbymivOFjZem7mdD62v+1WGd58Zskwv1UQVRKuXK7mGRZ7EFuoLlzeanM0CFCKJek6se2c6tUPfTY2Gdh6uMMpbAOZlhyzeT9Xjr3D25BJj3CQaUrThbMNONaDiCeZUjBzXd84FvDLiRKcbbotXBETWPrUyQ4uwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668628; c=relaxed/simple;
	bh=Y2a7aCZxI7UB37PdmjI1BGRUMEWRoQzAkGhd4eZc1Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJgGvz5Q/V9yO2PeceZQFXyu1TMzuFJCE+zk3lQNwMYYCRSOP3fpfbntL7+F0OG/x3aZROMHIbSd/e91vw86C+fxQjj9lrwwXneeW7esTq1cYat6iclzTtVzCkKdpE+tn6tjz9JbpyHmGvSfbtD0yyyfT1oNOn+r88Evo522VWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VngdQxFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VngdQxFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8001F00A3A;
	Tue, 21 Jul 2026 21:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668623;
	bh=qc+DThAMs5lTM/VChAlKAypzzfV5Rw5qjKxFAZfI424=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VngdQxFR6sld6CLLJppGFAoxYYh7WqaRdExU2jyQrGbxJ8YwjQ7fgr5VktBqXAlY4
	 MZYupbeqscA+bfF1seAd9ztPDq1vwKp+8Xj+6W2RDVqSzml2ydtRCXwXtjFDLZvkqX
	 226U2nTWbVYVVk7bCUSo6MfwcbBEMquemCZCE1SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0239/1067] Input: iforce - bound the device-reported force-feedback effect index
Date: Tue, 21 Jul 2026 17:14:00 +0200
Message-ID: <20260721152429.948085815@linuxfoundation.org>
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


