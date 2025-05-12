Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2802BCF7B;
	Mon, 12 May 2025 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073114; cv=none; b=PG6RtHM+IJvOio0Wjv2FYBT45U6hXAB+qtkBRM+4HQz201iSbRT35+nf4mAnuURBo5awnwVKmOlCwdxZjz18B2GstMmtxiaF2q/LKrMqyPh7tiAol8iAOBKIqUXxYOlvqyCzyZcxXiNXJPehPqAMWp2td0vJl68Pl1QY4r+UWBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073114; c=relaxed/simple;
	bh=GpS/950JNQjrJ3sNmjXQWxKXs5HeQNgntykIpJhBxcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llOUdAhe0orzpuVGx3hCGVh5F6dLBAtDcG1FfTh45GSfPXAX9kbRcYcJN6grCQi2urCAtrh840s92QCJTxhIzSZ9oofrH8E93pShlkiXx7mwg1Q2XeGcFnSxcrb8kw8DJTVxheV/Ir5dDQheTXeR8pDamHifexmDekLmnexj9/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kTE5KrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kTE5KrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CACC4CEEF;
	Mon, 12 May 2025 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073114;
	bh=GpS/950JNQjrJ3sNmjXQWxKXs5HeQNgntykIpJhBxcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kTE5KrDwc8GNyYnlAXQ0t0r/QE61Sj4ENHyQeOkuVaDxMSkg16rkEokeapKFLRVE
	 /7ZGjBKpXIhsbBlu6hWkFAcEPh4BzcdSrNyKQuKM627LS3I7MCabX51F8i6q534t4m
	 UaRtyJSAps3l3TPXjQqSdthML5Wax4CPfJpjQZQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.12 129/184] usb: usbtmc: Fix erroneous generic_read ioctl return
Date: Mon, 12 May 2025 19:45:30 +0200
Message-ID: <20250512172047.070486481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


