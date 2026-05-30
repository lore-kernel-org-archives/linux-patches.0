Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448CB21B191;
	Sat, 30 May 2026 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166459; cv=none; b=FR9SWHSyb2zWbtFetf3TJnI+KJVAVO1X4zPq+iNDxkT5BZ6tYqz8NE6thE8cgD9VmJ5Oa2VyWQDDAmOBFwnvklHt+n40wVaWoiiGcjAJeGbGPOvAKj8EfEeiS/9fWA0SKeH/SU65cTk+FxawbcuLi4TpDKYdQR0lmv+U4sjkvxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166459; c=relaxed/simple;
	bh=ercHcg/WrUQ/xV2/Ut96R9cbpSpvLtZoqmX0aI25vfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CowM0GzbEeG1VCKSSEtmvGbCo99fq9v2UmrYbWW8CHIZXi4EdL7tk/XRdlfRPZCW2F7Mq19dz/X/lS5JAgBMsAKK2yIeD1pS/xqmMQNgUhOVX/lC0WfSmQbFgbWvn32mcLpqK5zGBHD62EB2nvXiJ0NiWXPlEHn+NoZSkoPnIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsNgdDoI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsNgdDoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9511F00893;
	Sat, 30 May 2026 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166458;
	bh=GDsW+LGnb8OYjRmRq4GVCU/bhwWK/6DhufJgc++G91M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsNgdDoIS0CVyEjA4Pllib22Tyilh0bAlJKwXrCffvW+MT+7t8uWAoaTdBIp6FhPA
	 CAxQ6CV9nQpx3NFeEcx4m0IhQqZmh97YymBws9g1wxYoW6jTVr4U5QY4+zrVoh1oBw
	 ytr/jmPAx5GBYelZ5DGeuwqqIXxSXlcLaQe035sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/589] HID: usbhid: fix deadlock in hid_post_reset()
Date: Sat, 30 May 2026 18:04:20 +0200
Message-ID: <20260530160234.765000705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 03eecfd3692df..7d0eb6c85d851 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1538,7 +1538,7 @@ static int hid_post_reset(struct usb_interface *intf)
 	 * configuration descriptors passed, we already know that
 	 * the size of the HID report descriptor has not changed.
 	 */
-	rdesc = kmalloc(hid->dev_rsize, GFP_KERNEL);
+	rdesc = kmalloc(hid->dev_rsize, GFP_NOIO);
 	if (!rdesc)
 		return -ENOMEM;
 
-- 
2.53.0



