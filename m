Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6CE42CB1D;
	Thu, 16 Jul 2026 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212323; cv=none; b=MQc7Wyo4CgL5NFAoUySxsjWAHUu6b0F9SxMaqG4/EcxpcvKmV6dBchEb9mYMMyIVvD3rN3me6d41VZPypkl5H//8Z9tb66xBJT3GZoJLRLUNecrSLNdcCEsp6LCh7VBBam0kAOOFfZiE4gV15klbtV/a1jV6sRvg22dQaOx/rVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212323; c=relaxed/simple;
	bh=p1REH25yqPU1HbMZdQ/U8otmSGgsk1pz8LEv9bpqd7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVM+QPwMID0QZLs5I3o/Ri2FpPSOGgmQLVVFb8/J6Me/iEYpUMpqaMIYZEDF8tbKBgfOfYyxEAnYShGE4DIGlJuzr2zErZEX01wNMIhtN2UMBCe/Lcl/9E6HFlQdkanfmaQ/QgxPo3ykAgajEBs0bPmNDLAGpuDRNfB7Fxb2f+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISHviAzL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISHviAzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342591F00A3A;
	Thu, 16 Jul 2026 14:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212321;
	bh=k52AMcTcTIpl3ORcuo5+Hzu5ZUkvMWcZyB7uhYuwn3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISHviAzLQ+Hg50kpOl4v8nIAa/l+cZZma0r8X2EbSiK57gFONbxs2Z9srMKnxLawU
	 e2pll6vFYGwWcm+vcnQwxhdXQMBL1goscFxU9vXBQbERFiIN3fDTO2ZBn3SjT17Tmg
	 C2YmssM+uoGU6I7oxtImOBu2uXxINnkiPM4OmpEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 240/349] USB: serial: digi_acceleport: fix hard lockup on disconnect
Date: Thu, 16 Jul 2026 15:32:54 +0200
Message-ID: <20260716133038.731479698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5c1ea24b53bf3bfb859f0a05573997487975da23 upstream.

If submitting the OOB write urb fails persistently (e.g if the device is
being disconnected) the driver would loop indefinitely with interrupts
disabled.

Check for urb submission errors when sending OOB commands to avoid
hanging if, for example, open(), set_termios() or close() races with a
physical disconnect.

This is issue was flagged by Sashiko when reviewing an unrelated change
to the driver.

Link: https://sashiko.dev/#/patchset/20260610132232.356139-1-johan%40kernel.org?part=1
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/digi_acceleport.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -394,12 +394,14 @@ static int digi_write_oob_command(struct
 			len &= ~3;
 		memcpy(oob_port->write_urb->transfer_buffer, buf, len);
 		oob_port->write_urb->transfer_buffer_length = len;
+
 		ret = usb_submit_urb(oob_port->write_urb, GFP_ATOMIC);
-		if (ret == 0) {
-			oob_priv->dp_write_urb_in_use = 1;
-			count -= len;
-			buf += len;
-		}
+		if (ret)
+			break;
+
+		oob_priv->dp_write_urb_in_use = 1;
+		count -= len;
+		buf += len;
 	}
 	spin_unlock_irqrestore(&oob_priv->dp_port_lock, flags);
 	if (ret)


