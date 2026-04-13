Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770073203B6;
	Mon, 13 Apr 2026 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099581; cv=none; b=VZ9QSUNFcaY08jrTgVnno5WUiQwWtGY2VyI8EP57E5CaDrBmAZcdIGriAh2ELqXBuPVAAIoUSaWlwUHITx2bJRyVq6nJhgH75katJRRYBHoVQol9Vp2ngLOUaqhPRjB5Hy8pCH6TnqB4eEk3cLTByTOHZCeMANewY5mXHzBpRXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099581; c=relaxed/simple;
	bh=uI9OzJFpRjq67fWhcyPI1ko3v5xQkAdAHk9iqJsuqaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxCKDmqhHFNjefC5az09KRhMDArMd7zORCnZy6nX/NuupCCCR0owhbyu8kjd27kmQfKyNmhwI3ZA1S0FqN+TyPYAI7yYlQZzXcOmGDkzHtXVNmlPMGac4kmqQAXkpi4jMhLT0otGsejI+t0AqO6FMQoMvT7Qrr8n5T8Gw8aNSBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfjiQQiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfjiQQiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A9C2BCAF;
	Mon, 13 Apr 2026 16:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099581;
	bh=uI9OzJFpRjq67fWhcyPI1ko3v5xQkAdAHk9iqJsuqaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfjiQQiRS5v8eeYuJtS1lqHTABCbdDt5CZMViCxUj75QlNSkIbrwipbEGhMT2Pse5
	 75Xtq2MFuXcyNG36Eln1ZI5kgobFdC/WIqp0NXHJ6ip/L5FFdHsIe6G6lNYyYhpwUx
	 MqIeTiVYCr3GygpU0BjTHr4FVGduwnw490oGSTmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 396/491] cdc-acm: new quirk for EPSON HMD
Date: Mon, 13 Apr 2026 18:00:41 +0200
Message-ID: <20260413155833.859416731@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -1218,6 +1218,12 @@ static int acm_probe(struct usb_interfac
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
@@ -1749,6 +1755,9 @@ static const struct usb_device_id acm_id
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
@@ -142,3 +142,4 @@ struct acm {
 #define SEND_ZERO_PACKET		BIT(6)
 #define DISABLE_ECHO			BIT(7)
 #define MISSING_CAP_BRK			BIT(8)
+#define NO_UNION_12			BIT(9)


