Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1FB2E6D28;
	Tue, 15 Jul 2025 13:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586629; cv=none; b=ufKgYMb97r126Ud3pQuCYHdMrimiZ64DyK4qDsWUm+k7muNI7aKLGN1DMUv0mBPuZDPvOGeMQ0pRb7U4kdlHJofXlKgPIT+F5i8ZYEH/51Gr689VzIUkFEZZM0qAD45DPTc1NcdQszNZqN2MinW+jIR3k5TRHmkM0H4uzmpbfIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586629; c=relaxed/simple;
	bh=HiF2ghztmojzTuebhJhHKvzDLIBMaY+9sA1dO5zuQsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrJIB7vyz5UKhEfw7W0d9fBlEURfnREAMGdpFfGlGA1dL1LMvMxEcZB+knkXoKGeoYf0u2zVAHUfm+yuNYTXOL4UirdxFZMlpiw3LDtMZaLZB08OAAgZCljeOhOGT3ITLgeY7QKHODVAnWJ/MswZ9AJiq+3QksXRqb42V1QL7Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0KKTNoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0KKTNoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D356DC4CEE3;
	Tue, 15 Jul 2025 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586629;
	bh=HiF2ghztmojzTuebhJhHKvzDLIBMaY+9sA1dO5zuQsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0KKTNoMngFeSm/AxowSMF0u289PMdQNtCWVD3TEnaJ4tvjGib/hkLSV2KFHk4AWy
	 mQH+5w3EI6WzSFU5O2eTvrEF63YNCJMjCqy1wTgc6+89E9ph73Q4I6NMF1oSaWLnTo
	 mEkZnF4mY8nd3YkzYfzpm4JGsbdD6/7HmgieBKYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 5.4 106/148] drm/exynos: exynos7_drm_decon: add vblank check in IRQ handling
Date: Tue, 15 Jul 2025 15:13:48 +0200
Message-ID: <20250715130804.555803356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -595,6 +595,10 @@ static irqreturn_t decon_irq_handler(int
 	if (!ctx->drm_dev)
 		goto out;
 
+	/* check if crtc and vblank have been initialized properly */
+	if (!drm_dev_has_vblank(ctx->drm_dev))
+		goto out;
+
 	if (!ctx->i80_if) {
 		drm_crtc_handle_vblank(&ctx->crtc->base);
 


