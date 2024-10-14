Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6751C2337;
	Mon, 14 Oct 2024 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917212; cv=none; b=NvjKS+mUFGhzIggRuGNi31YTc96wa+XOWt909xQbeoLwUbA/eTsGav2+JJw3gBfB6iPqXFHKR+Tnksbh5eSvwSTT/d4ZfgUB4N6wdZRxgb81odFIq6m3ZjzV0yiONSMx6BudswbyOVsZwPGPr30hyc2oY1VwQw6gHkFlh0gNw1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917212; c=relaxed/simple;
	bh=6c16AE8y4s5yGtVh8aB6O+bf4/HXq1cEu6uTdXduCrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0xYy3zFmbj3rrwzqW2VSQBNhjgtMSsgng66bbZHgxxc9eLOkBpA6WXYBlkIeuAqS+vA8amlUU+BckGQdBf4/sEBbr94HnZrNLrnybYf/DSXdBf1oS0S1kX4dwDZiAPZcQIVhrY98NQJ69W7lHXzNqi6i49SUVmaA7CTcYz766I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCZj9M4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCZj9M4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74D1C4CEC3;
	Mon, 14 Oct 2024 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917212;
	bh=6c16AE8y4s5yGtVh8aB6O+bf4/HXq1cEu6uTdXduCrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCZj9M4KQ3a7vKmCESspr4IkKxkQASAf1Dw8kvLlSjTD0RZ4PFoQ68qZcUodTa0zS
	 Y7KUBhQa8mEEHQm4PcQD7dadWgPbGD6rwrDyQSFel/h6lJ0NOxNjyN+D9vxtBQxN7y
	 BolOKKL1SFUipJCbY0GY78ZS0lsV9vGEN1WoSXUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 185/213] usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip
Date: Mon, 14 Oct 2024 16:21:31 +0200
Message-ID: <20241014141050.185469319@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2423,6 +2423,17 @@ UNUSUAL_DEV(  0xc251, 0x4003, 0x0100, 0x
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


