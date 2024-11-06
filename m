Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13C81DF72E;
	Wed,  6 Nov 2024 12:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895582; cv=none; b=bHIYJ6dKWPmByxd4mUQ0wE8feT2jDMQ44xTOg3eDpa/kEIAFC5E5zar+Gksb8Ua5Ue750T8KAA4AJ2XALx6uk9NSJfXdaFppQ/4duKrOnfhpZ2lNDN9WuOfuF6HlDePusTCGM9jpjU8bKJYS/+8+8+mjPFMF6r9GfDKwnJnT/D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895582; c=relaxed/simple;
	bh=oybRPaZwhX3WTCOMDM4P0srzS6Q7wDujrg1pJYUgFPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGiz9A+cSN0rQzPHF2xBozpc9E4RC5IlY2MMQVxhgixm1h5m/wO1GdQi2XQMkqGXnC6rnHYPCXhqcQ3r/NANiXv9eK0RcPfwEuYXQWGJ5jg6e20ZpXgjSqDgDp644jQaYEq+glV88LcAMkdzHUF2aKG4gUrZ/xTzyHBFFtKlbrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RC2VAGWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RC2VAGWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D23C4CECD;
	Wed,  6 Nov 2024 12:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895582;
	bh=oybRPaZwhX3WTCOMDM4P0srzS6Q7wDujrg1pJYUgFPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RC2VAGWozGF5k7VJA4+0flPYOCjiGui9hAx6tqw7B8k3gPfIagmFf9c2np4GPsc0r
	 ZsiVDRZKrtcK8E3ccx7sf55lxqspC9JUq9tuoubPR3AZG2fhPrPLJ2JycK8IveMjYH
	 R+sWGZEJlsxEeteRfSvUJ4mVvB8/l+1H2yoMMEcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.19 266/350] usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip
Date: Wed,  6 Nov 2024 13:03:14 +0100
Message-ID: <20241106120327.468035586@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

commit a6555cb1cb69db479d0760e392c175ba32426842 upstream.

JieLi tends to use SCSI via USB Mass Storage to implement their own
proprietary commands instead of implementing another USB interface.
Enumerating it as a generic mass storage device will lead to a Hardware
Error sense key get reported.

Ignore this bogus device to prevent appearing a unusable sdX device
file.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241001083407.8336-1-uwu@icenowy.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2412,6 +2412,17 @@ UNUSUAL_DEV(  0xc251, 0x4003, 0x0100, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NOT_LOCKABLE),
 
+/*
+ * Reported by Icenowy Zheng <uwu@icenowy.me>
+ * This is an interface for vendor-specific cryptic commands instead
+ * of real USB storage device.
+ */
+UNUSUAL_DEV(  0xe5b7, 0x0811, 0x0100, 0x0100,
+		"ZhuHai JieLi Technology",
+		"JieLi BR21",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_DEVICE),
+
 /* Reported by Andrew Simmons <andrew.simmons@gmail.com> */
 UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x0001,
 		"DataStor",


