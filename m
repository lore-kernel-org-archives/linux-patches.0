Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5412213C90B;
	Tue, 25 Jun 2024 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309780; cv=none; b=jHuop6VGBEyO2fgPCTzpkSsdwyUDn2h+5tQKpGOoyt17ZHS8nYwFPWErh2OBUP+RLZY7OvbH7+7M9aXfaD88hIyXdvlr5KWGLILfVqo098Pg0JAv+k9NTj92OSuYIicKRDA1LDC3lTyG+3jpPCPly6qjhkFBvwaWt4U7RUgyaeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309780; c=relaxed/simple;
	bh=s842r6vkNYt3ukRDPbS4YtpDV2WwHKyWOfTxvDpMXOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcEjVoPp6ZaJ7HGyPCpfUW0P6WaoJusMvRa04cHYYqgO49BCHzlvTQ/kHFIRWoxI8NrJo3OQgYFJApsY+XCUBkPguLzuujyVgEwylRCtUmt19+A8o4dXfRNaPzPHaOm8HhY7s7BmEreGB7OhZ6Vwz0u78W7412HVTI6cupz/t3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/MDwphP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/MDwphP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEBBC32781;
	Tue, 25 Jun 2024 10:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309780;
	bh=s842r6vkNYt3ukRDPbS4YtpDV2WwHKyWOfTxvDpMXOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/MDwphPg21ZTcNmGVtM5OsRri4Z/2eIMoJk+UxUeCSRGegEDzA1K3t/+SdwffLLe
	 jarF31iSa3g80ZUFhW/gwH1AbQoF4jg2TBRbh5I9anzHYj7EHPjrVqQd7OJ1ibU4yJ
	 iEfAu8rgMfx6xCONEtPnVmoCerh8BeZjAtmvXQSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Ballance <andrewjballance@gmail.com>,
	syzbot+07762f019fd03d01f04c@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 130/131] hid: asus: asus_report_fixup: fix potential read out of bounds
Date: Tue, 25 Jun 2024 11:34:45 +0200
Message-ID: <20240625085530.878127171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1247,8 +1247,8 @@ static __u8 *asus_report_fixup(struct hi
 	}
 
 	/* match many more n-key devices */
-	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
-		for (int i = 0; i < *rsize + 1; i++) {
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD && *rsize > 15) {
+		for (int i = 0; i < *rsize - 15; i++) {
 			/* offset to the count from 0x5a report part always 14 */
 			if (rdesc[i] == 0x85 && rdesc[i + 1] == 0x5a &&
 			    rdesc[i + 14] == 0x95 && rdesc[i + 15] == 0x05) {


