Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFC41465A8;
	Tue, 25 Jun 2024 09:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308815; cv=none; b=lKDW59TfPJLKWGFmwpOq5yXSzVGvQg57LZEwzVWPCOQz/Hcvd0FCPTdLUeKICP90WlQRBZAIPjUwuFWoEzmlN9aTVeS9dMtWJ4fF8rkOfWtthqm2Swj1dTn30qq+P4lFIRIVyb886KSjbBj3hsGFTDptCXP0zu/muVs7vA1iuds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308815; c=relaxed/simple;
	bh=gPo2KIrms5hUmMHyoWzejIloVRzczItnRfv7wD58lKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwC422EPdHMd7Pd1yn9H/VEKihw/FQg7kM+GZa1nPs20jQ07ePl+t7Kc2f+9K/HaCfuddEMHgxfVmkHWuuqi23tlMjTuIVFJglLfaVA0687/1vpf5vL7Qadk4A4NJROi/4magGTc4tyPfEAHpXVzbAr2cQFKEOak0vuTfYU9YjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iN1ZSif6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iN1ZSif6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AD4C32781;
	Tue, 25 Jun 2024 09:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308815;
	bh=gPo2KIrms5hUmMHyoWzejIloVRzczItnRfv7wD58lKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iN1ZSif6wemrCMIKj7m/exiXQXx2s74v3iKtkjWC9A/8KBsXpfLdB4Etc3/DfWyGV
	 A5NiaXnXUk6pvXkNcaioJhtiTMD6p8gsST1wgm9rzszhP450jZjwtNUflQRwRDnUlf
	 3kYlKGVTAjjSqXSD1pNpCTWA4alUJshmDCofg8fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Ballance <andrewjballance@gmail.com>,
	syzbot+07762f019fd03d01f04c@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.9 249/250] hid: asus: asus_report_fixup: fix potential read out of bounds
Date: Tue, 25 Jun 2024 11:33:27 +0200
Message-ID: <20240625085557.607016480@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


