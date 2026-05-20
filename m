Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476FE3FBB4D;
	Wed, 20 May 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300929; cv=none; b=doRTLAVFyWzHlSl39XuuVsV2N5ex8ypajZnKuGCWV68bxtJNfswfZ+V1udbBYE4BvdELG9AUSuLH0CsGTmnCr5PVwfrHcRq7zOgI4qBBNll6/jTRPqqfD+E4AKdUCCMMivg/egfsbnCZFv6arYDH9+nlKMqEBOZ7hrnxiR9opHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300929; c=relaxed/simple;
	bh=El8UaZcPPGtl4RYylDoPCjFxw6HwSc4fDriKFHCR0Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGTcnQjpZxx7PcIjyWov7f6Z5DEtknHNax1ODfu4q13pQh2uCtN9sceXPh8VYK48hEkPRo23uU4WvVR+r1sRkeaE9t+LT236jXb7lxCTA3hOLJ4jmTyzEljIu3fguHqWK6GNTjzNiCkg5hOn7FaEylEVIHjPnuDo5RXSoX7mrUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki2UFXTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki2UFXTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630F91F00894;
	Wed, 20 May 2026 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300924;
	bh=c5+3JoSJoDlT/POJ/HDZbERY35kFq3NOO3M6lPJeUTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ki2UFXTthOAG12YhEUVVDxplx1vUst/GCJaC3h7TjMWA/MKCIJVk3wHoX4xA4gE4X
	 moHXkkA3YsiyspsuLCixvtLs01djpel0eMcOB/pqMW/WrpdB6n2p3QOnPrMpMv6OhX
	 nhrKy0u94NzLUZecPTjpODMHTyVFLqve03wrf8qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/666] HID: usbhid: fix deadlock in hid_post_reset()
Date: Wed, 20 May 2026 18:19:14 +0200
Message-ID: <20260520162118.666599009@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index a2c5a31931f69..f14b46ce00cb6 100644
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



