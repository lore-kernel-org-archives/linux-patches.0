Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615198F54;
	Tue, 17 Jun 2025 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178685; cv=none; b=A0jOWpbcRtdImOyJbCtvXuqmjpY26t+X3BPxpJ+KlxEIqaGVuljVtphZJoRhSpKV+nQD5t2CFMKeNhxatlncN69wuibC2obQySkp6hL3t1NRkubc+z+FKAy3//myzF8det573xXWOPEOaRz5KUKLTnlLPKoy3DRBgdPVETYbpgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178685; c=relaxed/simple;
	bh=NdFoKe9IvmBmZfPtCJVrhbeSBPZv3U9cc9rI2nJiROo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOX9LhMqewl+iCIhr2Zkzqph6JYm9uPWHFyteqct2M8aggJHPhTigp6NQxY0tvJEcoA8VLj1xrue0pmWzxjyT0SfPjAfGYl+X3RRluFkfa9QhYiYPTnrpOv9vv3fwgPzZVmGffv7xM8lkEVLvMaoXxrCSJQOWc36TjiL8FXdIw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWyZADi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWyZADi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CF9C4CEE3;
	Tue, 17 Jun 2025 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178685;
	bh=NdFoKe9IvmBmZfPtCJVrhbeSBPZv3U9cc9rI2nJiROo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWyZADi2ATchfVr7+F+SEdmrfteE49EcPSTYH5P4v8GrTttRIDdHQpu2azjoW8fe4
	 VdpdsXPoPIDBQ0p0Tk36KWrg3Sd9peVpP/aR6FzlE0kSwWXmXBnWW5HqbrNnTo7AVr
	 qzLCOG2Lfh21SWq0fDcqQwCqfoXQDKI0qEhMYN/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 523/780] usb: acpi: Prevent null pointer dereference in usb_acpi_add_usb4_devlink()
Date: Tue, 17 Jun 2025 17:23:51 +0200
Message-ID: <20250617152512.813106021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 73fb0ec9436ae87bcae067ce35d6cdd72bade86c ]

As demonstrated by the fix for update_port_device_state,
commit 12783c0b9e2c ("usb: core: Prevent null pointer dereference in update_port_device_state"),
usb_hub_to_struct_hub() can return NULL in certain scenarios,
such as during hub driver unbind or teardown race conditions,
even if the underlying usb_device structure exists.

Plus, all other places that call usb_hub_to_struct_hub() in the same file
do check for NULL return values.

If usb_hub_to_struct_hub() returns NULL, the subsequent access to
hub->ports[udev->portnum - 1] will cause a null pointer dereference.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: f1bfb4a6fed6 ("usb: acpi: add device link between tunneled USB3 device and USB4 Host Interface")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250417195032.1811338-1-chenyuan0y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/usb-acpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 935c0efea0b64..ea1ce8beb0cbb 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -165,6 +165,8 @@ static int usb_acpi_add_usb4_devlink(struct usb_device *udev)
 		return 0;
 
 	hub = usb_hub_to_struct_hub(udev->parent);
+	if (!hub)
+		return 0;
 	port_dev = hub->ports[udev->portnum - 1];
 
 	struct fwnode_handle *nhi_fwnode __free(fwnode_handle) =
-- 
2.39.5



