Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD62494F0;
	Wed,  8 Apr 2026 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672719; cv=none; b=K6/ZqobNQxLQ1XcTbCZ14XwNeCQ0iKIwuNkuGhgTP8Uee/SxHvGojn4k9vsw88x+IoObVOIZySR7idomvsQboF/zFkLcOkuL3/gFSv58tF0QYcyiMErg4x4qzChraphvXNNsh6PIgmnQhgx3F4/6Y9VBmmSU2G/aq28PfA/npbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672719; c=relaxed/simple;
	bh=tytLaR0HEfTur3CWA8vsIav3Qp9CMSfq6i8QS2J+4gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3N7IHAB0oGN9l7Vrm52/Vhem6sNAOQ5zgOFc8vJM6QQliIjswHiPBNdURAd2iuRPqA9GIaff7G0X8qtS6VA0NH5+rgc9ycx2Kxj8Kt2S62vaDNR0Zl7b2YWvQCZvcR/F0NABWiRHyO0G08yS7zdCXPGiTVs0godyn9yPBlRo3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIysdlYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIysdlYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9681C19421;
	Wed,  8 Apr 2026 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672719;
	bh=tytLaR0HEfTur3CWA8vsIav3Qp9CMSfq6i8QS2J+4gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIysdlYuZHcTdPSxQmRZyCmBevFQsc5+rvdQsirz9zd28dpVCQ56swrwDVzBrK3xP
	 dkERH2+nYbrgUKqlE3F2PRhuf9qTMqXEPk+CoRhxM8eaWGQIyBqwumE3b1rRudJ315
	 7rQ/nFwwpOQmsN39FeE6rtw3zaJqxUavBUowgxY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 116/160] cdc-acm: new quirk for EPSON HMD
Date: Wed,  8 Apr 2026 20:03:23 +0200
Message-ID: <20260408175917.523575884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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


