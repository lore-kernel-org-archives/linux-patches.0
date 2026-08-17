Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3E43E071;
	Mon, 17 Aug 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978171; cv=none; b=t1bPv7ktA8UFGiRn1CUFPVFrqcguu/MXP7n65ijqgRftAQTZIJabmam1GOnbqYqGbyHE4Q0wKnkDVj6DoAFNKiIDzL9zIUxs0+njk9agFxfNh61LHETbPB64RLH/DstvOrgyWUeaOTxl9WBL3FVY1vjixc/OLRCCq9we1ncLYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978171; c=relaxed/simple;
	bh=t4+SZdZFqWYw3GDRQQa6shOwhLp0XX4bTGCOceoEEjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJSTETk9hsWVuQC+uKDk7mv7pCC4T4taWQ3JgM8Ca0T7ZPXFdhHKEbTKgPMLjg8Rf9CQXExDEr/5IqKMrMhioNcF3nKD2TJvPa24VgHWKMY3WiFnieL/ZffXrKGua8ovhl2l413/cP5ptsSVyiB25HiGNCBpszQD/Qjh10eQuQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpY5cpf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpY5cpf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370011F000E9;
	Mon, 17 Aug 2026 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978159;
	bh=hR0fqtvKpASZ0SeUxA6VWI1jhyg2K1npQ+F7On8GN1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpY5cpf930blsXskpU4Dgd0wE3KyONBzaio9FN4Nhg3d8OAf7KCbHxLTbaYa0AZO9
	 anJYa1SdkPhIKs43kj9hc/xrNuCMagdXdPIpePZwQwpdGhNRm6b/rHPryhhR9SFZbm
	 3MMJO7IO8ySTWhF5XUu8TGmjWsm6MFzy28iNDt5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 083/181] vt: stabilize tty reference in kbd_keycode with tty_port_tty_get
Date: Mon, 17 Aug 2026 15:32:57 +0200
Message-ID: <20260817132538.705889811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit e25d47a526939ad44b75f778b8a7500562b84fc1 upstream.

kbd_keycode() reads vc->port.tty without acquiring a tty reference,
racing against con_shutdown() which clears port.tty under a different
lock. Use tty_port_tty_get()/tty_kref_put() to hold a proper reference
for the duration the tty pointer is needed.

Assisted-by: AISLE:Snapshot
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260731-tty-vt-stuff-v1-1-be99b9da8e30@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/keyboard.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1403,7 +1403,7 @@ static void kbd_keycode(unsigned int key
 	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 	int rc;
 
-	tty = vc->port.tty;
+	tty = tty_port_tty_get(&vc->port);
 
 	if (tty && (!tty->driver_data)) {
 		/* No driver data? Strange. Okay we fix it then. */
@@ -1463,9 +1463,12 @@ static void kbd_keycode(unsigned int key
 		 * characters get aren't echoed locally. This makes key repeat
 		 * usable with slow applications and under heavy loads.
 		 */
+		tty_kref_put(tty);
 		return;
 	}
 
+	tty_kref_put(tty);
+
 	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
 	param.ledstate = kbd->ledflagstate;
 	key_map = key_maps[shift_final];


