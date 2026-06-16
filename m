Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0421C47A0C3;
	Tue, 16 Jun 2026 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629674; cv=none; b=i0pJlsGgfvxUSfXsZL0d75dWhWLpvFzTYTNSYjVAWNb0XVZd+w8j9fRfo9NVQZXE/De5zRLycjB6yZcZ3apbKWHK65H9IvR2kenHI66UzgRR37hPKAW1ghLYTao5MCv2+nB+ccH9EeB9EBMm1Wmpj2KK9pQfmCbf6Yg1Zp9kcyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629674; c=relaxed/simple;
	bh=YGli2fYIdh9SGvecikyYYDdP+4Y4C+tnkWTXHmFZNM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdaS5JkgSvZegVhW7Xhn8voKhJ1RQHPU2SDU6o8Pp5U/l+5kYa/do8bzYBkhBVlzwbDxnr2yu+ZosiSLccaySk9Qhn+Wxg0rAxLtvhhX3fHmxbrY79DgdPMeUp8T6wwQbKuGFTnutEz4Ig+dA7/23cis+WBWrjyBFzTSgtLx1Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nzu0DNXz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nzu0DNXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CD21F000E9;
	Tue, 16 Jun 2026 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629672;
	bh=sag22cpnVfy9iafTWNXY9DDxJwsr3mgUrlM6HSppTfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nzu0DNXzR6VU6sgZOKcDE9CUzAQLgD2yn03s0XWKk2/v+Fs/fTRx72M8vtqVRnxQi
	 2jc+QaKtU2jXF8XVNTi77rPxmYbLsuNDRhsMChPl3+183+O+yinRrnjtnqrGoYBVUg
	 vov2AsEPJ2ufu5A7Izn+2/uyvVezlDrCWCK1awLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeyu WANG <zeyu.thomas.wang@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 330/452] Input: atkbd - add DMI quirk for Lenovo Yoga Air 14 (83QK)
Date: Tue, 16 Jun 2026 20:29:17 +0530
Message-ID: <20260616145134.711273553@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Zeyu WANG <zeyu.thomas.wang@gmail.com>

commit ad0979fe053e9f2db82da82188256ef6eb41095a upstream.

The Lenovo Yoga Air 14 (83QK) laptop keyboard becomes unresponsive
after the standard atkbd init sequence. Controlled testing on the
actual hardware shows the F5 (ATKBD_CMD_RESET_DIS / deactivate)
command specifically corrupts the EC state, causing zero IRQ1
interrupts after init.

Skipping only the deactivate command (while keeping F4 ENABLE)
resolves the issue completely: both keystroke input and CapsLock
LED toggle work correctly. The reverse test - skipping only F4
while keeping F5 - makes the problem worse (zero keystroke
interrupts), confirming F5 is the sole culprit.

Add a DMI quirk entry for LENOVO/83QK using the existing
atkbd_deactivate_fixup callback, consistent with the existing
entries for LG Electronics and HONOR FMB-P that address the
same EC F5 deactivate issue.

Signed-off-by: Zeyu WANG <zeyu.thomas.wang@gmail.com>
Link: https://patch.msgid.link/20260602170909.14725-1-zeyu.thomas.wang@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1944,6 +1944,14 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
+	{
+		/* Lenovo Yoga Air 14 (83QK) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QK"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 


