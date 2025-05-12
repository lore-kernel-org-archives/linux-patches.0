Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B55C29DB6A;
	Mon, 12 May 2025 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073105; cv=none; b=p7w8Lw4qu9hzwXCsD0gnNj66Kxy/uEeHRpzfNr4ymypPtEySk9Lu66Zk8LZpOr5GqjcWOiYd/Dx72khLlcWJaiYE2YT0P2gjAFr/86HuQDQQVbrVCpyzo5fpvuP9TDBa3x+280dUNEKK1j4Avx4S5vY/mfyn2Vib4b8S+qBu8RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073105; c=relaxed/simple;
	bh=Bm5EdoJpwFvqhNtJHiTYc3oBow7LUD7cjKU9dRu/ICM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTGKoNGawbaP1IPW0oXP11aOb7QzQYQze/CNMR9pg0qH1Ys3b5fjugFlR/GU+y+Xc4C/FPUAFBWjmL65VNpAU0smR7YirNqHBq0GzaY/Pea2XIDK8xwYoG6qUaXsJEjMtW0DVxSAnTci2pqqfBwE1sp7lsgTDVuc84lohX4fP88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTRFBj9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTRFBj9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDD8C4CEE9;
	Mon, 12 May 2025 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073105;
	bh=Bm5EdoJpwFvqhNtJHiTYc3oBow7LUD7cjKU9dRu/ICM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTRFBj9RNZuhsTwyHdX0cmtTSwJ55K3IKR467W/ErUOV8UYFvFeuWJQFjOJVguHXm
	 gsDIcRU0bwGMdCdbGykwCKmHistZqPX5CpeUMMTospgNrusGYbXQ91YknaylSZYYmr
	 yF4EP0ZZLYa8WZlrOax+Vu3q+tkfT51QoDbmk/5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.12 128/184] usb: usbtmc: Fix erroneous wait_srq ioctl return
Date: Mon, 12 May 2025 19:45:29 +0200
Message-ID: <20250512172047.028611845@linuxfoundation.org>
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

commit a9747c9b8b59ab4207effd20eb91a890acb44e16 upstream.

wait_event_interruptible_timeout returns a long
The return was being assigned to an int causing an integer overflow when
the remaining jiffies > INT_MAX resulting in random error returns.

Use a long return value,  converting to the int ioctl return only on
error.

Fixes: 739240a9f6ac ("usb: usbtmc: Add ioctl USBTMC488_IOCTL_WAIT_SRQ")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250502070941.31819-3-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -606,9 +606,9 @@ static int usbtmc488_ioctl_wait_srq(stru
 {
 	struct usbtmc_device_data *data = file_data->data;
 	struct device *dev = &data->intf->dev;
-	int rv;
 	u32 timeout;
 	unsigned long expire;
+	long wait_rv;
 
 	if (!data->iin_ep_present) {
 		dev_dbg(dev, "no interrupt endpoint present\n");
@@ -622,25 +622,24 @@ static int usbtmc488_ioctl_wait_srq(stru
 
 	mutex_unlock(&data->io_mutex);
 
-	rv = wait_event_interruptible_timeout(
-			data->waitq,
-			atomic_read(&file_data->srq_asserted) != 0 ||
-			atomic_read(&file_data->closing),
-			expire);
+	wait_rv = wait_event_interruptible_timeout(
+		data->waitq,
+		atomic_read(&file_data->srq_asserted) != 0 ||
+		atomic_read(&file_data->closing),
+		expire);
 
 	mutex_lock(&data->io_mutex);
 
 	/* Note! disconnect or close could be called in the meantime */
 	if (atomic_read(&file_data->closing) || data->zombie)
-		rv = -ENODEV;
+		return -ENODEV;
 
-	if (rv < 0) {
-		/* dev can be invalid now! */
-		pr_debug("%s - wait interrupted %d\n", __func__, rv);
-		return rv;
+	if (wait_rv < 0) {
+		dev_dbg(dev, "%s - wait interrupted %ld\n", __func__, wait_rv);
+		return wait_rv;
 	}
 
-	if (rv == 0) {
+	if (wait_rv == 0) {
 		dev_dbg(dev, "%s - wait timed out\n", __func__);
 		return -ETIMEDOUT;
 	}


