Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD4A232378;
	Mon, 10 Mar 2025 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628479; cv=none; b=UeEdMk1XKhCBVCIv0Z1C466IodCWRMQRVGn2+JRIoaAE9p7AvMH2ic9pHPJYPYzmRvVcbPf4N1Dwc7P517EeGh1dDp4aYJaghhRv2hsKPaleGoIUTRBDk1pT5QcLYnqeU2u+kzRsyKdJbWTuL2wp3q+i1ey1O0FdsOHU2z+rebc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628479; c=relaxed/simple;
	bh=l7cw/3VmVm3QRoAhndnqiypNPXG4bzxcDj5RSI6A84k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKj4FCJLBuHLCcfJoNsYvh2ZelBK7gjRaPnxnft8z9pUuOFStgk1D3RTRC0HYmnOelSXxSpouIDc3au0Vap03VHX0GjxQdv9bbreKbN4hRJMAkXeFBuWSopsyg1mpB44doTRa5osXD8522SoRrkhvOSw8yPBZjImaUg8F0rCnLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYCyIlnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYCyIlnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AC5C4CEE5;
	Mon, 10 Mar 2025 17:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628479;
	bh=l7cw/3VmVm3QRoAhndnqiypNPXG4bzxcDj5RSI6A84k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYCyIlnOzZ0dtHRfXHKxQmE3cwcx4tWcu+tq2v/lLVaQHu+yfiFUABQ30qCnvIoVU
	 canKZ/uTZbSHRKvGQA+uJupRqBPKAENIYXglGUw31ZmU2LvN4urPiP26OUe/oW6jpa
	 Tbvf+8QmFxVdum+fqNPbNahp2yaTr6Yl6hp9e6ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <boddah8794@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 072/109] usb: typec: ucsi: increase timeout for PPM reset operations
Date: Mon, 10 Mar 2025 18:06:56 +0100
Message-ID: <20250310170430.425232380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Fedor Pchelkin <boddah8794@gmail.com>

commit bf4f9ae1cb08ccaafbe6874be6c46f59b83ae778 upstream.

It is observed that on some systems an initial PPM reset during the boot
phase can trigger a timeout:

[    6.482546] ucsi_acpi USBC000:00: failed to reset PPM!
[    6.482551] ucsi_acpi USBC000:00: error -ETIMEDOUT: PPM init failed

Still, increasing the timeout value, albeit being the most straightforward
solution, eliminates the problem: the initial PPM reset may take up to
~8000-10000ms on some Lenovo laptops. When it is reset after the above
period of time (or even if ucsi_reset_ppm() is not called overall), UCSI
works as expected.

Moreover, if the ucsi_acpi module is loaded/unloaded manually after the
system has booted, reading the CCI values and resetting the PPM works
perfectly, without any timeout. Thus it's only a boot-time issue.

The reason for this behavior is not clear but it may be the consequence
of some tricks that the firmware performs or be an actual firmware bug.
As a workaround, increase the timeout to avoid failing the UCSI
initialization prematurely.

Fixes: b1b59e16075f ("usb: typec: ucsi: Increase command completion timeout value")
Cc: stable <stable@kernel.org>
Signed-off-by: Fedor Pchelkin <boddah8794@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250217105442.113486-3-boddah8794@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -25,7 +25,7 @@
  * difficult to estimate the time it takes for the system to process the command
  * before it is actually passed to the PPM.
  */
-#define UCSI_TIMEOUT_MS		5000
+#define UCSI_TIMEOUT_MS		10000
 
 /*
  * UCSI_SWAP_TIMEOUT_MS - Timeout for role swap requests


