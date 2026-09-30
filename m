Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A20F4F4049;
	Wed, 30 Sep 2026 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787699; cv=none; b=UmZADCAfGCgXuNjzI+KcalyBkD+Dpw9dEIw33xi1TusX8hprAU/wHZPynTjFesAVtBqE9mn6N/6ZZRIEjht30AH5JPy7q+t+pitqfat5KuWLribMldM8kkdEI0DmXJuPumxyudE6780lUYHlGINA+wkycrIXzLALeqjeTiHvVQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787699; c=relaxed/simple;
	bh=Jylt2IqPQ+FjLLYe6vstAU9Vwa01nuN+TKCcEbu5OBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcmSti+fskdcVBd7TjPf3Ym/5ue0eJQ4FWqNoQiq7GuNaPj3z9y8k3aE0lO10bQi7yJUu6kx0gCvLkVtR4VgXmmlDKk6ipM67NPGtCKiR0hgPyXJ5Wu4yCHl1jgWJjVcO+g+NbtfyHURyfQfxFpq0g4KPqUPE/lqiC7sRHWnAJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJTqEex8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJTqEex8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49821F000FF;
	Wed, 30 Sep 2026 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787698;
	bh=MgXmgUFDbNnwX710F4Hyrsa6ZLHQe7QhFOGCqBOS6mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJTqEex8sshrxTPssXiSrjkVUHkCaOQGNBkZuv5tKK7Sdr1fM5R30EoFayDfQTnK9
	 AmuuuXIFs1SRxgzQw0CdAIdU+W7oVAyO5rEJMYzLoz/kNQ8siI5ZdKasNOWDBjQS4i
	 SO9mh4mg3wZc/oAUKHTc+TXLtTw8u842EQwcO7Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 322/457] HID: alps: unregister DualPoint Stick input device on remove
Date: Wed, 30 Sep 2026 17:27:07 +0200
Message-ID: <20260930152352.972955073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit aa9dde93e05a837645fdfd577eea71f0733f0694 upstream.

alps_input_configured() allocates a second input device ("DualPoint
Stick") with input_allocate_device() and registers it, but the
alps_driver struct has no .remove handler and input2 is not tracked in
hdev->inputs.  The default remove path (hid_hw_stop -> hidinput_disconnect)
only iterates hdev->inputs, so input2 is never unregistered and leaks
on every device removal.

Add a .remove handler that stops the device first (preventing URB
callbacks from touching input2 during teardown) and then unregisters
input2.

Fixes: 2562756dde55 ("HID: add Alps I2C HID Touchpad-Stick support")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-alps.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -823,6 +823,24 @@ static int alps_probe(struct hid_device
 	return 0;
 }
 
+static void alps_remove(struct hid_device *hdev)
+{
+	struct alps_dev *data = hid_get_drvdata(hdev);
+
+	/*
+	 * input2 ("DualPoint Stick") is allocated separately and is not
+	 * tracked in hdev->inputs, so the default remove path
+	 * (hid_hw_stop -> hidinput_disconnect) does not unregister it.
+	 *
+	 * Stop the device first so that no URB callback can touch input2
+	 * while it is being unregistered, then drop it explicitly.
+	 */
+	hid_hw_stop(hdev);
+
+	if (data->input2)
+		input_unregister_device(data->input2);
+}
+
 static const struct hid_device_id alps_id[] = {
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY,
 		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_U1_DUAL) },
@@ -845,6 +863,7 @@ static struct hid_driver alps_driver = {
 	.input_configured	= alps_input_configured,
 	.resume			= pm_ptr(alps_post_resume),
 	.reset_resume		= pm_ptr(alps_post_reset),
+	.remove			= alps_remove,
 };
 
 module_hid_driver(alps_driver);


