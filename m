Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DDE429822;
	Tue, 21 Jul 2026 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657919; cv=none; b=aeWPajO9U3OY+vQYa6Z3R4LxsbvMbZjV65vYxO6wHaBB3KDM00wh60vwLClHJIe24cPf3LCaaGGIkn8ZkzxtzTBj9xkTYL2aoaTrIEwUtQ9vKvtoPwrO9uNocBjyRYhYbEZJWnQWsZr5zDhJdEjoJBKNtLnB+qRNKdSJx6RHF+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657919; c=relaxed/simple;
	bh=OKXFjFDuNDsZGWlSZbhHtQlIakE37Iia3RpKe86ade8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRc5MPDAdfcOo1e14qmYQ3/IieSwIPRXsPM7wIbEP9huh4YjBX4mi7BqTClhz6DzEafYjIPEA/MYq+Jw3Y+6y5LYvmvHD3inLL+KqIM2gWK6vayqoSavodrPOiwipSD3qmtwDHV6vUS/nu+hH02aOgkdRgv0yvUF9bzZw8q7Wuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlaEc1b/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlaEc1b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07291F000E9;
	Tue, 21 Jul 2026 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657918;
	bh=n0iIo3jSQphOHEoN4DHYISQ2CuIKnzC8fLI4yM3+J94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlaEc1b/A4QOHW1Z0jqvvUL8viM22/M0W7gaxN/Ugo96sO0Z5K2/Pro6gEkoxyUBr
	 Xkmaw6ql1Kh53mCo3kwJBRgjWlxfnzbu8WYHijXYyYOx7Pi4lzavDqaCLs2JFHNhh1
	 aH7+JXvlYwN1gGj8tq36zR2WDG16vMKkANMHeooM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0947/1611] ALSA: FCP: Fix NULL pointer dereference in interface lookup
Date: Tue, 21 Jul 2026 17:17:43 +0200
Message-ID: <20260721152536.688943859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit e1e31e0ec8a609e17fd2e86b77bc00d9cbb24d7c ]

A malformed USB device can provide a vendor-specific interface without
any endpoint descriptors. fcp_find_fc_interface() currently selects the
first vendor-specific interface and reads endpoint 0 from it, without
checking whether the interface actually has any endpoints.

When bNumEndpoints is zero, no endpoint array is allocated for the parsed
alternate setting, so get_endpoint(..., 0) yields an invalid endpoint
descriptor pointer. Dereferencing it through usb_endpoint_num() then
triggers a NULL pointer dereference.

Skip vendor-specific interfaces that do not have any endpoints.

Fixes: 46757a3e7d50 ("ALSA: FCP: Add Focusrite Control Protocol driver")
Reported-by: Jiaming Zhang <r772577952@gmail.com>
Closes: https://lore.kernel.org/lkml/CANypQFb1EHj0xX8bA1WxSOSK-5xca6ZNKzOQcp12=s=puY7VFw@mail.gmail.com/
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Link: https://patch.msgid.link/20260625134933.425785-1-r772577952@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/fcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/fcp.c b/sound/usb/fcp.c
index 11e9a96b46ffe5..6eab5cd0cd3587 100644
--- a/sound/usb/fcp.c
+++ b/sound/usb/fcp.c
@@ -1083,6 +1083,8 @@ static int fcp_find_fc_interface(struct usb_mixer_interface *mixer)
 
 		if (desc->bInterfaceClass != 255)
 			continue;
+		if (desc->bNumEndpoints < 1)
+			continue;
 
 		epd = get_endpoint(intf->altsetting, 0);
 		private->bInterfaceNumber = desc->bInterfaceNumber;
-- 
2.53.0



