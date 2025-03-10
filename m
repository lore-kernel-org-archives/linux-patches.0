Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836AD2253FE;
	Mon, 10 Mar 2025 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628115; cv=none; b=joqzXbz2oNBwWPfNmD7UxOYZy19jMxEuALS4G2QvZwn/IMRUlAJbc/5OrwnQywPHvpwL5ux9lZVUerxxo45GuuYohjiZfEXHjWT6DwNDan6aay4CVF+oW/QKn0Sa18ENtFJRfBALhfNSe8JyF1IDj5q3mS+DP4yjIeahtRNvjxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628115; c=relaxed/simple;
	bh=67UXhwQR//LkyVl+lzFOAggbkcM1do2ufzpe48r61ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVYkJpg1mXOeWq/YZa2Khbkcr2jOR/trsQ5jMFv1qMjXxWWn6fBla80e7YvtrGyDSHKPiODm+q7gyEt/Qivz5RPfDNWARskU5MTqBN5eI5rAseuwGPjq9y2b0mXD5frwOlEedWwu24yxECeud1uoaheWOg3Zno3h7NDf4xPPzIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6ilIesw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6ilIesw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D711C4CEE5;
	Mon, 10 Mar 2025 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628115;
	bh=67UXhwQR//LkyVl+lzFOAggbkcM1do2ufzpe48r61ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6ilIeswGFzRDi6utqyuldvTy94jjtqbeKNvesHcCTHH2o4S8GcaY7x42zK+S9dQu
	 9O03dc/ycmw+ht6NzO7xLPhd9XGkdOVRFdGFDcZL2tWX384wqnE5f9464jXhJkpa9o
	 D4Px98tX22NT2XOgZ0QLkKPenDf1h+rVGavIrN4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qf <quintafeira@tutanota.com>,
	Christian Heusel <christian@heusel.eu>
Subject: [PATCH 6.6 092/145] Revert "drivers/card_reader/rtsx_usb: Restore interrupt based detection"
Date: Mon, 10 Mar 2025 18:06:26 +0100
Message-ID: <20250310170438.470950283@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christian Heusel <christian@heusel.eu>

commit 2397d61ee45cddb8f3bd3a3a9840ef0f0b5aa843 upstream.

This reverts commit 235b630eda072d7e7b102ab346d6b8a2c028a772.

This commit was found responsible for issues with SD card recognition,
as users had to re-insert their cards in the readers and wait for a
while. As for some people the SD card was involved in the boot process
it also caused boot failures.

Cc: stable@vger.kernel.org
Link: https://bbs.archlinux.org/viewtopic.php?id=303321
Fixes: 235b630eda07 ("drivers/card_reader/rtsx_usb: Restore interrupt based detection")
Reported-by: qf <quintafeira@tutanota.com>
Closes: https://lore.kernel.org/all/1de87dfa-1e81-45b7-8dcb-ad86c21d5352@heusel.eu
Signed-off-by: Christian Heusel <christian@heusel.eu>
Link: https://lore.kernel.org/r/20250224-revert-sdcard-patch-v1-1-d1a457fbb796@heusel.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_usb.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -286,7 +286,6 @@ static int rtsx_usb_get_status_with_bulk
 int rtsx_usb_get_card_status(struct rtsx_ucr *ucr, u16 *status)
 {
 	int ret;
-	u8 interrupt_val = 0;
 	u16 *buf;
 
 	if (!status)
@@ -309,20 +308,6 @@ int rtsx_usb_get_card_status(struct rtsx
 		ret = rtsx_usb_get_status_with_bulk(ucr, status);
 	}
 
-	rtsx_usb_read_register(ucr, CARD_INT_PEND, &interrupt_val);
-	/* Cross check presence with interrupts */
-	if (*status & XD_CD)
-		if (!(interrupt_val & XD_INT))
-			*status &= ~XD_CD;
-
-	if (*status & SD_CD)
-		if (!(interrupt_val & SD_INT))
-			*status &= ~SD_CD;
-
-	if (*status & MS_CD)
-		if (!(interrupt_val & MS_INT))
-			*status &= ~MS_CD;
-
 	/* usb_control_msg may return positive when success */
 	if (ret < 0)
 		return ret;


