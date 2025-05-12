Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCE11C3BE0;
	Mon, 12 May 2025 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072122; cv=none; b=YrjwslEEQy/+NPoECIfP+vUknq54GUeo4Ty++qUNkrObMdTYgc3+oj4PUM9bjK0aLdhtOu3pBAb2zpdwAK4+wKchpRTvNKyuVBsY3TMcGFxZaSnJG5eGIowHlXePdyf/sc8cbd3zQrqNMV6z7p5bsqqFVJnr5Em3opZznSaqeQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072122; c=relaxed/simple;
	bh=h1LYUGt6lQAZo5t+aPYsE5veAnTlE88QSPBtF30mea8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFOU31TIi4Rre0zCYY+NOoWc5DRF44CMILESwEghSRh0e1wvKkF+CVEJ9Tnlg1zkvE9MrsTOC0BaT3tcza02PCjoTNEN4sKH3EZkLry7T0ZYUkZAmPxEa98idieM1A6oJaNX271AjvXZJlmL7Kv1H6XZuReBzPV2kYpRy9enREg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiypQdO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiypQdO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0F0C4CEE7;
	Mon, 12 May 2025 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072121;
	bh=h1LYUGt6lQAZo5t+aPYsE5veAnTlE88QSPBtF30mea8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiypQdO0GEsPEO0/FokyDHfVdblr1mbU95uZYeZhsd0soVIBx1kbkhcfgsy1nlSEd
	 ShJec0yODq9k2vehbRvHPk64EzhZaRlG0FW7KOVvnkY+ce3ElOwWTwwoq3H6wXptUR
	 YGG2nXPyaWcovCqI+YGibn8P5ijifpkNetJ12lvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.14 147/197] usb: usbtmc: Fix erroneous wait_srq ioctl return
Date: Mon, 12 May 2025 19:39:57 +0200
Message-ID: <20250512172050.378531383@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


