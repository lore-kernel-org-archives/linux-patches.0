Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1237A288C96;
	Wed, 28 Jan 2026 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614233; cv=none; b=eDZOa+z3hXcFlAqWzm0RbXek0ILD/HtPEQcq7g5qxlxov1saLOgfGtaJeCVbJHc3lpvRWP31k6CnyryX8AP4onAnqywzZCtwcB2dM+FH+v0DcmmPkZwXiAtiBHJj0+UaP60kkSK9uSuq74/ANg5u6s1FP78mcAPvKqOYZgfNiFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614233; c=relaxed/simple;
	bh=IAq+AtEq39md4OzDCNZ5CG76lUna5w3JXJTnzTTXZCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyp1aTilQyezRCQUwaUkkUrDgJVLth4LeFEOsHSo2HXVnX9gk5OM6McYdPc5ckzhD4SFAjYplbAVcoLwywuFSxTbMabeDz90RqUnoOwBN8sgCWTHq5jfRg+2EUpbzWmW+a+uq3MOMZlfZUbFR7naj6GNThwmZyTaiPVk7qukU7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiiMgEiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiiMgEiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7979EC4CEF1;
	Wed, 28 Jan 2026 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614233;
	bh=IAq+AtEq39md4OzDCNZ5CG76lUna5w3JXJTnzTTXZCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiiMgEiAMmVNymYiKPnULLCCQ14qBhmRCjhhjO1LLAZjuottnlwk8HHnThx75JsTr
	 iR2CzfDSnG4/7DDwbiaDfy1+NcL6JfQfq03uA9n8J5YZPsvfKVWnf7gP3vfnEKXnVw
	 aM5AuWg+FKuZtweGGkNB2wfDLbSppSIrD/Ag/Z24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.6 043/254] HID: usbhid: paper over wrong bNumDescriptor field
Date: Wed, 28 Jan 2026 16:20:19 +0100
Message-ID: <20260128145346.251619014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Benjamin Tissoires <bentiss@kernel.org>

commit f28beb69c51517aec7067dfb2074e7c751542384 upstream.

Some faulty devices (ZWO EFWmini) have a wrong optional HID class
descriptor count compared to the provided length.

Given that we plainly ignore those optional descriptor, we can attempt
to fix the provided number so we do not lock out those devices.

Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -983,6 +983,7 @@ static int usbhid_parse(struct hid_devic
 	struct usb_device *dev = interface_to_usbdev (intf);
 	struct hid_descriptor *hdesc;
 	struct hid_class_descriptor *hcdesc;
+	__u8 fixed_opt_descriptors_size;
 	u32 quirks = 0;
 	unsigned int rsize = 0;
 	char *rdesc;
@@ -1013,7 +1014,21 @@ static int usbhid_parse(struct hid_devic
 			      (hdesc->bNumDescriptors - 1) * sizeof(*hcdesc)) {
 		dbg_hid("hid descriptor invalid, bLen=%hhu bNum=%hhu\n",
 			hdesc->bLength, hdesc->bNumDescriptors);
-		return -EINVAL;
+
+		/*
+		 * Some devices may expose a wrong number of descriptors compared
+		 * to the provided length.
+		 * However, we ignore the optional hid class descriptors entirely
+		 * so we can safely recompute the proper field.
+		 */
+		if (hdesc->bLength >= sizeof(*hdesc)) {
+			fixed_opt_descriptors_size = hdesc->bLength - sizeof(*hdesc);
+
+			hid_warn(intf, "fixing wrong optional hid class descriptors count\n");
+			hdesc->bNumDescriptors = fixed_opt_descriptors_size / sizeof(*hcdesc) + 1;
+		} else {
+			return -EINVAL;
+		}
 	}
 
 	hid->version = le16_to_cpu(hdesc->bcdHID);


