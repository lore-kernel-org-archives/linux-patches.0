Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011B61DEFE7;
	Wed, 19 Feb 2025 08:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955059; cv=none; b=JNi0aiw3ifogMR5zeOAkCy/MGhiR5xXBghJQfZchghGq1uMDHL/E8lFL/+EQRyQnvNn1m5ioAC8R3CbfpkTLxArsKh7/fUwvnLycyZKuBEr4uoa9U69X3dTFNlDynANzfG3xa+AiaIiLPiHUUi89nRbXIByYmcspe79U0Dz+4ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955059; c=relaxed/simple;
	bh=vVroh0RwOmikYuEgS7V91W/SPskDGb/1UZamyEo9/Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZAbHiXZb+wow6roKNNwM77y/k+9NE3O1gkkbwxfViuQHJCdX5SUfBhY7MloUBgTq+s8VkLezBl5t5C+fk6syYn/y3/617O9j1Le+CGgwoWwaZqtYP0GrGkhwJhroo0uvgJoHeAjBTpplVAdgL3iFerMZ6uRALoARLwMqbgZz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKOdl4N7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKOdl4N7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E33FC4CEE6;
	Wed, 19 Feb 2025 08:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955058;
	bh=vVroh0RwOmikYuEgS7V91W/SPskDGb/1UZamyEo9/Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKOdl4N7cxb0A7R5Ug0p0QLWor0q9HG7YOOUJDU5YpxAYqeumXDhq9Dp6XOmEF7yl
	 KvGcahgOjdQdAxGOTqyefHAx4P9TxQDSykvvdtYy2YfxvJsQ8kjt+3QAQLBXQIP6an
	 Ix3axZ+Gv9DbLzeqvHRdADbxMEhnP+9Bm125fQnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Forest <forestix@nom.one>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 118/230] USB: Add USB_QUIRK_NO_LPM quirk for sony xperia xz1 smartphone
Date: Wed, 19 Feb 2025 09:27:15 +0100
Message-ID: <20250219082606.306070994@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


