Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3853246F4;
	Sun,  7 Jun 2026 10:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827974; cv=none; b=GMZ1Ky0uz43+5LYKSCR35d30Dlu6WteQcQffxkR/iXNWvbJQnSemhgfFusnQfd3iYVZjdyULIvbdacOODONsgHE/FlD5ci19Vhz3lfWakIGjk1zjHy3QG7kyDgwlgRk4Udd8IesqQQM3kSj8PFAumAZDlMM6rGsyhxUdZ2b3PfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827974; c=relaxed/simple;
	bh=vrUPji/Qgvp5C9uDB7LWczfg+Xj6gika8KWolt9WynI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plZxkhKmKMTLYXf6JcRg51y1Lq5/r23Fn0ICqZLQlTiZBwyk4pP58k/oIML1sUz2h6ZLrXHseTtLMmt1CoAVM2GI8sSfnX6Z9w7FGH031wuZvht3kqyYiZu98EY8jrE5igZEXFISVlOaVkxTViO8SPb+ejuekdscj+VUPAyoYq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDUeHBHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDUeHBHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93B21F00893;
	Sun,  7 Jun 2026 10:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827973;
	bh=Dk6/H5QHE03PDBU164kpyHPH/RErEC9QMhJhIt/bDU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDUeHBHDAV93OZZRbGQ6VJeckpaScjq9hNmvsRxBP2YmqhI/CZQMSyaS3Nwf3yV5p
	 Wp12FYZcpcm8Qo8JvblGuoK90/HB1f0rf8Svk50K3fSBiGMBucOQHB2nQ8PT0WR2y2
	 53dT1LkRV4EaSJUBl9Z39noQOzP4KarYVnmnYhQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 117/315] Input: ims-pcu - fix usb_free_coherent() size in ims_pcu_buffers_free()
Date: Sun,  7 Jun 2026 11:58:24 +0200
Message-ID: <20260607095731.929866753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit dab48a7e74e6a394f3aa0461a2b1fb0c7b38fcb8 upstream.

The input buffer size is pcu->max_in_size, but pcu->max_out_size is
passed to usb_free_coherent().

Change size to match the allocation size.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260522085412.45430-2-fourier.thomas@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1604,7 +1604,7 @@ static void ims_pcu_buffers_free(struct
 	usb_kill_urb(pcu->urb_in);
 	usb_free_urb(pcu->urb_in);
 
-	usb_free_coherent(pcu->udev, pcu->max_out_size,
+	usb_free_coherent(pcu->udev, pcu->max_in_size,
 			  pcu->urb_in_buf, pcu->read_dma);
 
 	kfree(pcu->urb_out_buf);


