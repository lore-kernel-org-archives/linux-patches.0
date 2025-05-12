Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8437314658D;
	Mon, 12 May 2025 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071114; cv=none; b=GfV5hjLmd5JwvBW3YTB4yf5gQuP74+XDHHU/dlBFcPGS5A+GIGPqTEbx0E4x9ruIZcyJqDccgEiHM5s/noFsssz+HGYyv8heSy7NY8CaM5tM6Wx6UgJUFk+vLr7WvXBSNp4LfkQkMYaPzrPYw7QKobteRH7TiuENsItbv9Tjjys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071114; c=relaxed/simple;
	bh=FM8vCtR0+JCF4zTguLT+b6uUZmgx2Xm1wXCBUbRP7Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL0ZZf3J6ZfNxd7Jb86pqQ0FgfElhDLDUzvawiMq2roFxp/Q4DHCRK7B/Z/phHmeWJcOWUE7tWdeSgs+a4nh+dZOxQBSApsDNC7piTIG7WMeEMip35kPhzQxtsHdjkpT7CVS2JrnVJ2aCs9tRR8ZP0hck9vrvYwc886972BL5Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exHhdpeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exHhdpeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152FCC4CEE7;
	Mon, 12 May 2025 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071114;
	bh=FM8vCtR0+JCF4zTguLT+b6uUZmgx2Xm1wXCBUbRP7Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exHhdpeYedA1G/yGbTwWCj0lSOYMHotbsyO7M1ecKj54b9Uiq9jAkUg2koJ1KfhhJ
	 aUwF8TY/u5iRpUQOK+TDOQB/lPT/5Ai+cpAJFJPGC5AHFoJ9lzmMGMrrySExLtZUW4
	 dI13WzsiQ4HVuHJ2OQDd/evNZl4sDzBnr9y1MWn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 5.15 44/54] usb: usbtmc: Fix erroneous generic_read ioctl return
Date: Mon, 12 May 2025 19:29:56 +0200
Message-ID: <20250512172017.416950614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

commit 4e77d3ec7c7c0d9535ccf1138827cb9bb5480b9b upstream.

wait_event_interruptible_timeout returns a long
The return value was being assigned to an int causing an integer overflow
when the remaining jiffies > INT_MAX which resulted in random error
returns.

Use a long return value, converting to the int ioctl return only on error.

Fixes: bb99794a4792 ("usb: usbtmc: Add ioctl for vendor specific read")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250502070941.31819-4-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -833,6 +833,7 @@ static ssize_t usbtmc_generic_read(struc
 	unsigned long expire;
 	int bufcount = 1;
 	int again = 0;
+	long wait_rv;
 
 	/* mutex already locked */
 
@@ -945,19 +946,24 @@ static ssize_t usbtmc_generic_read(struc
 		if (!(flags & USBTMC_FLAG_ASYNC)) {
 			dev_dbg(dev, "%s: before wait time %lu\n",
 				__func__, expire);
-			retval = wait_event_interruptible_timeout(
+			wait_rv = wait_event_interruptible_timeout(
 				file_data->wait_bulk_in,
 				usbtmc_do_transfer(file_data),
 				expire);
 
-			dev_dbg(dev, "%s: wait returned %d\n",
-				__func__, retval);
+			dev_dbg(dev, "%s: wait returned %ld\n",
+				__func__, wait_rv);
 
-			if (retval <= 0) {
-				if (retval == 0)
-					retval = -ETIMEDOUT;
+			if (wait_rv < 0) {
+				retval = wait_rv;
 				goto error;
 			}
+
+			if (wait_rv == 0) {
+				retval = -ETIMEDOUT;
+				goto error;
+			}
+
 		}
 
 		urb = usb_get_from_anchor(&file_data->in_anchor);


