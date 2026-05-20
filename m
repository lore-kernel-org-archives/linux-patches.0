Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D8F34216C;
	Wed, 20 May 2026 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295940; cv=none; b=GNVdi+mAo9OtK7kJRO/LGd3VNg0IV/1EIXHF9ex5hAOZkE9whfFe+5c/5gK06hXljJzk2A2eFyaOENcISf7RtQ6lVdCA6H3oL0WPlq7ozBMm/eybbT4cC9guzn6vgCdyTuowhD6M8Pe8yLbrMDNn+v0j2BTpAWvevawpwGpG0BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295940; c=relaxed/simple;
	bh=uzGnTqgWxVpZdo9KuIZj0XHRrwFapXHlUsVrvFaBgik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtj8H7mDJY7FFuXanvNua55mXvIhaqw5NLXtf4Lj4BagDT+RWkNG4Q7HksCUunkU+d8sRKR5cyEJ4dSn0/JaLuTqGlMPaa46q8h4DWrflNLZFuRimpt21OKCcf7UeLOTyzqUgBRoCHafFeBb2+G4jqDMRPSvT7ORWIb5EPfMplA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Itgo6hx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Itgo6hx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A001F000E9;
	Wed, 20 May 2026 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295939;
	bh=Mj/VG0c1zd0FsA2Ce+l7x+qpWxjcTewRRCN/E66rib0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Itgo6hx2M2af/JWpLez7xM7rBVAWw9wtY+zpzHLUixivIpxY9x/CUCvyA5hMHeM6f
	 1fFzqBdnNQTAWwNcECxYT85qNFwcMrJ5zHC8jqZNmJv5IyqorHdZVvlJ8rz1/9cQaK
	 bnapi7pSW2eGXMnqrFLz9MJd8LATV9mh+BiAkuoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0603/1146] HID: usbhid: fix deadlock in hid_post_reset()
Date: Wed, 20 May 2026 18:14:13 +0200
Message-ID: <20260520162201.826732610@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index ddd5d77fb5a5e..fd3e1aedc5cbc 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1552,7 +1552,7 @@ static int hid_post_reset(struct usb_interface *intf)
 	 * configuration descriptors passed, we already know that
 	 * the size of the HID report descriptor has not changed.
 	 */
-	rdesc = kmalloc(hid->dev_rsize, GFP_KERNEL);
+	rdesc = kmalloc(hid->dev_rsize, GFP_NOIO);
 	if (!rdesc)
 		return -ENOMEM;
 
-- 
2.53.0



