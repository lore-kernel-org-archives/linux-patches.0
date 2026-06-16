Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC1047CC79;
	Tue, 16 Jun 2026 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635485; cv=none; b=Wc7o/ggHf8Sq3u5UAGZXXHVj7Tin1c00nmwOXXWzMZ557kVTYO8RV/ZRwU7Fig8zdYWD9h5mMuv51ao/Vus8YB9S4wZUgl25XI3mmJnUPJ11urJp2zdD92kMUnt/z9M5RWiu3xzVnMrfZBc4m6SEJlqGZ0vyieSpIhunnLITpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635485; c=relaxed/simple;
	bh=KoKyXsQTSdSZSnEqTPbx8kJZlKpwZHJ486CY/raV8nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmngV36XZ4aM7AirW71cSCh+vT/UGnGxfraqYPlaOkN1NI8lDiK6V1MgBcv/Q1xsg3NK2UyO6hwTNrEpM7NQQf4aZEdZFffawYtzYBBIoeFtFNbCSuaxz6TxZPvU/+VKD/lIgKvmW4TL5r0IRuev6JyxuxKOAv/puuTDe5Gw9PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRQppZKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRQppZKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94451F000E9;
	Tue, 16 Jun 2026 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635482;
	bh=GiigSJfONMfZeyf1rVT09/121Nh3WOiu3brGMDtnOpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRQppZKltt8F03rT7W/+AQC6NKAQBDvhUY6He+ltAcIdgGx6kPfkTUijAyBCFp+Xu
	 ixG1ww14J0/peoLppxi7li/turRSYMMc5PBg0JaZiAZtahYewfoAXMscooy4oziFDn
	 J0/nKkLmk712Kau99tkpD0okb8O6YtW42cIKP21g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 050/342] Input: ims-pcu - fix usb_free_coherent() size in ims_pcu_buffers_free()
Date: Tue, 16 Jun 2026 20:25:46 +0530
Message-ID: <20260616145050.586193485@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


