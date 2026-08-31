Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9A1463B7B;
	Mon, 31 Aug 2026 13:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183967; cv=none; b=thHduvq/xiosp0cdEH5zPkwq9VmNO/qvoOyzy4Si61eNyw71WG4oDREO9iUtL4RxHFWHaybJl29wMMiYq2+1wFSYpUm1Ofj61xy0OzNXoN3ig6L0U3gOCnuHVv5GTxETyfcNfTguxBI7Ow2qQbl8so2oO2AH5RBw5pgwXZyoEhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183967; c=relaxed/simple;
	bh=FL+lVRyhKw+vj45B2ZhLBTzLqCyOsTUl3G416ZAYY1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb3DQeDy0qICUoblrKIhANe3kN8ZG05hJvxrwUfaC7sJ0MSZldXOP3Q+d1v5h+Hgec0V6E13TTcmMTAShHWt4Ac1nuqT9tlK4hTAFijL3LIa4lGFdswe6KP7/iDxCGBF/vWr5rJEAfEhFJwc/LJSXWVetPSgrEPGbc1wnrl5uMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmRQQvuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmRQQvuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC6B1F00A3E;
	Mon, 31 Aug 2026 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183965;
	bh=6cOC49MW7oX04LV9KlVB1ZV/zg9/TLaPtzBbLKBzynk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmRQQvuoeTpJC91m+26y2hJKhR5YHeRE2gSVihVJth1CAAmhoQfheHfLT0KL3bgn1
	 f8lqRKbItkxFAeflgJrzQFn8AhrSw1pqvQy42qJn5dfc8DQYDhRBYDsi8nrTTQs95z
	 v9kh6lyeyvJVZwDDMrSrkOVJjGH7LmksAq56UH7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 26/83] HID: asus: fix missing hid_is_usb() check
Date: Mon, 31 Aug 2026 15:34:02 +0200
Message-ID: <20260831133400.661186113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

[ Upstream commit 02bf61dfb44f17ec187d1da1a82495951bbd12df ]

to_usb_interface() can only be used on a hid_device whose parent is really
USB; uhid can create devices that identify as being on BUS_USB, but don't
actually have a USB parent.
Fix the use of to_usb_interface() without a hid_is_usb() check.

I have verified that it is currently possible to trigger a kernel splat due
to this bug in an ASAN build, and that this commit fixes the issue.

Fixes: 00e005c952f7 ("hid-asus: check ROG Ally MCU version and warn")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -667,7 +667,7 @@ static int asus_kbd_register_leds(struct
 			return ret;
 	}
 
-	if (drvdata->quirks & QUIRK_ROG_ALLY_XPAD) {
+	if ((drvdata->quirks & QUIRK_ROG_ALLY_XPAD) && hid_is_usb(hdev)) {
 		intf = to_usb_interface(hdev->dev.parent);
 		udev = interface_to_usbdev(intf);
 		validate_mcu_fw_version(hdev,


