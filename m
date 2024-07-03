Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649D51836EF;
	Wed,  3 Jul 2024 10:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003568; cv=none; b=sPIjEbZQ9qaHQgH7s8bVcKe9Bi1jfNMJcDC/P01IhwWeHLINRxmZMi2y4VngvC9/VYjBnO1byDJ0jzUkXb5YkA7yrR2J3cwzwQR8vN+JRS3SCNlfpZUTVoCWtBohUHqf8CEcxo4ykOpMnHoD4asagYLntJAq/Fhz7IWMR4U/2xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003568; c=relaxed/simple;
	bh=3xocDTI4JJckmLZmArufjlOHaqFUiGBeLwQmsIEfwyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFMJNVHEcI9BjUHcY5Rm+FY7nvZ1nsYdUoS/P9G/7AphSGaQnbKIR0LLNpDTXYaXtz6YVzH1cDhRGn+A1+I8ds/is9mDe+RxPZRnpgyQ4JKe/8ZJoz7r1eSxlO9FXZCKtY1oKxpuYP6I1B2nY9MydUCJy78be9uBdes2cci5mKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0B4J3Wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0B4J3Wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD12C2BD10;
	Wed,  3 Jul 2024 10:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003568;
	bh=3xocDTI4JJckmLZmArufjlOHaqFUiGBeLwQmsIEfwyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0B4J3WmSqyne2kH7znWpaywIJWcUKNkA/V/WIZk/uSwVED2mVlNrZSStdAHP2Jfk
	 xiimxnS2l6+jwK5HuOBTgfhfptPWsDY/HtgRni/EERZf2r+KtL0ILAz6Dk10Q7vLqd
	 q0oU/cGAQnXaJ3GKQchMXPULaSNhmaQxkFl0fzTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	yue sun <samsun1006219@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Shichao Lai <shichaorai@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/139] usb-storage: alauda: Check whether the media is initialized
Date: Wed,  3 Jul 2024 12:39:17 +0200
Message-ID: <20240703102832.706570165@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 50c8bd7cbfddb..f29784fb908e6 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -104,6 +104,8 @@ struct alauda_info {
 	unsigned char sense_key;
 	unsigned long sense_asc;	/* additional sense code */
 	unsigned long sense_ascq;	/* additional sense code qualifier */
+
+	bool media_initialized;
 };
 
 #define short_pack(lsb,msb) ( ((u16)(lsb)) | ( ((u16)(msb))<<8 ) )
@@ -475,11 +477,12 @@ static int alauda_check_media(struct us_data *us)
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



