Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49B13DDC0;
	Wed, 19 Jun 2024 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804110; cv=none; b=IZt7UKtTxncmy2mWpNf+yxyUHnI9g0CDh2OE+KJcz3b1ntgctcxJup44JDA2xcUAll1Wdj82uyEjkLZHqao8p5ZJ8CFm+unOP56ckd4Dgyl+32aCxNfMBXZ0wFwynWnon/03Ies2SHBw9RNlYK+Ee2ggVTeMaLwn9FZrB+3GsgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804110; c=relaxed/simple;
	bh=9MwUp7JYcGpQcr3cSnbVTh3ej36sWxbeHv84tcge2UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf08WVFF7R9Gmu3BNLSY4c/kRcNFHD4WaQkgBCwu3CNMNV7dyzdpRhILpYyXRzzBdJ/e5127/olXXBLzDuSb431IIVR5GRpzYt3FgzmNzWvRoEp7uRGsmAKP7oS0F3GvzD3A3blxIjnxF7TrjdS6Mhgdqg2KPj5N7q8HJGwjJc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRs7Qgb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRs7Qgb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7E2C2BBFC;
	Wed, 19 Jun 2024 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804110;
	bh=9MwUp7JYcGpQcr3cSnbVTh3ej36sWxbeHv84tcge2UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRs7Qgb3yIPgdoc29En/4GWB5gACLGTPxZET+uF/nVglXz9TS/jHCAXf6NuCJxFdO
	 nWOjDzZDa+fc9prd7gcILUSOjXvDF2eDVRXPDI1UtxgxLCE6tR2OWQ3L4qhe20LO38
	 QWnYQRXB6fXMKbe6CBPlQ3cczaTd5wcP/jG1Te+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	yue sun <samsun1006219@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Shichao Lai <shichaorai@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/217] usb-storage: alauda: Check whether the media is initialized
Date: Wed, 19 Jun 2024 14:57:36 +0200
Message-ID: <20240619125604.911615112@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Shichao Lai <shichaorai@gmail.com>

[ Upstream commit 16637fea001ab3c8df528a8995b3211906165a30 ]

The member "uzonesize" of struct alauda_info will remain 0
if alauda_init_media() fails, potentially causing divide errors
in alauda_read_data() and alauda_write_lba().
- Add a member "media_initialized" to struct alauda_info.
- Change a condition in alauda_check_media() to ensure the
  first initialization.
- Add an error check for the return value of alauda_init_media().

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Shichao Lai <shichaorai@gmail.com>
Link: https://lore.kernel.org/r/20240526012745.2852061-1-shichaorai@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/alauda.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 115f05a6201a1..40d34cc28344a 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -105,6 +105,8 @@ struct alauda_info {
 	unsigned char sense_key;
 	unsigned long sense_asc;	/* additional sense code */
 	unsigned long sense_ascq;	/* additional sense code qualifier */
+
+	bool media_initialized;
 };
 
 #define short_pack(lsb,msb) ( ((u16)(lsb)) | ( ((u16)(msb))<<8 ) )
@@ -476,11 +478,12 @@ static int alauda_check_media(struct us_data *us)
 	}
 
 	/* Check for media change */
-	if (status[0] & 0x08) {
+	if (status[0] & 0x08 || !info->media_initialized) {
 		usb_stor_dbg(us, "Media change detected\n");
 		alauda_free_maps(&MEDIA_INFO(us));
-		alauda_init_media(us);
-
+		rc = alauda_init_media(us);
+		if (rc == USB_STOR_TRANSPORT_GOOD)
+			info->media_initialized = true;
 		info->sense_key = UNIT_ATTENTION;
 		info->sense_asc = 0x28;
 		info->sense_ascq = 0x00;
-- 
2.43.0



