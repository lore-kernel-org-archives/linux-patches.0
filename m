Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520DF3D88FE;
	Wed,  8 Apr 2026 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671635; cv=none; b=FczPBI4tHkYOeJJ0FgYIi8JvqzJrscmAiyaWadv4ZXuVFRvwq3oYHAHaZJfIl06m6ALPsH/cLO6eSP8rYVV+q5EyXKtgnrNG9rgA1GIxS6MxJmPXK6OfNEp7Whd4uizm7Ko++CYf+2ypISzgs9XqCWj1DUlDETwrOhCiJ5mI2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671635; c=relaxed/simple;
	bh=ZMBLtUc+HWu5n8GVvQvrfPN0QRC2WYCyNG5KqCEZLxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kvkdy/9WW7+Wz4fE9elU8cnzzTWk5t4Q7AoUdIQFx3Jjh43jOua8tDv0MkAx8YFEJnBFXjg/6fFjoYwKIUvnIjIRx+peZ9d27OIhbTK7kk3JmGqDT63McEyuklQJmacReb3BoqAzQL6LzN3FRl7l4cBwnoXnFCZU2AdMXV4f2/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8AGW18z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8AGW18z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBF1C19421;
	Wed,  8 Apr 2026 18:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671635;
	bh=ZMBLtUc+HWu5n8GVvQvrfPN0QRC2WYCyNG5KqCEZLxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8AGW18zZ3tWo7lB9a53MJ0b6ds+n51fhS/PZdrr//UHCXTWzdWXu2JrV9tQWZA6Y
	 WIXOMxeQXq/mkNKLqo4sMJskCMXnyqHnp++zVyG/FUokrDxAh4/Uo0B0rMdA3SFnKT
	 zFsytwsnXzSN3upIoZqe+OFkby5WVxynQE8GR9ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Lehmann <lehmanju@devpi.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/312] HID: magicmouse: fix battery reporting for Apple Magic Trackpad 2
Date: Wed,  8 Apr 2026 19:58:47 +0200
Message-ID: <20260408175934.111690346@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Lehmann <lehmanju@devpi.de>

[ Upstream commit 5f3518d77419255f8b12bb23c8ec22acbeb6bc5b ]

Battery reporting does not work for the Apple Magic Trackpad 2 if it is
connected via USB. The current hid descriptor fixup code checks for a
hid descriptor length of exactly 83 bytes. If the hid descriptor is
larger, which is the case for newer apple mice, the fixup is not
applied.

This fix checks for hid descriptor sizes greater/equal 83 bytes which
applies the fixup for newer devices as well.

Signed-off-by: Julius Lehmann <lehmanju@devpi.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 99d0dbf62af37..bb725dfcef196 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -963,7 +963,7 @@ static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	 */
 	if ((is_usb_magicmouse2(hdev->vendor, hdev->product) ||
 	     is_usb_magictrackpad2(hdev->vendor, hdev->product)) &&
-	    *rsize == 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
+	    *rsize >= 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-- 
2.51.0



