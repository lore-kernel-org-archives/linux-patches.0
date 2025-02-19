Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD6D2AE74;
	Wed, 19 Feb 2025 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957393; cv=none; b=l273LIG35VRXnhmv9ylOREA1ZEQCTx5+hQdHhSfQbqb3XPnvdX337GoJCfNAEoWQlpcGnivA3ByoF8npdXhUkvofoO3mrnlm750iHZJukqdGpBy5PB6qL4cQ5J8AO2mkQS7ZlCk+WCuBcui6qQGRkYShNO/4PntqwT1kmRuhW2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957393; c=relaxed/simple;
	bh=A3ApIVLF/m6na6D8MPFHGBconhEnMSJ8l9sGsHIkxIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Og8L33XpNoeKqdY2phDuKPtDZVlsEJu6tMdJ4fuiFNZsMvxb2QWncebxu4h51N9yBcMMaf8CkELTmSY9HWYnNgocEArM9HBbSkdzg3JSjQpq7Zau/du/+OTZtnFUtFs/NXswYNBseHVHPJ/1zYSeCnmgV7Egp6gk7AvG7oOSZBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyOd0Hzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyOd0Hzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217A2C4CED1;
	Wed, 19 Feb 2025 09:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957393;
	bh=A3ApIVLF/m6na6D8MPFHGBconhEnMSJ8l9sGsHIkxIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyOd0Hzn3RiuWV6E2gi9T2eEp/uKpvL9aTO3Dy5ybAPEuXavGN/MhScpRGvqJeWzB
	 c/ngZD1biaLljYDYGnhD9vLwmEG2+h1su2OHe33HIK7QQjH/J3EpBi6yL64lCFg1BS
	 xfYjh7LrF2IXbbrXdQN49IDKaHTje6nklNFJTJAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Forest <forestix@nom.one>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 510/578] USB: Add USB_QUIRK_NO_LPM quirk for sony xperia xz1 smartphone
Date: Wed, 19 Feb 2025 09:28:34 +0100
Message-ID: <20250219082713.046576474@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 159daf1258227f44b26b5d38f4aa8f37b8cca663 upstream.

The fastboot tool for communicating with Android bootloaders does not
work reliably with this device if USB 2 Link Power Management (LPM)
is enabled.

Various fastboot commands are affected, including the
following, which usually reproduces the problem within two tries:

  fastboot getvar kernel
  getvar:kernel  FAILED (remote: 'GetVar Variable Not found')

This issue was hidden on many systems up until commit 63a1f8454962
("xhci: stored cached port capability values in one place") as the xhci
driver failed to detect USB 2 LPM support if USB 3 ports were listed
before USB 2 ports in the "supported protocol capabilities".

Adding the quirk resolves the issue. No drawbacks are expected since
the device uses different USB product IDs outside of fastboot mode, and
since fastboot commands worked before, until LPM was enabled on the
tested system by the aforementioned commit.

Based on a patch from Forest <forestix@nom.one> from which most of the
code and commit message is taken.

Cc: stable <stable@kernel.org>
Reported-by: Forest <forestix@nom.one>
Closes: https://lore.kernel.org/hk8umj9lv4l4qguftdq1luqtdrpa1gks5l@sonic.net
Tested-by: Forest <forestix@nom.one>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250206151836.51742-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -432,6 +432,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0c45, 0x7056), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Sony Xperia XZ1 Compact (lilac) smartphone in fastboot mode */
+	{ USB_DEVICE(0x0fce, 0x0dde), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },


