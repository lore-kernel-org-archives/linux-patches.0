Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463D014A4DE;
	Tue, 25 Jun 2024 09:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309383; cv=none; b=LnydGA1nblenA9J9up8jIxGy92tV+229U2q/gZYV6w9A2Rhrb2hhNsQbBaySf8NhSPhSQg/XD7EghfPPksEh4DWsYz0TabjB1MGeyVU2JlQrn6i5Are9c0rzR/swuFbXhJJXEn2T8LjgJKuwCH3hGMC6Ft5k0+3Hwzf2QHhPcB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309383; c=relaxed/simple;
	bh=EoqjyxZs9lZ8h1JL7BlUYTM8jYKZxiQ5TlmymBlDivU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/dVTOTfTPt2ZVDCYX01KnoiGmlBXPMr/YWYGw2Zmi8pT/owwOcfI68/0Y3zfTCwkKSZ7wmsXOktuIRg5MQFzCY8iI9hdwtOsq5ZxSeDOAJYot9CFTe7sR3/LuCGvUvuIfpAA2n7+aj6nzSoWH8BW4v69yFTWfLM/d+QkoLlZ3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHviNAdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHviNAdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BE3C32781;
	Tue, 25 Jun 2024 09:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309383;
	bh=EoqjyxZs9lZ8h1JL7BlUYTM8jYKZxiQ5TlmymBlDivU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHviNAdINriMv8YKso6zUqRg66GDmpl3syeRtG1xcQ2mjZI/pljMBM1pqSbDhlwmg
	 x3PeOj6IiAwhIIqXLCkUvZ8XwgwiheVOLs7qWPJZ/W+2ZfYpXkLOB8T4nXig3c/Y16
	 Y6fPmxPm0AhfSGGD0IClH/VxTG40oU8QyEsoPb1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Ballance <andrewjballance@gmail.com>,
	syzbot+07762f019fd03d01f04c@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 191/192] hid: asus: asus_report_fixup: fix potential read out of bounds
Date: Tue, 25 Jun 2024 11:34:23 +0200
Message-ID: <20240625085544.490917443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrew Ballance <andrewjballance@gmail.com>

commit 89e1ee118d6f0ee6bd6e80d8fe08839875daa241 upstream.

syzbot reported a potential read out of bounds in asus_report_fixup.

this patch adds checks so that a read out of bounds will not occur

Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Reported-by:  <syzbot+07762f019fd03d01f04c@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=07762f019fd03d01f04c
Fixes: 59d2f5b7392e ("HID: asus: fix more n-key report descriptors if n-key quirked")
Link: https://lore.kernel.org/r/20240602085023.1720492-1-andrewjballance@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1235,8 +1235,8 @@ static __u8 *asus_report_fixup(struct hi
 	}
 
 	/* match many more n-key devices */
-	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
-		for (int i = 0; i < *rsize + 1; i++) {
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD && *rsize > 15) {
+		for (int i = 0; i < *rsize - 15; i++) {
 			/* offset to the count from 0x5a report part always 14 */
 			if (rdesc[i] == 0x85 && rdesc[i + 1] == 0x5a &&
 			    rdesc[i + 14] == 0x95 && rdesc[i + 15] == 0x05) {


