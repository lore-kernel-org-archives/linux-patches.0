Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5760A45945;
	Wed,  3 Jul 2024 11:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005683; cv=none; b=MyrWyZwBtSGWzm5IG5ubaHIkyepI6wHiY+OHFt5zKSsrmqp8gWACm9EMh/cQ3CsRcQuBS4uaMt03bctT7J0JmWs5tkolTLVU0GnS1XSHTad11ISwq7SQG7IAI/1USlRNI0k96x5+DdMRoLH4vocrx5R52TTBcueWkF71C/kDCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005683; c=relaxed/simple;
	bh=UcEf5ZU40WKG8/MgdUqhIKLUP3B1JuJcXXlO8GbbvRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGVFCgeJaeFHrB05jkJPeAyzftnrUCq7ygWZZkrVsCaEG1TuYAAQlhs/Ryly8ogvkVfFjm8uAF2PEKswTjrNhOVQcFbhcw6EtIymWxSFqCGejdma1d26eDBkjdNwlKPkKFHQa9mz6QU6QUa2QCuQccOV82VI83mdmzC+fVAsosY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTTnDu1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTTnDu1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FF0C2BD10;
	Wed,  3 Jul 2024 11:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005683;
	bh=UcEf5ZU40WKG8/MgdUqhIKLUP3B1JuJcXXlO8GbbvRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTTnDu1ibnw6UsDhnBb4DzsA54PoONru7NIqIB8xF/k3JTvFycthd1ECmUGYtIzaV
	 ZJFvj0qfmzwY0Wt7/1I25GDf9gQ3ZEjDtqKNnMXQw1x8dlRVJ+UND4WGXEPtHp+Y+j
	 rgI1xc0AwXF6hz4+mtD3aocxlhsHeWPxl1ZOEGBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	yue sun <samsun1006219@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Shichao Lai <shichaorai@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/356] usb-storage: alauda: Check whether the media is initialized
Date: Wed,  3 Jul 2024 12:38:00 +0200
Message-ID: <20240703102918.551328996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index dcc4778d1ae99..17fe35083f048 100644
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



