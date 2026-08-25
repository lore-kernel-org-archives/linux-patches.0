Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B827725A655;
	Tue, 25 Aug 2026 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664727; cv=none; b=bgIva3b7n0pHu8j9QfmFCHSDek5iRMdWb49RB4VUMZwQDHv2SQKoydJrsi53c6jXD5rDRjOOxIW+1dJ7/FpThSZhBIrUwAIFVYy8SLP3LaPyAWLpqAGF0PnMBWgzc01YM2aa4iaof/ksMv5T+jxgWXFrM7NyO9gdvpbSzkvk/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664727; c=relaxed/simple;
	bh=Y3YFRB2Z2MjcqMNphcs1vsecM8+QcKFvlFlnl7rir8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhKmryGJefqJfJgpY9Nqo0AA5PdjRje23OnQxEh5qebTRgugxPtw5nH7nFnkhL6T5+V44101cxQraKyrvracHY/EPsOZ4IuD95jbNzBGVo7ahBbr5ez0We9PBgf5a2j58MOKFMuGlhmZ+mSn+lbfzOYyyAbSLBH/7v7y0wNh+cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyZtXBbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyZtXBbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C071F00A3A;
	Tue, 25 Aug 2026 13:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664725;
	bh=qJcR2W9QSgoirNbFhE/b94SHlFUr60AJ4D+dcjWSVko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyZtXBbei2xkRhRHImv5WONWtbedaBgLMwxQlbyapiEnXHVv7xhBhxv/HUD0M1H5g
	 H2FmqBt6CkeZividg1uDmKIVdKUpmexCZyPIpisGSyqjYGa/Lo1bbKeLuptrDZijpI
	 +Aa1o/QUGu2CxZbkSJy/Nrq/GkHbegY4UU5sxaEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 66/82] HID: nintendo: register input device after capabilities are set
Date: Tue, 25 Aug 2026 15:25:53 +0200
Message-ID: <20260825132544.089905437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit d723bc1fe2e72b9252234e94c11af644ec477bf7 upstream.

input_register_device() exposes the device to userspace immediately.
In joycon_input_create() it was called before joycon_config_rumble()
configures the FF_RUMBLE capability and the memless force-feedback
device, so a concurrent EVIOCSFF could dereference a NULL dev->ff.

Registering early also means the initial udev event lacks button and
axis information, which can make input managers ignore the device.

Move input_register_device() to the end of joycon_input_create(), after
all capabilities, the IMU input device and the force-feedback callbacks
have been configured.

Fixes: 2af16c1f846b ("HID: nintendo: add nintendo switch controller driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260730031927.25444-1-yijiangshan@kylinos.cn?part=1
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://sashiko.dev/#/patchset/20260730031927.25444-1-yijiangshan@kylinos.cn?part=1
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-nintendo.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2162,10 +2162,6 @@ static int joycon_input_create(struct jo
 	ctlr->input->phys = hdev->phys;
 	input_set_drvdata(ctlr->input, ctlr);
 
-	ret = input_register_device(ctlr->input);
-	if (ret)
-		return ret;
-
 	if (joycon_type_is_right_joycon(ctlr)) {
 		joycon_config_right_stick(ctlr->input);
 		joycon_config_buttons(ctlr->input, right_joycon_button_mappings);
@@ -2208,6 +2204,10 @@ static int joycon_input_create(struct jo
 	if (joycon_has_rumble(ctlr))
 		joycon_config_rumble(ctlr);
 
+	ret = input_register_device(ctlr->input);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 


