Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A87F15442C;
	Thu,  3 Jul 2025 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555262; cv=none; b=Uw12JkC04z5ylMBSUs69rvnuuocVWKtGOxbJLpzzndjzVIBqb8rhQnkeAHhgZFVhk7gaYrlKeGDqOnnMrPkjY5iFFOQ/+FoVrNnSRG5V4Wo1W9Q2ogljPLw6BcsnBVsRrXVSuKdJMxfF9GtM00TrnxVossW3DbUXDPZCo4b4FWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555262; c=relaxed/simple;
	bh=JeDxqnLp6HOKC3nJyVYDPXEJMwA0+WrRp5OqTByLT/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QW2+qG6YGRfDf3Q6IRaNYIlAZfsg+y9ZkN+AqBvH49Pf8tX0ABzFTk4whxH4lKb4qvA9AVJhlwiMAHow+gpUmDEX6to9de5F1whxy2KWO7NPnNFr3lMLB8hN17GlbnY1xT3L7nnRu9EA4gvHXr0nNzZSGTA7NS6cNRM7ndCEGQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9g3hnHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9g3hnHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5978C4CEE3;
	Thu,  3 Jul 2025 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555262;
	bh=JeDxqnLp6HOKC3nJyVYDPXEJMwA0+WrRp5OqTByLT/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9g3hnHpKvwOeUjnFl0QndNaEGz5m2Y0FmSUSpCzwACnjOD3ZjNyKH1ythlbXHcQ/
	 XKNaRRnvnys7hYlYYpn2UhmaLNvYIpiAGKRU6Z0Lb+FFkk5KEYo5N/WK5i3HtK4oij
	 U/3W5pmh5mIUgX+7wKz5H1XkluKzoVzE/ngBedT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.15 193/263] HID: appletb-kbd: fix "appletb_backlight" backlight device reference counting
Date: Thu,  3 Jul 2025 16:41:53 +0200
Message-ID: <20250703144012.096067908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 4540e41e753a7d69ecd3f5bad51fe620205c3a18 upstream.

During appletb_kbd_probe, probe attempts to get the backlight device
by name. When this happens backlight_device_get_by_name looks for a
device in the backlight class which has name "appletb_backlight" and
upon finding a match it increments the reference count for the device
and returns it to the caller. However this reference is never released
leading to a reference leak.

Fix this by decrementing the backlight device reference count on removal
via put_device and on probe failure.

Fixes: 93a0fc489481 ("HID: hid-appletb-kbd: add support for automatic brightness control while using the touchbar")
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reviewed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-appletb-kbd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/hid-appletb-kbd.c
+++ b/drivers/hid/hid-appletb-kbd.c
@@ -435,6 +435,8 @@ static int appletb_kbd_probe(struct hid_
 	return 0;
 
 close_hw:
+	if (kbd->backlight_dev)
+		put_device(&kbd->backlight_dev->dev);
 	hid_hw_close(hdev);
 stop_hw:
 	hid_hw_stop(hdev);
@@ -450,6 +452,9 @@ static void appletb_kbd_remove(struct hi
 	input_unregister_handler(&kbd->inp_handler);
 	timer_delete_sync(&kbd->inactivity_timer);
 
+	if (kbd->backlight_dev)
+		put_device(&kbd->backlight_dev->dev);
+
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }


