Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD11F4FB1;
	Tue, 15 Oct 2024 12:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994318; cv=none; b=Yd1Ju0YEjSNcseaRlfDtOUrR+BDRnddmWO2hnE0RlQi8U3LBDQkb06KfTOrfuSiB6JOm2advJTi2x+6Y9Go+Z40iylr/BgO3BvPqENfacJ6f2X0wlmeApac2aBP7R4WMHYEFd+g9PS7BKcw33x5k7lXX2U7FB2lvb8WAvnTViJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994318; c=relaxed/simple;
	bh=lOooBHol2En6vSODrLC0JHRlLg1PWcIFazr0K0AqEAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEZmto+C5a05dZwU1HqXfS4mo4wQVcMHZssL5a5skRHrhH0Y1SX5cu9Y6frNYapuz4Tpj4/wa9VjfoTZ+S+InKaw/UI5f8D/6x2/iiKOwdRraAUl3beYOsBxHRf2Ja/L3w+CxM+7Bp7vxFHGoQW2wL0/DjCQAldNlURHqfO3+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3bJkRmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3bJkRmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD696C4CED0;
	Tue, 15 Oct 2024 12:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994318;
	bh=lOooBHol2En6vSODrLC0JHRlLg1PWcIFazr0K0AqEAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3bJkRmPhW/jh9CwXXtjl4PYcbAa4+wZRwxYKKHmHy/2pZAZcJPE4uqvRev9yiCVd
	 9fH93VfX0NMiBmGpYCM/xh/X17Lt087uxMfSMjl9HTKoN3RUAkNr6Uvy9P3SI1yicK
	 cuh+l7mxFOclA4I+VumbI3UsvwFUQbbI5XsYnDKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 670/691] usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip
Date: Tue, 15 Oct 2024 13:30:18 +0200
Message-ID: <20241015112506.916445190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


