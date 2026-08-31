Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A06C592D2A;
	Mon, 31 Aug 2026 13:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184277; cv=none; b=mRKOpSrj0xlKcljDDGJOiQ52lJR7IqpKmC5vEylLbpYYdzLrjXvawnl+e7BFCb1VHH9oK8oxUT84xJdfY20grKQFcG1hna8UwjTEFMTk5pIKSSaHM3bDFEo0ik9IDhN2w3NnwmSP9/oznWSn2TIdqBCH+JTd/l7Qo14HJSnfZIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184277; c=relaxed/simple;
	bh=mCIWpQObiMavMD7PTxT8f0Ca+xbs2NxNCMi/ikpj7Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2VPeAAFAbWyQvSZw7LZUvXFzjc06FxLMmiTaafpoUfTsDpDnNycehfX3lKy/Hent9euQyVaXH7ecma5urlPhLx/9KQWiOvTt0Vb397fFWfa5WJi80OFdOaxxTU40HBC7d/lgemD4Dxsnhul+8CU0mo04wJ455joU0STVvlgFpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA/FQnAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA/FQnAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B761F00A3F;
	Mon, 31 Aug 2026 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184275;
	bh=V4CREAPxBxHjyup9gVJeYokvCy3HfOcQ6akHeuaGfR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pA/FQnAlsjhfxlnC3PegrBpZ9+Jtm76VbQdNnz+BBmzAE0tUuvd+TUNbwLweu7RJi
	 qWlTC0AG0GZcobwmrWK/n1dZ58YfQam3heNFrJzVEs71zUxZkq1I8L+JNbFFAeyoXR
	 cj/92ugCErzAdZIt6IYSSt/WE71rzv8rRSj92tY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 49/99] HID: asus: fix missing hid_is_usb() check
Date: Mon, 31 Aug 2026 15:34:18 +0200
Message-ID: <20260831133402.495036758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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
@@ -664,7 +664,7 @@ static int asus_kbd_register_leds(struct
 			return ret;
 	}
 
-	if (drvdata->quirks & QUIRK_ROG_ALLY_XPAD) {
+	if ((drvdata->quirks & QUIRK_ROG_ALLY_XPAD) && hid_is_usb(hdev)) {
 		intf = to_usb_interface(hdev->dev.parent);
 		udev = interface_to_usbdev(intf);
 		validate_mcu_fw_version(hdev,


