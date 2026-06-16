Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562AA3D45CB;
	Tue, 16 Jun 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633342; cv=none; b=ne70hjEras2aL7OtftTE7AragbuX3Ma62bZrGlmHIcaeQ+jJSyB+348EeTqBzbv3h5u1yD3h4oZJd4JUIfZmJULwq2FANXm0SDrguBpamJIZlUNZvpvIRMXzNYTMDIRUABW1Gnc2fp8VeSh79PTmSeMUYywj365eqHAljVSSsEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633342; c=relaxed/simple;
	bh=lhjXpTqBoEBsiMcUZMKHPyNmywcvcOp28SVo1Eh6go4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpbLfr+cyarfKrOyDmsEnsVeOhJ+OgreIcU9z4wJcrIUKQh2S0zugzsDjup06ucoL0Mv1hELpjIov3D7fH0SPRM8E49WAvT9l9Iqg5PyE3wWj5jJj9NiDTcMEcPp4Hfu5xJEJPIwEMXv2Iki1M9B9Ibv+4INWbKRYXwuaDbqQVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrBJKdNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrBJKdNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559611F000E9;
	Tue, 16 Jun 2026 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633341;
	bh=NP9sBirA3pcaZVyrc4nsQfUq5sq4oMw2bgnprf3+cuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrBJKdNFUGE1DiVG70wcliIUnrB7KzBv26otNMfEdtaXOD6DB+KsHR3YSuRkcjMiB
	 4HlVR5O3Tsw46svN12WC4+m6M0Gg0DW6W5kc+sXCkdIfrrJSMymfx20lxTN1/nayne
	 qiPQeYYQpmT/OMaUQcnlEciPVMPeEu9N9+192qoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 061/411] Input: ims-pcu - fix usb_free_coherent() size in ims_pcu_buffers_free()
Date: Tue, 16 Jun 2026 20:24:59 +0530
Message-ID: <20260616145103.525183425@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1598,7 +1598,7 @@ static void ims_pcu_buffers_free(struct
 	usb_kill_urb(pcu->urb_in);
 	usb_free_urb(pcu->urb_in);
 
-	usb_free_coherent(pcu->udev, pcu->max_out_size,
+	usb_free_coherent(pcu->udev, pcu->max_in_size,
 			  pcu->urb_in_buf, pcu->read_dma);
 
 	kfree(pcu->urb_out_buf);


