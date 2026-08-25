Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08E3C276D;
	Tue, 25 Aug 2026 13:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665564; cv=none; b=W3cxQOlQVLeUSJkS+/SeEhRTrA7J/qCdBSGAwcXcVh/kmSe3c3HAh2IeQXZKWGzjCPyE7Nhu12Yn+uGm67qp6k6AZjfkqv3gE111Ygh4qV3opN8z+aJ4C6WXSxZAgf9GR4P9zjlugeHB+ufeskTf+d+8Ub0saFw9ymrCUz+oBKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665564; c=relaxed/simple;
	bh=+gCO1gJTMJadw8R6FEuLpYgaYiJeMySLaAE2qp+FLlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa/zB+/XuMpy7Jzdv6NsD5BU1SpgaMZ738qaeaHqeRTuGE+ZiVx/21SttS3z8fbMVUEknUhpbL6uXR4W9i0RLAq8eLXvtuuUzBvTRVdasaC5gRqLOCzyNkJrhgfHPryry92rRpNHY3Onqe5nEMd1FdILZODtccj3mblK0krvmGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAFcKJZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAFcKJZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D971F000E9;
	Tue, 25 Aug 2026 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665563;
	bh=P4GmzObNLZ7MfjrByE3/iMux5jW+0WKIhYkH3wmRIEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAFcKJZAJtmca7oXPlRdt5ieT5OYiYMMZEbpCcbpSjd8oea8HeTAoZP1+BNtd5unM
	 cozTtjptgMmc77lke6M98s0zsGcJgQknauEUyDZJxmf60jQ3LsCr/CgYohLmfHsULh
	 iAqWxUUbelNsY60dcHg6RKHCpBO/Ht2ryEK4bjNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 69/77] HID: nintendo: register input device after capabilities are set
Date: Tue, 25 Aug 2026 15:26:31 +0200
Message-ID: <20260825132544.227590782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2142,10 +2142,6 @@ static int joycon_input_create(struct jo
 	ctlr->input->phys = hdev->phys;
 	input_set_drvdata(ctlr->input, ctlr);
 
-	ret = input_register_device(ctlr->input);
-	if (ret)
-		return ret;
-
 	if (joycon_type_is_right_joycon(ctlr)) {
 		joycon_config_right_stick(ctlr->input);
 		joycon_config_buttons(ctlr->input, right_joycon_button_mappings);
@@ -2185,6 +2181,10 @@ static int joycon_input_create(struct jo
 	if (joycon_has_rumble(ctlr))
 		joycon_config_rumble(ctlr);
 
+	ret = input_register_device(ctlr->input);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 


