Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E4B3B8409;
	Mon, 17 Aug 2026 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976389; cv=none; b=Oh5sEl085wEbgoE10RDYAzcI692q6f6/UcePbsagtk/3w6oW/kjdRwC0+/FOe5xN5+H8HCZ2cyUXdF4u0TONapbcco0s3zyac25RCo0o6TbDeusclpOdpdSsZuqM0WoRxRIyNVxzP7DHVy+OvSKR9qHntzwoLcF/ADco0mSJwVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976389; c=relaxed/simple;
	bh=hG2KILWoLLnLdJrGZVpWF6B8eW/pJQEGLxEYFYs85YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TReBI0lSy2ke72+JSS7r5kmbPUY9rV+8bQ6FOufCsvbwDrOqZrlefKdxq207GAbxxieovJWOjOSAG13vzQ/U3N7ED5lTWWU1h80heHnF9QcvzuIhY/d9RbqRyTAEFTicb1Ev4hJXUtJNvOYrQQHFn9McMIgPUHGsBLPH4jc3wxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlOOWfde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlOOWfde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76231F000E9;
	Mon, 17 Aug 2026 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976388;
	bh=NhM5M4E77Y23tDb0vSquP1L0QMlG0k4fXLbJLuoLp5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlOOWfde1VnK7TWQQqbzLO6yZby5I70lNI90wFYNYJealWOixkkeiwagm0RAOfx66
	 ga7XhXXXMcoE5mrKLwhHP+BttkStHmuJ10spugKonaR5QQHF6j6/aP28mDSOebrQsl
	 zDXPxiZOnCFQHBhTnDyyGzAMWmrzvlZgz/t1SQ70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 355/389] vt: stabilize tty reference in kbd_keycode with tty_port_tty_get
Date: Mon, 17 Aug 2026 15:33:14 +0200
Message-ID: <20260817132552.610761541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -1367,7 +1367,7 @@ static void kbd_keycode(unsigned int key
 	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 	int rc;
 
-	tty = vc->port.tty;
+	tty = tty_port_tty_get(&vc->port);
 
 	if (tty && (!tty->driver_data)) {
 		/* No driver data? Strange. Okay we fix it then. */
@@ -1430,9 +1430,12 @@ static void kbd_keycode(unsigned int key
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


