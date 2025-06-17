Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461032DFF2A;
	Tue, 17 Jun 2025 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177337; cv=none; b=prjsYJ1wO8hx1DEyZ92Ba+r9wNYgyZPgiib+x7kdI1956v72jEC78qSYNGcmlcmCA/WC+dZ2+4HDUyMHJV5Kl7bJpNT8o1GTIKaRBqMZ1kbAX+Gr6NXu/bBNDefgQ4BoKIp4Q9/z0egvvf1dnQmkt+7MfZ5rzD2fuS4xZC2fue8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177337; c=relaxed/simple;
	bh=euKA2LHtJqnsRImKEfGE8P5+W/lk9MCq5X2KoALPEi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUTxtOFtM5TBIW5heW2pc3/RbUPF3u+WgloL1peWsp9hypN7lwjmnwCnVUdf3MmkrMartLSLYxDn3uRQEtrnMO8xn6MwOOiEYeb25buM6SKUund/f32Y2K24F201kz85vxHdPoo6VGCi0UdySb1Pk1LpQtPr3hkn4poxgrPJVOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck9sVfvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck9sVfvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6823C4CEE3;
	Tue, 17 Jun 2025 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177337;
	bh=euKA2LHtJqnsRImKEfGE8P5+W/lk9MCq5X2KoALPEi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck9sVfvs/qvux+sEAh0Wzm2JpXSkG2hF9xqq0PpnXu8JDVOSHwdBY1ed9N86ujT0R
	 VSumbRAQlAYRQCzZcT4r+maEo7/zubjUoT/OFYk1uQMwAJ7ttArISTNqgtR6JMEkD6
	 2S/l6JqDRWm9KXr3pJRCAGY8SH1c2FRKwsfyQ7SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/512] usb: acpi: Prevent null pointer dereference in usb_acpi_add_usb4_devlink()
Date: Tue, 17 Jun 2025 17:24:55 +0200
Message-ID: <20250617152432.929921429@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 03c22114214b5..494e21a11cd26 100644
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



