Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1A4446BEA;
	Mon, 17 Aug 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980361; cv=none; b=Lxiy2w+1llLpsb70mh4FtgEOtNNtQnIsdSHm+ofLoMfv8zO9p9txJiy7PiqZDeW6KG87V8O+MD3Et+hAcBqN5Zosywd+rqUx/7nuGacgmdnfZwxw7CiD2iTEH5vDItChd1MUGSWlfcTk6XkA9K0avRJc8UbNI429ZZ5Xf5G6jN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980361; c=relaxed/simple;
	bh=TPDRxmMVE5Fy6/Fmg/s9zcYmE6MctFQtNKV2bQHYz50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4cEeGM6HotV3nszv5AookiGMozC2L6FV8X8ludanGZ5v8k8XgA1QfwvrRgy+lSqD9MNcmCVehrUOh61w9qJBGORLt8Y7Ocm73BkxwVzKXF/LV7rF613VuZun/jLt7Z8P/o7353Lihog5mbxYAHNFG8i7yDMdbwrhgQU0XOUicE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUe0GH9d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUe0GH9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784B51F000E9;
	Mon, 17 Aug 2026 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980360;
	bh=ZwR7WdvDvF4wpDFP5p2a+dKxaR11b3BcAfe7/cgDDBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUe0GH9dthIa+vVs9I6mYc7BMbv7ubwQ+lPzyckhN51sAC3q1sgoFeFH0MJhMt2jK
	 9bAG251j6jU0nbo462iseHaoruUWujiwkIRFM7a9MV3O/yD7k9Q0tor07maGw4Q//j
	 oRRpnxmlecOAlwUUAjowUDSyw92daQDEycd116TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 546/609] vt: stabilize tty reference in kbd_keycode with tty_port_tty_get
Date: Mon, 17 Aug 2026 15:34:02 +0200
Message-ID: <20260817132602.031430662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1405,7 +1405,7 @@ static void kbd_keycode(unsigned int key
 	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 	int rc;
 
-	tty = vc->port.tty;
+	tty = tty_port_tty_get(&vc->port);
 
 	if (tty && (!tty->driver_data)) {
 		/* No driver data? Strange. Okay we fix it then. */
@@ -1465,9 +1465,12 @@ static void kbd_keycode(unsigned int key
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


