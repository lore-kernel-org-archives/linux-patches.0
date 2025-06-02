Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BE015CD55;
	Mon,  2 Jun 2025 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874537; cv=none; b=Dlsj+kk5drtY88ghTk0JOaqy6TcXfR5yCz1NuuMF8Rtvnazi31to2i6Ly3hG/jrKpZ7FoXp+ZWLs3yb1yItB8COyfB456ue2x1bXTfzypFmWV+7PabemrrMB0S5wXMAo/6ZF//J8PdZWXxg/ahCGYZjHoom9p2shiVlV1Iea5ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874537; c=relaxed/simple;
	bh=KRS1LpESRZ9BKSUjuI7Qp3uYUlLP9B3lbkle9QRElAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBM1z6W7shC+Df3ygJM0RXp2uiveRP+C3Uwtc+PpCu6XEls6AcLcZtozOC0+WnuIaFjDvXWt2fzcacQNjgep794oY8Y1awEvGNxZyR6QJD8X0vAefTeg5wIonFsNKO6q3ZeWG2hyjLG1S9DzV7idi/ZlsJgtaAtinmMYqQyTXjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcrxmuD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcrxmuD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558B9C4CEEB;
	Mon,  2 Jun 2025 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874536;
	bh=KRS1LpESRZ9BKSUjuI7Qp3uYUlLP9B3lbkle9QRElAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcrxmuD3HQ1Xl8ORrkQetkqDb6eDdv6Z4PYu9zmcmOescpkUH/5YX/heDvh1ni2Yg
	 XT//AV06+BPB/G6ab7UHNBg3WjILnI8VsfNq8z13kU3hlwhFveFc7DZL/f3RsGhxke
	 uXoj4uNSWOGD10q2jBe1CabMeE9EfDT8zHSC/6Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 5.4 056/204] usb: usbtmc: Fix erroneous generic_read ioctl return
Date: Mon,  2 Jun 2025 15:46:29 +0200
Message-ID: <20250602134257.884178220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -803,6 +803,7 @@ static ssize_t usbtmc_generic_read(struc
 	unsigned long expire;
 	int bufcount = 1;
 	int again = 0;
+	long wait_rv;
 
 	/* mutex already locked */
 
@@ -915,19 +916,24 @@ static ssize_t usbtmc_generic_read(struc
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


