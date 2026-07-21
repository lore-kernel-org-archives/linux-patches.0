Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD343901B;
	Tue, 21 Jul 2026 22:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672779; cv=none; b=Kn0YSbeaDZt+M47xK8ve4RghzwjNjbp+k3RrVuo3S1gUXg52tw2va9JwAGOb1q5cGZcDK+VKuIfp/TFrIFoan0R/fkgGAQexz0mQKYL0AH1NPabIY1XtSt1D9PX468ccQlFGqBtt11A9TA8y+ZSXxK/SZGe1T0MzBSLfFYf9kzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672779; c=relaxed/simple;
	bh=b5vVu5aDKucLz71PWL3dFIN1g85jlBXIDrOClCQZLw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R32Q1x34RF3W6pIJib17JL6MNyGPG1R3tSebr98sBtwUdNw2KH/ns88kFnq55XQj52S3gH+9SIyzjvakWRsajRmlL1l9tsfafRHxUt5FBVXzHSjQAKEu3MdHKkRTtJNIWEkBlgvAJDk6CbD9vNDP2+mUb9xfSqehQ/+SWv0A0mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVa4020u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVa4020u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C1E1F000E9;
	Tue, 21 Jul 2026 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672777;
	bh=+YZDUuRtCejq12RB90UUxpLYusVb/GNSoNvp6c3LV70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVa4020uSXdZSjvjsSdUk2PU8Zin2K21cGd3E47bWVcb+Vhm/HlnTOw3vw847Ubi2
	 nU60+lJ1b3/2FfctoGOJ3nG6RZwj5TfJwqlKB+WlBW5iG8srXjANe2JQ9kk+WTJfH2
	 z2SmQXvMHW5qsnNl6KrbQop0RvIH3NRipPwFfZG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 726/843] mmc: vub300: defer reset until cmd_mutex is unlocked
Date: Tue, 21 Jul 2026 17:26:01 +0200
Message-ID: <20260721152422.373146089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit ee5fb641c4ccac8406c668d3e947eb20ce44f233 upstream.

vub300_cmndwork_thread() holds cmd_mutex while it sends a command and
waits for the command response.  If the response wait times out,
__vub300_command_response() kills the command URBs and then synchronously
resets the USB device through usb_reset_device().

That reset path re-enters the driver through vub300_pre_reset(), which
also takes cmd_mutex.  The worker therefore tries to acquire the same
mutex recursively while it is still holding it from the command path.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the real worker and timeout/reset carrier:

  vub300_cmndwork_thread()
  __vub300_command_response()
  usb_lock_device_for_reset()
  usb_reset_device()
  vub300_pre_reset()

Lockdep reported the same-task recursive acquisition on cmd_mutex:

  WARNING: possible recursive locking detected
  ... (&test_vub300.cmd_mutex) ... at: usb_reset_device... [vuln_msv]
  ... (&test_vub300.cmd_mutex) ... at: vub300_cmndwork_thread+0x12/0x20 [vuln_msv]
  Workqueue: vub300_cmd_wq vub300_cmndwork_thread [vuln_msv]
  *** DEADLOCK ***

Return a flag from __vub300_command_response() when the timeout path needs
a device reset, then perform the reset after vub300_cmndwork_thread() has
cleared the in-flight command state and dropped cmd_mutex.  The reset is
still attempted before mmc_request_done(), preserving the existing request
completion ordering while avoiding the recursive lock.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -1587,7 +1587,7 @@ static int __command_write_data(struct v
 	return linear_length;
 }
 
-static void __vub300_command_response(struct vub300_mmc_host *vub300,
+static bool __vub300_command_response(struct vub300_mmc_host *vub300,
 				      struct mmc_command *cmd,
 				      struct mmc_data *data, int data_length)
 {
@@ -1599,17 +1599,11 @@ static void __vub300_command_response(st
 					    msecs_to_jiffies(msec_timeout));
 	if (respretval == 0) { /* TIMED OUT */
 		/* we don't know which of "out" and "res" if any failed */
-		int result;
 		vub300->usb_timed_out = 1;
 		usb_kill_urb(vub300->command_out_urb);
 		usb_kill_urb(vub300->command_res_urb);
 		cmd->error = -ETIMEDOUT;
-		result = usb_lock_device_for_reset(vub300->udev,
-						   vub300->interface);
-		if (result == 0) {
-			result = usb_reset_device(vub300->udev);
-			usb_unlock_device(vub300->udev);
-		}
+		return true;
 	} else if (respretval < 0) {
 		/* we don't know which of "out" and "res" if any failed */
 		usb_kill_urb(vub300->command_out_urb);
@@ -1705,6 +1699,8 @@ static void __vub300_command_response(st
 	} else {
 		cmd->error = -EINVAL;
 	}
+
+	return false;
 }
 
 static void construct_request_response(struct vub300_mmc_host *vub300,
@@ -1750,6 +1746,7 @@ static void vub300_cmndwork_thread(struc
 		struct mmc_request *req = vub300->req;
 		struct mmc_command *cmd = vub300->cmd;
 		struct mmc_data *data = vub300->data;
+		bool reset_device;
 		int data_length;
 		mutex_lock(&vub300->cmd_mutex);
 		init_completion(&vub300->command_complete);
@@ -1772,7 +1769,8 @@ static void vub300_cmndwork_thread(struc
 			data_length = __command_read_data(vub300, cmd, data);
 		else
 			data_length = __command_write_data(vub300, cmd, data);
-		__vub300_command_response(vub300, cmd, data, data_length);
+		reset_device = __vub300_command_response(vub300, cmd,
+							 data, data_length);
 		vub300->req = NULL;
 		vub300->cmd = NULL;
 		vub300->data = NULL;
@@ -1780,6 +1778,16 @@ static void vub300_cmndwork_thread(struc
 			if (cmd->error == -ENOMEDIUM)
 				check_vub300_port_status(vub300);
 			mutex_unlock(&vub300->cmd_mutex);
+			if (reset_device) {
+				int result;
+
+				result = usb_lock_device_for_reset(vub300->udev,
+								   vub300->interface);
+				if (result == 0) {
+					result = usb_reset_device(vub300->udev);
+					usb_unlock_device(vub300->udev);
+				}
+			}
 			mmc_request_done(vub300->mmc, req);
 			kref_put(&vub300->kref, vub300_delete);
 			return;


