Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93B115492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnU/dubc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EADBC43391;
	Mon, 23 Oct 2023 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060243;
	bh=X8muXMXmqcFuZDHRetO1dq4cpydNRq+EDXkqpwuNw3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnU/dubcqOVP4BwMTs6qUDR9GxiBm+YamzmfU+FUqbh+vlpL67xB5ez0K+HWfdi9V
	 UgHBhRfNQTTDjI86wG7FkLTwMu704Bi7Cr8gAEOyPgctiMAfAF0eN2vvo6XB6NXV3T
	 x0Im9B1AJ3BRO2aoqN765YPnUb/NIalepCi5f5v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/196] HID: holtek: fix slab-out-of-bounds Write in holtek_kbd_input_event
Date: Mon, 23 Oct 2023 12:56:11 +0200
Message-ID: <20231023104831.526562270@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit ffe3b7837a2bb421df84d0177481db9f52c93a71 ]

There is a slab-out-of-bounds Write bug in hid-holtek-kbd driver.
The problem is the driver assumes the device must have an input
but some malicious devices violate this assumption.

Fix this by checking hid_device's input is non-empty before its usage.

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-holtek-kbd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-holtek-kbd.c b/drivers/hid/hid-holtek-kbd.c
index 403506b9697e7..b346d68a06f5a 100644
--- a/drivers/hid/hid-holtek-kbd.c
+++ b/drivers/hid/hid-holtek-kbd.c
@@ -130,6 +130,10 @@ static int holtek_kbd_input_event(struct input_dev *dev, unsigned int type,
 		return -ENODEV;
 
 	boot_hid = usb_get_intfdata(boot_interface);
+	if (list_empty(&boot_hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
 	boot_hid_input = list_first_entry(&boot_hid->inputs,
 		struct hid_input, list);
 
-- 
2.40.1



