Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4CF7E59F;
	Mon,  8 Apr 2024 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582252; cv=none; b=cgV/Jk6MlpnQCNeXngw+6XIqCEbYHOMA0wx+1GN2b5nBY+rl2um0wXBJE0q1Hb0pc0PXJaKJlciBCPX9RBmFHBW1luXFc5VTXlN7AbDHEEYWBmBeS0LKatAqaoHWI/eCEP21L3+erX5LAzcvmy46KoNXEv4o/9i6f00PL49G4RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582252; c=relaxed/simple;
	bh=1HfvCRfvOy8mLVMJLV6BU6WF/MVrjYHsadKQrEmG8zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+RLjzBK85OBIrCE+CY+0GI6KY+sXrMye/WO8hYIwtRw0+gKSq6RwKQ311n2GupsmwDWYvoFhj2DGQeQhp5uFQhhd4onUXx4l47Hk8jKMiOr8S60Mvk9Dy7589NdrsfwZPUch0noJGkI+GWV/SNeKirn4xkPsSMKAFf1cRH6qy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1xH6EgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1xH6EgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F730C433C7;
	Mon,  8 Apr 2024 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582252;
	bh=1HfvCRfvOy8mLVMJLV6BU6WF/MVrjYHsadKQrEmG8zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1xH6EgOc+xk61NFyfky5zPHpnWjgdAynJDszT4t+r/eLQm58zDzxqzLyJr26o1nb
	 EEueTot/L8RdShzxcrrmEHkmi7CZyBWzzJ25cD6rMkSskUGIl0DuKlwIILveeMuQbi
	 9V0/BsP3JIsdxWp0PS2UZAtIu5Y8RCXowgra73IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	syzbot+28748250ab47a8f04100@syzkaller.appspotmail.com
Subject: [PATCH 5.15 127/690] USB: usb-storage: Prevent divide-by-0 error in isd200_ata_command
Date: Mon,  8 Apr 2024 14:49:53 +0200
Message-ID: <20240408125404.148895915@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
 


