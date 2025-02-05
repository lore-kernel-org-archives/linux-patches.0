Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ECEFC0B;
	Wed,  5 Feb 2025 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763718; cv=none; b=TQdIK7zmTwpagbj7pzFZHQIP73YEYhMI4HQNxfjPibQFLArtv5FEGjc8dpAcL4acgywNTzwcsKAyMsz1lIbDQEnp73IW8nGxvccgQwB6UxhxEv7sKQ014ipVRD9TNmBL05MHM9j2KJMHlQgNiZ2E14QSsMM+teuuF3WaNiqCj3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763718; c=relaxed/simple;
	bh=xyi4Ly8C9KUDGfm8LxC0HMfu5AJbpHuSdmqEokxWuy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA4A0fcDa9wxqvPZw3pgb4P0miruzHEsaMEvxHk0kRu+umlAvchcQyyB/lrMJN5J2njbdXf1leDlnM5ohwSQdF6kuYInQDKZJ/RgLFXaPKzSmNQNEGuuKyZzBRDfJWYoQ2Nr+B9fzTNq8i7t2hCV9LBxWS0/couL4K0I0X64Fzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyQ3Ap7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyQ3Ap7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4ACC4CED6;
	Wed,  5 Feb 2025 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763717;
	bh=xyi4Ly8C9KUDGfm8LxC0HMfu5AJbpHuSdmqEokxWuy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyQ3Ap7lVBPTFnCENM9tR0rQ0O73fZ/fcK55UJiIZuOgxfILo7jqmVzS9KvyEcNqv
	 rGhRn+GbxNCPIZVMJg0hCa38F7454QnaW2ZRDhAhj0xkmjBsQ0UR4biH0h08gtCE4v
	 4Gl7C7p+0MCg3nbQqbNBLXQUfGQ/g4W1sNKlqsxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+040e8b3db6a96908d470@syzkaller.appspotmail.com,
	Karol Przybylski <karprzy7@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/393] HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check
Date: Wed,  5 Feb 2025 14:40:18 +0100
Message-ID: <20250205134424.082577592@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Przybylski <karprzy7@gmail.com>

[ Upstream commit 50420d7c79c37a3efe4010ff9b1bb14bc61ebccf ]

syzbot has found a type mismatch between a USB pipe and the transfer
endpoint, which is triggered by the hid-thrustmaster driver[1].
There is a number of similar, already fixed issues [2].
In this case as in others, implementing check for endpoint type fixes the issue.

[1] https://syzkaller.appspot.com/bug?extid=040e8b3db6a96908d470
[2] https://syzkaller.appspot.com/bug?extid=348331f63b034f89b622

Fixes: c49c33637802 ("HID: support for initialization of some Thrustmaster wheels")
Reported-by: syzbot+040e8b3db6a96908d470@syzkaller.appspotmail.com
Tested-by: syzbot+040e8b3db6a96908d470@syzkaller.appspotmail.com
Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index cf1679b0d4fbb..6c3e758bbb09e 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -170,6 +170,14 @@ static void thrustmaster_interrupts(struct hid_device *hdev)
 	ep = &usbif->cur_altsetting->endpoint[1];
 	b_ep = ep->desc.bEndpointAddress;
 
+	/* Are the expected endpoints present? */
+	u8 ep_addr[1] = {b_ep};
+
+	if (!usb_check_int_endpoints(usbif, ep_addr)) {
+		hid_err(hdev, "Unexpected non-int endpoint\n");
+		return;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(setup_arr); ++i) {
 		memcpy(send_buf, setup_arr[i], setup_arr_sizes[i]);
 
-- 
2.39.5



