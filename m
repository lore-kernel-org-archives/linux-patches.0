Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A942E2EE7;
	Tue, 15 Jul 2025 13:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585793; cv=none; b=SPhIy+SJnG+2DhKkTzIcEln/5RYoSeMOxb/w9ophCa0+1zTUwaWPZaeF0+gjpzP0aO2ooQSq+iQR8UVLa75UuNNManSPnYvZ+LeJG4CMH1+m8dA3gY8VpKUYxuSY9v51oeu55Ajnrgn4UEtjyj3c0m3kjnGvE/T6fdJjkHeGdaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585793; c=relaxed/simple;
	bh=It4EmhxqDAfwYjN/XDHDgihJmkOAf9retNXb9ILuR7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDBppsUFI6AFPtn08msFxk9p2XIW//tbaGIfDMvrHa7ITQR3TEQDIElvx5ke46nnkJ+8XMaelpUhxvWLOnO5wIaV5jQs5BEfmdQJreqSBQTpxRFrq74MUQXuFx4WdthN5yiSelawnGj/6jgNUDoeqIuTjK+rp+nOtDIhhmP7TC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iQkL0I1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iQkL0I1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995A5C4CEE3;
	Tue, 15 Jul 2025 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585792;
	bh=It4EmhxqDAfwYjN/XDHDgihJmkOAf9retNXb9ILuR7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iQkL0I1rQKQGoDyJSbxFH3aPaZT9d0rQoXL+maiZ8RLk9lTqOors9eRqvcaakFyD
	 hZI1a+Xz/oNf3q1mZ/+H1UHCW3dvbwPXKJMIvj3QBpafFb/LxAhWTevzPJ8hPYdV9X
	 ChdRykuEt0tNs9xUR1eEMO1SXMUWNqKw2QtRwgPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 6.6 002/109] drm/exynos: exynos7_drm_decon: add vblank check in IRQ handling
Date: Tue, 15 Jul 2025 15:12:18 +0200
Message-ID: <20250715130758.969636112@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

commit b846350aa272de99bf6fecfa6b08e64ebfb13173 upstream.

If there's support for another console device (such as a TTY serial),
the kernel occasionally panics during boot. The panic message and a
relevant snippet of the call stack is as follows:

  Unable to handle kernel NULL pointer dereference at virtual address 000000000000000
  Call trace:
    drm_crtc_handle_vblank+0x10/0x30 (P)
    decon_irq_handler+0x88/0xb4
    [...]

Otherwise, the panics don't happen. This indicates that it's some sort
of race condition.

Add a check to validate if the drm device can handle vblanks before
calling drm_crtc_handle_vblank() to avoid this.

Cc: stable@vger.kernel.org
Fixes: 96976c3d9aff ("drm/exynos: Add DECON driver")
Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos7_drm_decon.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/exynos/exynos7_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos7_drm_decon.c
@@ -601,6 +601,10 @@ static irqreturn_t decon_irq_handler(int
 	if (!ctx->drm_dev)
 		goto out;
 
+	/* check if crtc and vblank have been initialized properly */
+	if (!drm_dev_has_vblank(ctx->drm_dev))
+		goto out;
+
 	if (!ctx->i80_if) {
 		drm_crtc_handle_vblank(&ctx->crtc->base);
 


