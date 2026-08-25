Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7457A47143A;
	Tue, 25 Aug 2026 13:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665318; cv=none; b=Myd8dyrhJcxgKVZOAvTBRNEhgOefJK0VbNSrRNdjNlgyJ3/DY0QGHQiYmmswD2GV/pveW76/MIJkd/abPPCGdw8UMAcDo+lZPdvxha68KfJ6JxoUfWDYRaZb90riwraTZftEHBCBqPWSkZ/80/SriRqDeDA23XnWEW9x2+ej60o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665318; c=relaxed/simple;
	bh=hILbwkwFHRCCrNs7TbdwRzII1O6XJ+5XpOlmdayYQz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8v23FPGIwM8gL45wQ4PLZe3Yf4Xye0Z1ygalYLCYg3vQn2JcHoUMcIr0rOprtZqRLjM6Ham2Rj97U5Xjj85dj7HkSFr1vW+GMntONg6tQaWpnO3NYJPaqgg8XATdGlsPep+OK8dvgfWwEDeElRdRrZWdCLuaW31ZfbIcvjWYgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNiz/nns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNiz/nns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69471F000E9;
	Tue, 25 Aug 2026 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665317;
	bh=n13bjIkGX7Jb1tNdO6ym6oMsYTRh+DOD9WbmQx0Hz8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNiz/nnsB4Mhora44cvkCGcjX3m/8nebZMkQ0ie4r/Rnv8qFZ+Tq2ckH4q6jCXTO7
	 hdr6X1oeEX276KZ8rOSSKpJb55m+zhXLRO1XF6GhG4BR+apzyq6doRajfzaTjYxRsK
	 mK9dV6rSj2muRhCMS+1zuE7lHl8ulBHC7HrNdbA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 81/94] HID: nintendo: register input device after capabilities are set
Date: Tue, 25 Aug 2026 15:26:17 +0200
Message-ID: <20260825132545.029992914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2138,10 +2138,6 @@ static int joycon_input_create(struct jo
 	ctlr->input->phys = hdev->phys;
 	input_set_drvdata(ctlr->input, ctlr);
 
-	ret = input_register_device(ctlr->input);
-	if (ret)
-		return ret;
-
 	if (joycon_type_is_right_joycon(ctlr)) {
 		joycon_config_right_stick(ctlr->input);
 		joycon_config_buttons(ctlr->input, right_joycon_button_mappings);
@@ -2181,6 +2177,10 @@ static int joycon_input_create(struct jo
 	if (joycon_has_rumble(ctlr))
 		joycon_config_rumble(ctlr);
 
+	ret = input_register_device(ctlr->input);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 


