Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D597D43634C;
	Tue, 21 Jul 2026 20:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665279; cv=none; b=ZAk+vn0KGGXRQ4LBT0hXZA/ZqVsCE4Te9G2reJD0V8xbhmJnsRDG6dPqQjRA3Pj8I9zHRSuqpaSmtnUBJkngJE4w1B9bWGhFkpQOwAE/0Viftc80LFkz/NqWKRYGqMXYPwVQTcGR8jQ1x5OYCpxKEElPxqgggswbc7/vMGFyDV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665279; c=relaxed/simple;
	bh=TFG217APM74UH2HiQMHe5nDKx90maxW6WB7mas2MXcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4XVvu2MhK4S9o+XkYcqtLGAlJjT2eqiFlqeMfAs83OXphY/ulxuSUWIt8gZFKrBNY2PtqJKZSEnqvuRovjvR44iAlyJ6RUR0B5mz1u5MoTyLWs+azyYEuMmib+PttlWf/zb7whcAvkW1KTn44+8xj3QYo8ankPbba7cNpQyXXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opYRaWyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opYRaWyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461311F000E9;
	Tue, 21 Jul 2026 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665278;
	bh=KCCG4Eaa/gzPX3Mlq7XLJio9EHwrhAk10sa56IlHFAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opYRaWyTPMNdZ3lJbInF7vJIQzdn2limKSZNRbWfzAeqLKou38jMkW+OjkvsasOfd
	 pvpU9rnhIMutjQ8V47SZ0mugc7JINcoGPaXRK+rMCWvf4ni1RZdTtcmYo9nktDYE6x
	 8LcbDMEHkFTcTZf272xuAFyoTWYt6Fpmmaq1LswE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0245/1266] USB: serial: digi_acceleport: fix hard lockup on disconnect
Date: Tue, 21 Jul 2026 17:11:22 +0200
Message-ID: <20260721152447.296767104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,12 +396,14 @@ static int digi_write_oob_command(struct
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


