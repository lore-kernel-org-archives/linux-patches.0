Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C71723C51D;
	Mon, 17 Aug 2026 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977694; cv=none; b=Rp+tDaGoSTm02Eqp7GKsIVhBAzQEJwaFYAfzykqS6CVaqxvd0/l95rsIRr5+TBY6rx6o1bLYxHO8s51ahtjGFZiMW89+LaPB4A+vrknXQDMX0Sah6FMETe0O4sylqkOdZkNThOsTLwohwjfog8rH+Ke7YNyFDDlGTKvAym6wFak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977694; c=relaxed/simple;
	bh=QSPitY6DC8rQHtH689EqL7tumkxJrNkIdbzUvRRCyg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WozOjCMoiPYiBjmZnM0M27fijDDaKdngkouFKz41y7KxV8rvk1mom7RkgQnoztpyU7ufhV3Q8kQ7T7xzgDIcssFFNKDfG7PaRxGtIoeoR+TdBxL3eUeO/jX3G9Ttzr0E5LzhqcwfwQsC7eFbg8+CARH0gz3XIHwM7dPnfPVTekM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2V0+YHHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V0+YHHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64A61F000E9;
	Mon, 17 Aug 2026 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977693;
	bh=AdCeIoNdkcHXhZh2I0nQ1faTKkTQ+c7JWyHk6CMCqeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2V0+YHHBvDOqWgqQdHscLp8eEc1AbNVBFEnVhLAk7N7Vwiw2XwO2Dw9nlaPhKA1zj
	 XvJvEQSs0e8xxRUF3Zt8+Iuu8efNF/M0vcQJTsWapZrKaBq7mAmGG4NxW1O/Ckb590
	 Ryi0W72ZP/Q2J2LRNCglpQ+lPLH8Kz0VH64fOtPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 417/456] vt: stabilize tty reference in kbd_keycode with tty_port_tty_get
Date: Mon, 17 Aug 2026 15:33:27 +0200
Message-ID: <20260817132555.527824871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -1393,7 +1393,7 @@ static void kbd_keycode(unsigned int key
 	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 	int rc;
 
-	tty = vc->port.tty;
+	tty = tty_port_tty_get(&vc->port);
 
 	if (tty && (!tty->driver_data)) {
 		/* No driver data? Strange. Okay we fix it then. */
@@ -1453,9 +1453,12 @@ static void kbd_keycode(unsigned int key
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


