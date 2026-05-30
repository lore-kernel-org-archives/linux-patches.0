Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4BA39A4A4;
	Sat, 30 May 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161414; cv=none; b=NIcPvi7s5JoHUN8usQJjoY3BjwFXEvAF6K0ePgET1IsV+Q0me4WNze3ZidL2F4SIRWhgYy6u6+uGLoCBAEc0dLjHH8pYOXnq6QpHl0UqYwC3DP26Uia992Yv7GJCtv71OpNZ8vY6ljLU1ivgmvq9+80IBrymbDb5WEt+14CnPKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161414; c=relaxed/simple;
	bh=mTnjsGuQ6TEZtLNJitQKDT8Z5ksHuUwLvsgb8Gz4U8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5YVDq4SaKIYTZJIyXI17UCHj140iylK7IMIfZlOoUNwt+BBWwRomvOlc2JE7VrVV+qUuap8SM5tvpbOb7wICoW08tZ6gEa7PZf5ix0o1S5pIB2mhzlRa9CdhN99rjMIAq2v18AaVpZbfKZPCfvzbQzxCnF0AYpQPJg+y/0mJKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=do8SwI35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="do8SwI35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4801F00893;
	Sat, 30 May 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161412;
	bh=EEYJCYLC4KcgF9cdvR1cm3o+IMF7oty5G0IwZejQqns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=do8SwI35mS7dnj9eSC6dYfJDjqKZvjmsObEXtcqKZ8mvfXTAi4rdf09z88/rDmkhg
	 5zFpk6vfi7PXPXMQkvGd8QzQxJYS0ArE1ijb65P6SluF8cZfLfLoavwaNUC5QOGabA
	 HTHG+WvnTvRY7SrKfTa7hdXvoYGeK6vd7dEln6Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 617/969] HID: usbhid: fix deadlock in hid_post_reset()
Date: Sat, 30 May 2026 18:02:21 +0200
Message-ID: <20260530160317.472291232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 8df2c1b47ee3cd50fd454f75c7a7e2ae8a6adf72 ]

You can build a USB device that includes a HID component
and a storage or UAS component. The components can be reset
only together. That means that hid_pre_reset() and hid_post_reset()
are in the block IO error handling. Hence no memory allocation
used in them may do block IO because the IO can deadlock
on the mutex held while resetting a device and calling the
interface drivers.
Use GFP_NOIO for all allocations in them.

Fixes: dc3c78e434690 ("HID: usbhid: Check HID report descriptor contents after device reset")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 352c9327d08b2..ccf0aad99a4b9 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1544,7 +1544,7 @@ static int hid_post_reset(struct usb_interface *intf)
 	 * configuration descriptors passed, we already know that
 	 * the size of the HID report descriptor has not changed.
 	 */
-	rdesc = kmalloc(hid->dev_rsize, GFP_KERNEL);
+	rdesc = kmalloc(hid->dev_rsize, GFP_NOIO);
 	if (!rdesc)
 		return -ENOMEM;
 
-- 
2.53.0



