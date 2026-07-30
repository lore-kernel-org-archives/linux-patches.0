Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755B0423782;
	Thu, 30 Jul 2026 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423771; cv=none; b=RVa+foomoYzrHFwlDsrRB11pN6h+dKIve2fe2FZK1fSLL0WAt/KczJRS2s7V6skScjl1y803y9HrCqRbzwfirw7J0Mu6bkTF9pXCGzcY8bacUDG14oVkjmOrXm5N3G/w/UohfLOsgqg8YHMnXD6EqFChlUJMkuhM/mIRLk/au5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423771; c=relaxed/simple;
	bh=YLbjSujjQoIWIzG8E0uw8JRFSSsKgEfskB/iBVh8bfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcgSKRGu2xpi3tYeziexhNAZM2OoG5JsKTxOoG/ZM3ABHGhtgtJyTQnaVdYsV/OyLxw9nV2u+WBtJvkcSIHDSQfxv50vRFo04JfALpb8dN7sNk/i+bMZwjqXbT5nKzJFSZlpWKCmZW/X2NpZblbSa2zuaqDQtDprU1kAcWbwjWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFvYwXnd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFvYwXnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4F21F000E9;
	Thu, 30 Jul 2026 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423770;
	bh=T4LMcceC6BDGkXwpoxJeJ54PWQRvFiVm6KBftEAFVbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFvYwXnd89YwEglseFxSuNqH93lhNeUgdxwX0f9/R0pNYej81AJhjr7PI8Y/rfeJQ
	 vsCDloVbNXKmtUhU48GhZLvoL2WMLA8nWaKEvuCERJdIVigIvb3QmVpaRPs/JpPWNg
	 S2bmMbdB2iuhNrQ3Dcb/ftMvR0F1K8iS/Y+cO53w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
Subject: [PATCH 6.18 159/675] usb: typec: ucsi: Add duplicate detection to nvidia registration path
Date: Thu, 30 Jul 2026 16:08:09 +0200
Message-ID: <20260730141448.515302034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

commit f1aa17f72f9b9589bd724dc826c5b17d164193d1 upstream.

Extend the duplicate altmode detection to ucsi_register_altmodes_nvidia()
which is used when a driver provides the update_altmodes() callback.

This ensures all drivers benefit from duplicate detection, whether they
use the standard registration path or the nvidia path with update_altmodes
callback.

Without this fix, drivers using the nvidia path (like yoga_c630) would
still encounter duplicate altmode registration errors from buggy firmware.

Fixes: a79f16efcd00 ("usb: typec: ucsi: Add support for the partner USB Modes")
Cc: stable <stable@kernel.org>
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Link: https://patch.msgid.link/20260713084323.287516-2-acelan.kao@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -664,19 +664,25 @@ ucsi_register_altmodes_nvidia(struct ucs
 
 	/* now register altmodes */
 	for (i = 0; i < max_altmodes; i++) {
-		memset(&desc, 0, sizeof(desc));
-		if (multi_dp) {
-			desc.svid = updated[i].svid;
-			desc.vdo = updated[i].mid;
-		} else {
-			desc.svid = orig[i].svid;
-			desc.vdo = orig[i].mid;
-		}
-		desc.roles = TYPEC_PORT_DRD;
+		struct ucsi_altmode *altmode_array = multi_dp ? updated : orig;
 
-		if (!desc.svid)
+		if (!altmode_array[i].svid)
 			return 0;
 
+		/*
+		 * Check for duplicates in current array and already
+		 * registered altmodes. Skip if duplicate found.
+		 */
+		if (ucsi_altmode_is_duplicate(con, recipient, altmode_array, i,
+					      altmode_array[i].svid,
+					      altmode_array[i].mid, i))
+			continue;
+
+		memset(&desc, 0, sizeof(desc));
+		desc.svid = altmode_array[i].svid;
+		desc.vdo = altmode_array[i].mid;
+		desc.roles = TYPEC_PORT_DRD;
+
 		ret = ucsi_register_altmode(con, &desc, recipient);
 		if (ret)
 			return ret;


