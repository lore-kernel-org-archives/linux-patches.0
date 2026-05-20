Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC8B43E49A;
	Wed, 20 May 2026 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302352; cv=none; b=JyH+e6z1avB1h0sl7iSiWksqh5ixCNCGcCZczy7h75OfPz6aObGRElgCUh5A8jA0zOA83L55xyZMmUDWrYRRZjVPgoCiUAuUD/1fdaghUChiXNIGqw55YtDjLAbFBeG6+cOmDgg0NbKD0IooO5klovBjqgSQP2/z7Fxjn0wOa1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302352; c=relaxed/simple;
	bh=BC7zEtp1QolM3fca7MPSgpeA8Zwnz9nciH/1fp81MFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEllWLrdvmNcbp46I59orPI2oW7aSN/5aNn4rl1tuWQ6PGYYIcaiDJFvMV4FG1eu4C2oAJ44YKPIFPUkCmvKaR9kAJ32UbNu4J7l5YZEDKwny+r3dWxe+sk5MRNGC67btqQnobmHSXcMZ07JUlyY0bD1vGaM1LLd73UQyKKCRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGAn0tpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGAn0tpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D6C1F00897;
	Wed, 20 May 2026 18:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302351;
	bh=1t9YbWRnDk8vUz9zWfHH0rlYBCvDPdgqp1DIk7EY6CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGAn0tpF9oVkPLRMZYrV4LIkniH3yd0D/yTlvHbOBLF9sJU4qUwOb+TQL3l0VAUkx
	 CpKrOW/tE36AVl43QzRdIA6kbNny2RKVRgRt0oNAzqfDXgWlt/K42hbm26EUrw8X1d
	 sZ6RNDCw89S7pTmbS/Qmp+pnOywcclmyQgMoMbGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/508] HID: usbhid: fix deadlock in hid_post_reset()
Date: Wed, 20 May 2026 18:20:57 +0200
Message-ID: <20260520162103.720849539@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5e3bd615066c1..415d44ac14807 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1549,7 +1549,7 @@ static int hid_post_reset(struct usb_interface *intf)
 	 * configuration descriptors passed, we already know that
 	 * the size of the HID report descriptor has not changed.
 	 */
-	rdesc = kmalloc(hid->dev_rsize, GFP_KERNEL);
+	rdesc = kmalloc(hid->dev_rsize, GFP_NOIO);
 	if (!rdesc)
 		return -ENOMEM;
 
-- 
2.53.0



