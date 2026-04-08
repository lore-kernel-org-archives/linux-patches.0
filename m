Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE5C37DE90;
	Wed,  8 Apr 2026 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674835; cv=none; b=mcHIY5Gn6CiB+evSsyrajqp30Nk5DL+fHNYXKSovcLbb2FtEGkD6YVLdE4ZFsOmlu9vsovy8yWEV3pl5ck5BGoVPE6s+R+qtqOFT3VLOw/lg+GTfIjL5Sf/sgvsYG+9QMSOZ9bQqLcFGavgoCdlWUQYYh84GJ5fclm01zVgruSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674835; c=relaxed/simple;
	bh=GLCG23flSVefV/JxyfRHYGsQpb4VA3b0MWtCyWmWo/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFT6kbjijf2/cOEzICMQuqTRxM1mvN+VGTEAW0SqMFD3vVdl+6OtlP6gwcVxMT6G5TC0wwow128y/AGdXKXDR4DKgnpDuqi/hsln6AVvL19qfz3+bLhpdyC/LGgK2kmgh7/Py5/+73i+ZaJWzt6JtvF5vcGEOOHDmmEDjoqcXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqKQbBHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqKQbBHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038D2C19421;
	Wed,  8 Apr 2026 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674835;
	bh=GLCG23flSVefV/JxyfRHYGsQpb4VA3b0MWtCyWmWo/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqKQbBHUgXnJUZ6lVLqrpc2kQx8S5Qm8081MJDVvKy47oVljnrdVv/Pazf+Y8Lx6B
	 QvQZ4Mrs0FaU7laQhthZl0+ynQWe/j8bLGvn/hnS6o3z+ktoyxWRKBHLPJsU6KIXfQ
	 SQRyprQvc++7cl6BrJDvrQ+R0hDrFPQr7JuXVko4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 252/311] cdc-acm: new quirk for EPSON HMD
Date: Wed,  8 Apr 2026 20:04:12 +0200
Message-ID: <20260408175948.799278766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit f97e96c303d689708f7f713d8f3afcc31f1237e9 upstream.

This device has a union descriptor that is just garbage
and needs a custom descriptor.
In principle this could be done with a (conditionally
activated) heuristic. That would match more devices
without a need for defining a new quirk. However,
this always carries the risk that the heuristics
does the wrong thing and leads to more breakage.
Defining the quirk and telling it exactly what to do
is the safe and conservative approach.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260317084139.1461008-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    9 +++++++++
 drivers/usb/class/cdc-acm.h |    1 +
 2 files changed, 10 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1225,6 +1225,12 @@ static int acm_probe(struct usb_interfac
 		if (!data_interface || !control_interface)
 			return -ENODEV;
 		goto skip_normal_probe;
+	} else if (quirks == NO_UNION_12) {
+		data_interface = usb_ifnum_to_if(usb_dev, 2);
+		control_interface = usb_ifnum_to_if(usb_dev, 1);
+		if (!data_interface || !control_interface)
+			 return -ENODEV;
+		goto skip_normal_probe;
 	}
 
 	/* normal probing*/
@@ -1748,6 +1754,9 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x045b, 0x024D),	/* Renesas R-Car E3 USB Download mode */
 	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
 	},
+	{ USB_DEVICE(0x04b8, 0x0d12),	/* EPSON HMD Com&Sens */
+	.driver_info = NO_UNION_12,	/* union descriptor is garbage */
+	},
 	{ USB_DEVICE(0x0e8d, 0x0003), /* FIREFLY, MediaTek Inc; andrey.arapov@gmail.com */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -114,3 +114,4 @@ struct acm {
 #define SEND_ZERO_PACKET		BIT(6)
 #define DISABLE_ECHO			BIT(7)
 #define MISSING_CAP_BRK			BIT(8)
+#define NO_UNION_12			BIT(9)


