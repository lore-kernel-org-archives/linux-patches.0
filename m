Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F331459F6;
	Wed,  5 Feb 2025 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765363; cv=none; b=rfl7LTJANHFznkcLgHcKrvLrhYT4OnBiWOWdunUiwyRoO8kkEXc3ZA/98563gYRWysh+2zduwZ9N4aew+m1jDMdflOv1kOFpbqNxmcMU2U9mSfjZZ7sU9Q5HA7C1j0BeMEGxWS+awcPHuXtZgzY/gcdD5oYBej5swa3eXUkWAmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765363; c=relaxed/simple;
	bh=xYE9CAWgpNg5k2gbf9peWZHa+atz664j424j2AF3qVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1J6MronkhbkFc+R0pFbJq8jqzbBq7yI6X6OZg4/Aswx23AfKtAhYlSotdcGrEoZ8MzQyzN/0kheRG9aF5ym68wTG8/habJP4ZSkp/kaGY51uFaxVugtvmcdA+srOJywRFKBsHvpVbkEuaiRNh5gRfuKbpZP/SJhvupyt4vyL4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVzZBAcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVzZBAcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C237BC4CED1;
	Wed,  5 Feb 2025 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765363;
	bh=xYE9CAWgpNg5k2gbf9peWZHa+atz664j424j2AF3qVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVzZBAcg/nM+1fUyI1ZtuujPsonRMfeAHQICkyIDkCEEklAoP8hREzfIRKS+6wZ2z
	 VwPbuvjzdwrFn3e1rrepZHHtD0RwBnHpJTL3iN2ZO4ca6ipA7leky6PKW0SAHPbTBF
	 i+7IUTuPiJQ/KjY8Vr1kUKQtEOM5X46d9hX1+o7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+040e8b3db6a96908d470@syzkaller.appspotmail.com,
	Karol Przybylski <karprzy7@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 146/623] HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check
Date: Wed,  5 Feb 2025 14:38:08 +0100
Message-ID: <20250205134501.819891868@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



