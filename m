Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4361B2184;
	Tue, 15 Oct 2024 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998579; cv=none; b=g4BqCmHvuutJwwnn6YpfP3chJBZIredKF0NzHCQ3hPbzsiCMrz6ichpv7tr6Q8oXXgwt+tLJJP0+DE5yXZjzLawZ/I3mGDq3ozoHQrJwg/GiuAtDNhl+RlFpV7v7pq4QbuM25wVGP6BPUwDWLUTKAmyCQbB4gjFfFku8N9n4uiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998579; c=relaxed/simple;
	bh=10h2vRt9FRpXX/jrN5ieOhiVPE6dgWPbjnePcK9sg7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZGHO1ms3p8MMteE1r3/SOZ22cI4SnddtjaoTKLk5K1WKLsS/8olv9EZwXg3AGvU+hrfd0uW5Se4Lr5feRgV5/+0KgFSr7bkDj1J3C4qJj6kQrbyDTsHRr4XXrvYA1aqDleX/mfJzua9VmIJqHpKBAGs5bTX84lchPZGcj10di0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVa0gNiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVa0gNiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C99DC4CEC6;
	Tue, 15 Oct 2024 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998578;
	bh=10h2vRt9FRpXX/jrN5ieOhiVPE6dgWPbjnePcK9sg7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVa0gNiqbsJGb4BDejQsdWH5yPAdRTRjloBMijNAPQsOR+fmSFBc6Q5ZRgjh44ORt
	 z6AyaoPfVvbYNX2W/PNS1MuQBYpM9y6hJ86caa0lTyLNda9Bqu2wy8we48JvFXLYtG
	 jqn7kxrh/b2mbEBEMZ/oMoPXafR6qnjXvaL2NfSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 506/518] usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip
Date: Tue, 15 Oct 2024 14:46:50 +0200
Message-ID: <20241015123936.520417073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


