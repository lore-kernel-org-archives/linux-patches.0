Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD75493656;
	Wed, 23 Sep 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173822; cv=none; b=BAzSHuYuA2Mcyp5e7FwPVnWGoJqzsVe6qUuEa32/n3f/WVgDjT0MGJSp+1NN27TnoSYupGuDxZoEST3jQIRNs3NfTXSJulseMgi86fewIYcYpS757UM6xpdRWTPiaXNbcnwbt1pjLbB/LUbeRFcraN9+xSsFgCEZlQij9jk+UiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173822; c=relaxed/simple;
	bh=gumlYEznJCOc0lItduiFVP0vZOA8VtKrn6Ns2elvK1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5NjN1Rcg2o6ux7S5mzQTD3pOAvEUBcENt9dMevHEQEJ1OiCZC6pnP9hxZyJsARZhWbVrBMl4MCsht+4zkv0Z6Z5cl1r8BZZ3dl4lIVKAQcMeSeXccqhEGLrneeFqFPOyLrzpYifS6weFDxJip/AZhNvzz7hanzfKW2i+xyIn9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H87ul1m9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H87ul1m9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DE41F000FF;
	Wed, 23 Sep 2026 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173821;
	bh=vZU+/043HeyuO6+bP4E+AbP15VBya081FE+iCozLzq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H87ul1m9OtOti+iaQao02SSLhk77nQ3voobfu8vq1e70oCR1aj+NjQ5k/LFGVhU0Z
	 xVVd1EjE1Eb1uSa+kgOSFJMJd3szLO+OqQCqlDsT4GtdcPBB0SEBsiNFd51f6Wl81e
	 90Y0Q3UR8tXFoBOwVS7b8qmQm38YkFSgDRMbdAOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Turtanov <9alexei9@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 354/438] Input: atkbd - skip deactivate for Xiaomi Redmi Book Pro 16 2026
Date: Wed, 23 Sep 2026 16:06:15 +0200
Message-ID: <20260923140654.010797869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Turtanov <9alexei9@gmail.com>

commit aefbda23eeba234c3ff0f135dc5be6e294bd25a6 upstream.

The internal keyboard of the Xiaomi Redmi Book Pro 16 2026 (board TM2425)
does not work: atkbd_probe() succeeds and every command is ACKed, but no
scancodes ever arrive afterwards.

Testing on the hardware through serio_raw shows that ATKBD_CMD_RESET_DIS
(0xF5) is the culprit. After 0xF5 the embedded controller keeps ACKing
commands but stops delivering scancodes, and neither ATKBD_CMD_ENABLE
(0xF4) nor ATKBD_CMD_RESET_BAT (0xFF) bring them back. Only re-enabling
the keyboard interface at the controller level (i8042 command 0xAE, or
rewriting the command byte as i8042_port_close() does) revives it.
Running the init sequence without 0xF5 (0xED 0x00, 0xF3 0x00, 0xF4)
keeps the keyboard working.

'i8042.dumbkbd=1' also works around this, but then the driver never
writes to the keyboard and the LEDs cannot be controlled. Use the
existing atkbd_deactivate_fixup quirk instead, as done for the sibling
TM2424 by commit 3a046db33bb9 ("Input: atkbd - skip deactivate for
Xiaomi Book Pro 14's internal keyboard"). Tested on v7.2: keyboard,
Caps Lock LED and s2idle suspend/resume all work.

DMI: XIAOMI REDMI Book Pro 16 2026/TM2425, BIOS RMAPT6B0P0909 05/22/2026

Fixes: 9cf6e24c9fbf ("Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID")
Cc: stable@vger.kernel.org
Signed-off-by: Alexei Turtanov <9alexei9@gmail.com>
Link: https://patch.msgid.link/20260828112239.18081-1-9alexei9@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1954,6 +1954,14 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
+	{
+		/* Xiaomi Redmi Book Pro 16 2026 (TM2425) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "XIAOMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "REDMI Book Pro 16 2026"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 


