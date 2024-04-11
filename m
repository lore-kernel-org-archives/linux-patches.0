Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729301448F3;
	Thu, 11 Apr 2024 10:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831788; cv=none; b=HB7cwAzAqMnLhVe7rRAQFPXUN1zrrUgZwSAWDk0xH0ZXR9+XBbdaYLiNfU7dNb5qVodpjhCxmVcuyNqT1BeJ610+G8cw4O1j1sY+7wM3eU9LZYoB4V97VIIOtCK0t1BKzqwS+52iADE1DYNq4kwWbCkSme0lQS0aQQrbz8sWWx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831788; c=relaxed/simple;
	bh=EyowG7ezgTeWP0SR5eowC7DsMIia58lNimHaWtMlL6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4JOWJkBIAR9yDW7vOExb7+oWkRm3vD1hmpCA2hPSg17x9pUnRM8DBSOXu8aiuSDyxL8t/4OGVsbaGSHQ5S6XX4T/jd7syN0E1uLUua7UpxRf9xVF+A1DIlT/fY15xiAo9ClaAkVfsiVC0KDkQXG6ZeFGIbXYgPPawZ9tDIADhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL+SDU51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL+SDU51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE2EC433F1;
	Thu, 11 Apr 2024 10:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831788;
	bh=EyowG7ezgTeWP0SR5eowC7DsMIia58lNimHaWtMlL6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL+SDU51NFtX/5odmBGlexQ49ohNdfiRud0KQAUM77mH9KhbqGYQRmqGlqV/J/kxL
	 TznVHDK0kdWSZT4dXIbMTGHiLAf4E2jZW06oUqpP10Rhj1E+NzpNXp+ygJKtkSiZUI
	 +/As+wqQQBes+g4I4Q5oHfEI/h95R+flj41ufqDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	syzbot+28748250ab47a8f04100@syzkaller.appspotmail.com
Subject: [PATCH 5.10 126/294] USB: usb-storage: Prevent divide-by-0 error in isd200_ata_command
Date: Thu, 11 Apr 2024 11:54:49 +0200
Message-ID: <20240411095439.454988148@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 014bcf41d946b36a8f0b8e9b5d9529efbb822f49 upstream.

The isd200 sub-driver in usb-storage uses the HEADS and SECTORS values
in the ATA ID information to calculate cylinder and head values when
creating a CDB for READ or WRITE commands.  The calculation involves
division and modulus operations, which will cause a crash if either of
these values is 0.  While this never happens with a genuine device, it
could happen with a flawed or subversive emulation, as reported by the
syzbot fuzzer.

Protect against this possibility by refusing to bind to the device if
either the ATA_ID_HEADS or ATA_ID_SECTORS value in the device's ID
information is 0.  This requires isd200_Initialization() to return a
negative error code when initialization fails; currently it always
returns 0 (even when there is an error).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+28748250ab47a8f04100@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-usb/0000000000003eb868061245ba7f@google.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/b1e605ea-333f-4ac0-9511-da04f411763e@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/isd200.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1105,7 +1105,7 @@ static void isd200_dump_driveid(struct u
 static int isd200_get_inquiry_data( struct us_data *us )
 {
 	struct isd200_info *info = (struct isd200_info *)us->extra;
-	int retStatus = ISD200_GOOD;
+	int retStatus;
 	u16 *id = info->id;
 
 	usb_stor_dbg(us, "Entering isd200_get_inquiry_data\n");
@@ -1137,6 +1137,13 @@ static int isd200_get_inquiry_data( stru
 				isd200_fix_driveid(id);
 				isd200_dump_driveid(us, id);
 
+				/* Prevent division by 0 in isd200_scsi_to_ata() */
+				if (id[ATA_ID_HEADS] == 0 || id[ATA_ID_SECTORS] == 0) {
+					usb_stor_dbg(us, "   Invalid ATA Identify data\n");
+					retStatus = ISD200_ERROR;
+					goto Done;
+				}
+
 				memset(&info->InquiryData, 0, sizeof(info->InquiryData));
 
 				/* Standard IDE interface only supports disks */
@@ -1202,6 +1209,7 @@ static int isd200_get_inquiry_data( stru
 		}
 	}
 
+ Done:
 	usb_stor_dbg(us, "Leaving isd200_get_inquiry_data %08X\n", retStatus);
 
 	return(retStatus);
@@ -1481,22 +1489,27 @@ static int isd200_init_info(struct us_da
 
 static int isd200_Initialization(struct us_data *us)
 {
+	int rc = 0;
+
 	usb_stor_dbg(us, "ISD200 Initialization...\n");
 
 	/* Initialize ISD200 info struct */
 
-	if (isd200_init_info(us) == ISD200_ERROR) {
+	if (isd200_init_info(us) < 0) {
 		usb_stor_dbg(us, "ERROR Initializing ISD200 Info struct\n");
+		rc = -ENOMEM;
 	} else {
 		/* Get device specific data */
 
-		if (isd200_get_inquiry_data(us) != ISD200_GOOD)
+		if (isd200_get_inquiry_data(us) != ISD200_GOOD) {
 			usb_stor_dbg(us, "ISD200 Initialization Failure\n");
-		else
+			rc = -EINVAL;
+		} else {
 			usb_stor_dbg(us, "ISD200 Initialization complete\n");
+		}
 	}
 
-	return 0;
+	return rc;
 }
 
 


