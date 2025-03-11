Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3ED25E82C;
	Tue, 11 Mar 2025 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707543; cv=none; b=Eu6TxnrtthblHWa1qH2vi6yYbcNrqRbLRuG73xwY++mbNWzsmcf9jGhxP9+7EnklHbtsdXctGtXuab11vahlnqyyLBYzmB3pO6Xt8wNTF8NBDGqhQeOUk4F2lTSTgVNEuYfCmIAi40T9ERERzEe4W++VuBMYSf3jtwJjFJn24jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707543; c=relaxed/simple;
	bh=wwtcMdNj5a9yL18+RFDrT+qasYZcrv6eoc10DTR1F8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPg/pT2Rt+1pnSDqhWFxEKDHja9R52KG2dxHYntEqPeJlx3bRQ5ohiwXAMV0n+jup3z/zM4RuptHEgvEPl0XIqSNZPi5C7/0Wo4/q6eNJeS4bnIfsYiITMeS9YWjLldZpQPLS8kfwEohW4dao3DkrbqMpsbjwBeqamgDNzkKZS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsgDq0SG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsgDq0SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E57C4CEE9;
	Tue, 11 Mar 2025 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707543;
	bh=wwtcMdNj5a9yL18+RFDrT+qasYZcrv6eoc10DTR1F8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsgDq0SGg3+N06QOV6V/WdY8o1tAfb0hmQhXjcmN59W1hJc8V1pUNIMig81+ocUk2
	 AJdms97jiKz7FzEOQtwnPIlbY2+Zzl+ljH04cALx6x9wFkSfCi4cEJXgi0DxFma6pl
	 uCbbKJVhash+5mqPCcbxa5cYwvU+RAFkvAw/xK14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qf <quintafeira@tutanota.com>,
	Christian Heusel <christian@heusel.eu>
Subject: [PATCH 5.10 425/462] Revert "drivers/card_reader/rtsx_usb: Restore interrupt based detection"
Date: Tue, 11 Mar 2025 16:01:31 +0100
Message-ID: <20250311145815.126299679@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


