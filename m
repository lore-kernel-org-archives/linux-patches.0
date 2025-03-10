Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CE217A2E8;
	Mon, 10 Mar 2025 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629643; cv=none; b=iMuJsfiNVqQREmwmtvdg48Nm1cDgGCgnT5QbPzGmcFE0yclG8X/koj9IaH7qTF7SFKudu+irL/z1aMMnjl3P7w/8RNvWL3IF0Aei+7Zq9g6ORJNhz1XiKpLX1aUp5SI0taTIjvPRVRsP4ztoGbgJ/jyxUrii20KjVSa2QjuJdbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629643; c=relaxed/simple;
	bh=0QJ5IzyOXmlGxC9psVlTKLxlBMxTYx9fbr+yqZg8xT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RulKEAF/JUUZUzASKHfk9O5biSbrJ5J9oUJsN9Hfgfhp/gDfqf93Y2gCFa7gyDPPhazrSSLuEGk/oi86vHNxkwEMOiOFEFJkqfK3DC4DcHIpm3qypT+TOrIydjaES3TMkuyfZekaND0G2rgxd5DAay4iv31cHxN+Kx/D4f1VZKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjuBgk19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjuBgk19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48109C4CEE5;
	Mon, 10 Mar 2025 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629643;
	bh=0QJ5IzyOXmlGxC9psVlTKLxlBMxTYx9fbr+yqZg8xT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjuBgk19mBrU4yjrYQRGbnPfnv208FMkkIf0aeTZtYOBIuG1GST1eUOKWmBskqpbt
	 tMvKqQF0GyfQb9XY5wmbrV7OmnvmpsNeuKb7Q870LJxWbjhMHtvSmWTrQttxRDe4WO
	 H3xH1mzkr2exFWRRAZnkkrjyPtqN0JfTeRdxhE2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Forest <forestix@nom.one>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 366/620] USB: Add USB_QUIRK_NO_LPM quirk for sony xperia xz1 smartphone
Date: Mon, 10 Mar 2025 18:03:32 +0100
Message-ID: <20250310170600.051127436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -429,6 +429,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0c45, 0x7056), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Sony Xperia XZ1 Compact (lilac) smartphone in fastboot mode */
+	{ USB_DEVICE(0x0fce, 0x0dde), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },


