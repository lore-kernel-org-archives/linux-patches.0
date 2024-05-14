Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CC64F88C;
	Tue, 14 May 2024 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683822; cv=none; b=Nzf6qJku9gim3DQHh6QvhgaHtAeiUuWNlN+jYBMx73I29N6D9YeFj9tZlbgNahYI8hkhzOPRg/Ypy5z34sgt2rPmcIEquPi+q0RVLD4HRxis9xOOHKeQ5MvqYcDW6oPwBuvHcEMdNain4joTXwrcOrMK8jjJz80nRmjIJTQG/6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683822; c=relaxed/simple;
	bh=Eos4OcCI7g9uJnE92Nu1817+q45HS7whLcyKSLfWgNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0/XjGA0RN+XyXvmzPK1YvAJeV4ui7S6bAStf5HC2UkflVEbdbmaPMRqgFgdT3m7z3EMhYZj5yG/IPUTP+jUgvPEl5ZvPkvnAILr60ZRoIV7z0D0cf3detyrwVFH2sNM31A2ZtS3oB0fKNFkRXtOFiTqTKXBG2WuMKZDV6QAplA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6djCY+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6djCY+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7754C2BD10;
	Tue, 14 May 2024 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683821;
	bh=Eos4OcCI7g9uJnE92Nu1817+q45HS7whLcyKSLfWgNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6djCY+PGvCXr/qeF11cwYQn95ElgsVid+nXdA6eCvjem33nB2+Lm8At0DGmxJrWE
	 9c+gROgWfya3FUkxhIWTL3HdTq42NljDQCksJxRU5L9Tk177ReOCdtZIk9CG7F00Kg
	 M1Lkk2w16s8wOgqu17kgYBSc62OjjUMsraLmS43E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	xingwei lee <xrivendell7@gmail.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Yue Sun <samsun1006219@gmail.com>
Subject: [PATCH 6.8 249/336] USB: core: Fix access violation during port device removal
Date: Tue, 14 May 2024 12:17:33 +0200
Message-ID: <20240514101048.019939558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a4b46d450c49f32e9d4247b421e58083fde304ce upstream.

Testing with KASAN and syzkaller revealed a bug in port.c:disable_store():
usb_hub_to_struct_hub() can return NULL if the hub that the port belongs to
is concurrently removed, but the function does not check for this
possibility before dereferencing the returned value.

It turns out that the first dereference is unnecessary, since hub->intfdev
is the parent of the port device, so it can be changed easily.  Adding a
check for hub == NULL prevents further problems.

The same bug exists in the disable_show() routine, and it can be fixed the
same way.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Yue Sun <samsun1006219@gmail.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Link: https://lore.kernel.org/linux-usb/CAEkJfYON+ry7xPx=AiLR9jzUNT+i_Va68ACajOC3HoacOfL1ig@mail.gmail.com/
Fixes: f061f43d7418 ("usb: hub: port: add sysfs entry to switch port power")
CC: Michael Grzeschik <m.grzeschik@pengutronix.de>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/393aa580-15a5-44ca-ad3b-6462461cd313@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -50,13 +50,15 @@ static ssize_t disable_show(struct devic
 	struct usb_port *port_dev = to_usb_port(dev);
 	struct usb_device *hdev = to_usb_device(dev->parent->parent);
 	struct usb_hub *hub = usb_hub_to_struct_hub(hdev);
-	struct usb_interface *intf = to_usb_interface(hub->intfdev);
+	struct usb_interface *intf = to_usb_interface(dev->parent);
 	int port1 = port_dev->portnum;
 	u16 portstatus, unused;
 	bool disabled;
 	int rc;
 	struct kernfs_node *kn;
 
+	if (!hub)
+		return -ENODEV;
 	hub_get(hub);
 	rc = usb_autopm_get_interface(intf);
 	if (rc < 0)
@@ -100,12 +102,14 @@ static ssize_t disable_store(struct devi
 	struct usb_port *port_dev = to_usb_port(dev);
 	struct usb_device *hdev = to_usb_device(dev->parent->parent);
 	struct usb_hub *hub = usb_hub_to_struct_hub(hdev);
-	struct usb_interface *intf = to_usb_interface(hub->intfdev);
+	struct usb_interface *intf = to_usb_interface(dev->parent);
 	int port1 = port_dev->portnum;
 	bool disabled;
 	int rc;
 	struct kernfs_node *kn;
 
+	if (!hub)
+		return -ENODEV;
 	rc = kstrtobool(buf, &disabled);
 	if (rc)
 		return rc;


