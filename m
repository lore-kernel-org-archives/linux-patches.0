Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D355C36BCE0;
	Wed,  3 Dec 2025 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780376; cv=none; b=d7Ut5vg1dPYJpXoJ1sfu0z1cOVNLAYpfbwuzgRUo2QGwbXZL4bdujBc3mGh9rdp3rCJFg/6SWT36fhjIVT39ab0heX+/hhnxLiAH5XzgC3esYaoBlrtEjtig5QcvKxsfJ53lTNriT7OOlJ2fG9Wf8/YpCNthKzMImptU8fA+yvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780376; c=relaxed/simple;
	bh=ZUFrNablHp+hVxhytf8evaBrv0eodrMsNEqStJadyfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A67Z+tN0Yy8kq6shoAYf4y3zyBNRSKfymUG67AOSagz1LB3wgQo9DQoOaJ3PW8yXbJOtsHLm8SfPA5qsOkqZVEFqPMJUCVAn/I+ECZAoD2tjysN17P02x+sUKizV7GdsNJdSdgOOj2U7r38sXduqpLht8Rv+DlGaPTtYvMbdoR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCFm6/l5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCFm6/l5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F0EC4CEF5;
	Wed,  3 Dec 2025 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780376;
	bh=ZUFrNablHp+hVxhytf8evaBrv0eodrMsNEqStJadyfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCFm6/l5fIiR+a79MKhz6v3fWYkPr7JO3Enr6K0GRSNiixr7e0tP2iz+z8/kwCaiE
	 Um6qugLTHY/xb5khpEh6efLdvmm1PdBo0rslVMntpjpqn8csKJax0WWmEC9A0fYyD6
	 PrBRA2+rPHB/il7s2N/EK+WdYqPgXwuz2jZv412o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stealth <oleg.smirnov.1988@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 539/568] USB: storage: Remove subclass and protocol overrides from Novatek quirk
Date: Wed,  3 Dec 2025 16:29:01 +0100
Message-ID: <20251203152500.453445737@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit df5fde297e617041449f603ed5f646861c80000b upstream.

A report from Oleg Smirnov indicates that the unusual_devs quirks
entry for the Novatek camera does not need to override the subclass
and protocol parameters:

[3266355.209532] usb 1-3: new high-speed USB device number 10 using xhci_hcd
[3266355.333031] usb 1-3: New USB device found, idVendor=0603, idProduct=8611, bcdDevice= 1.00
[3266355.333040] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[3266355.333043] usb 1-3: Product: YICARCAM
[3266355.333045] usb 1-3: Manufacturer: XIAO-YI
[3266355.333047] usb 1-3: SerialNumber: 966110000000100
[3266355.338621] usb-storage 1-3:1.0: USB Mass Storage device detected
[3266355.338817] usb-storage 1-3:1.0: Quirks match for vid 0603 pid 8611: 4000
[3266355.338821] usb-storage 1-3:1.0: This device (0603,8611,0100 S 06 P 50) has unneeded SubClass and Protocol entries in unusual_devs.h (kernel 6.16.10-arch1-1)
                    Please send a copy of this message to
<linux-usb@vger.kernel.org> and <usb-storage@lists.one-eyed-alien.net>

The overrides are harmless but they do provoke the driver into logging
this annoying message.  Update the entry to remove the unneeded entries.

Reported-by: stealth <oleg.smirnov.1988@gmail.com>
Closes: https://lore.kernel.org/CAKxjRRxhC0s19iEWoN=pEMqXJ_z8w_moC0GCXSqSKCcOddnWjQ@mail.gmail.com/
Fixes: 6ca8af3c8fb5 ("USB: storage: Add unusual-devs entry for Novatek NTK96550-based camera")
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/b440f177-f0b8-4d5a-8f7b-10855d4424ee@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -938,7 +938,7 @@ UNUSUAL_DEV(  0x05e3, 0x0723, 0x9451, 0x
 UNUSUAL_DEV(  0x0603, 0x8611, 0x0000, 0xffff,
 		"Novatek",
 		"NTK96550-based camera",
-		USB_SC_SCSI, USB_PR_BULK, NULL,
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BULK_IGNORE_TAG ),
 
 /*


