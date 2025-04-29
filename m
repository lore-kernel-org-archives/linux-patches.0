Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717F21DF73C;
	Tue, 29 Apr 2025 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946622; cv=none; b=pJePpRcWp++rrpoWTgXAcwY0al3l7i5bBYvaFEh85TLAVFStbs6EDJoHqv4SIvHGEqgrEC7Dz6laXLqegU8IBxyXavV4W0wZhUegmzEbWgcb7LsfQAYj62pyqrjaNBwxfG98jUywGga3rlG1NidPMIC/Eb71mluCgVVTmnsuuT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946622; c=relaxed/simple;
	bh=ar25cQXZkknTnrlI3R9tt1nFb3swPJ/JXPzBp5rW4ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AwYAq+VNrnek2/NP4Px2IUPdmIq1uoofoJRk7dx+B5oEu5iKd4D+kBtz3DU1ztDcWVaKYVgoERE7Y8SJtzDV8EFYq44In0QVKs1KRjiYRsSji6URVgMNypFm5jallg/L6jVuHPcSt2Ztc8UVdjrjDoFoz8iEQyYOvqLN/dPztuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnhunaPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnhunaPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA99C4CEE3;
	Tue, 29 Apr 2025 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946622;
	bh=ar25cQXZkknTnrlI3R9tt1nFb3swPJ/JXPzBp5rW4ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnhunaPbPEq6u7Gf5v7rEMp61rJKiOTRZErktXwUoX1teYLDFvphyKNVOourpkm+G
	 vM7/cSnmDo7icOQZsOAz1/jDFeoQFrjO/MraYptXg2m36JjIvxsDn/Mgdr1gi1MPLK
	 504thHzGIOxpqc0bLkcAuzZnlr3GCjeHz0GkwxCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makarenko Oleg <oleg@makarenk.ooo>,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/286] HID: pidff: Convert infinite length from Linux API to PID standard
Date: Tue, 29 Apr 2025 18:38:40 +0200
Message-ID: <20250429161108.520676766@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 37e0591fe44dce39d1ebc7a82d5b6e4dba1582eb ]

Software uses 0 as de-facto infinite lenght on Linux FF apis (SDL),
Linux doesn't actually define anythi as of now, while USB PID defines
NULL (0xffff). Most PID devices do not expect a 0-length effect and
can't interpret it as infinite. This change fixes Force Feedback for
most PID compliant devices.

As most games depend on updating the values of already playing infinite
effects, this is crucial to ensure they will actually work.

Previously, users had to rely on third-party software to do this conversion
and make their PID devices usable.

Co-developed-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 07a9fe97d2e05..badcb5f28607e 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -21,6 +21,7 @@
 #include "usbhid.h"
 
 #define	PID_EFFECTS_MAX		64
+#define	PID_INFINITE		0xffff
 
 /* Report usage table used to put reports into an array */
 
@@ -301,7 +302,12 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 		pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];
 	pidff->set_effect_type->value[0] =
 		pidff->create_new_effect_type->value[0];
-	pidff->set_effect[PID_DURATION].value[0] = effect->replay.length;
+
+	/* Convert infinite length from Linux API (0)
+	   to PID standard (NULL) if needed */
+	pidff->set_effect[PID_DURATION].value[0] =
+		effect->replay.length == 0 ? PID_INFINITE : effect->replay.length;
+
 	pidff->set_effect[PID_TRIGGER_BUTTON].value[0] = effect->trigger.button;
 	pidff->set_effect[PID_TRIGGER_REPEAT_INT].value[0] =
 		effect->trigger.interval;
-- 
2.39.5



