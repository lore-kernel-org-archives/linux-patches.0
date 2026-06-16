Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05782C0261;
	Tue, 16 Jun 2026 18:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634398; cv=none; b=f3B8S/bgnwYJhlE3uk2CFltNWo5WRuSTR8/RKFNPoanXVl1NL4e7uBw7Qh2oof7shlXTrcXyAXgzybYrF/JPi4OhB9+whm3gL8Lof1ZnfdDKt0s1JxSbifBZtjerzTbROokg0j8gZMXBxVasne0C3YWZycRuDjOKoR3nZn+6+Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634398; c=relaxed/simple;
	bh=NQ6jKhtZZTE6iJYmDfp0Xbma8S/hdLONa5Qj2ky9yaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8m80EFVsoDyu4UlxUxSMDh5OVJK5w3vM5762bKNtUvrXcv67Nrtgd5QeU1/F9wpx4W5ZRNa/sYgWSFvHCJtadkzCy31XxOgCVGqC2MnRmOgGHGVyTTOcv+qaW03x8k8Ud418KTak2aNZGyTJbCkw3CkBP+CIMu42F4Vo0p5YlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn03e5ur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn03e5ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAE41F000E9;
	Tue, 16 Jun 2026 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634397;
	bh=8+xKuqAoJWDbgc+syABjoQeesdgRgAwUfT1vU8RRibo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn03e5ur1Y6mPtdCz+SHzjFM0TnNS414BTE3+N6a6WosLNETwYJTGzz9+Uh5Tx5NN
	 v/1rDYJIX/HNC5Nd6j2LdN+jZ/uB2HdZBmpzsqiCaLAI095kc4t0d8DxTdI6RSygEQ
	 1zPCIrM6oZ+spRpTA8jvYrU1PJrBv4n/zXPLToRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeyu WANG <zeyu.thomas.wang@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 224/411] Input: atkbd - add DMI quirk for Lenovo Yoga Air 14 (83QK)
Date: Tue, 16 Jun 2026 20:27:42 +0530
Message-ID: <20260616145112.703410545@linuxfoundation.org>
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
@@ -1939,6 +1939,14 @@ static const struct dmi_system_id atkbd_
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
 


