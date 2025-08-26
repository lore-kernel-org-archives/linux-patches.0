Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2B61D5CD4;
	Tue, 26 Aug 2025 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218010; cv=none; b=CaouFa4+f0PzFVR11scvc4tnLuGrkgOFLYTaHzJ7d8xJo+c+0hXuRRMCUHfOh9kTw3CE3Hs/VqX3/Xd8TXsS89uIJPtJKSPg47d2IvY6ZRXfWcRrEjUHb7bMLfCxWy7M2Zj8a3ICM/rEJvb8tJy1jRFCnZNiMJcX4rJ+cLz5L3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218010; c=relaxed/simple;
	bh=U2YDY2A8wXqt+v9sZLoUwn9Fix/LqkOJ5NqCGrYnNOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rm6qjppDbfJH5+TS9tVIZbFlTc1P510Nx4Jt9RVnavgnWIhzgI+ccDtxMf/qOfwKvQLivBj2JJmm4kCcmdJNktSIfeg6fg8hyiEH2eJDVb2yjhv/k74LFqkVcGjhUlLnK3l4zWOOkP7kM6ci85uX9C0AEtogGfn/wdLaLYi71VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=td7Gghl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="td7Gghl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9553AC4CEF1;
	Tue, 26 Aug 2025 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218009;
	bh=U2YDY2A8wXqt+v9sZLoUwn9Fix/LqkOJ5NqCGrYnNOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=td7Gghl8P/agrwsdRqIeJHVJDro/Et1N88oDA3uK+3bHArhdH5ks/iHgYGbzwuNqw
	 ixHoJHz90T8SGlxGEA31Hu4uwvGxu+ezF01U/v0bzqOHm1Qgu0n6tGaUvd67GFV12s
	 ycAqYzlRXM2iu8eNtultutbGJaUzVkLncDBjgW7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.10 359/523] vt: keyboard: Dont process Unicode characters in K_OFF mode
Date: Tue, 26 Aug 2025 13:09:29 +0200
Message-ID: <20250826110933.326026923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

commit b1cc2092ea7a52e2c435aee6d2b1bcb773202663 upstream.

We don't process Unicode characters if the virtual terminal is in raw
mode, so there's no reason why we shouldn't do the same for K_OFF
(especially since people would expect K_OFF to actually turn off all VT
key processing).

Fixes: 9fc3de9c8356 ("vt: Add virtual console keyboard mode OFF")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Cc: stable <stable@kernel.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250702-vt-misc-unicode-fixes-v1-1-c27e143cc2eb@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/keyboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1461,7 +1461,7 @@ static void kbd_keycode(unsigned int key
 		rc = atomic_notifier_call_chain(&keyboard_notifier_list,
 						KBD_UNICODE, &param);
 		if (rc != NOTIFY_STOP)
-			if (down && !raw_mode)
+			if (down && !(raw_mode || kbd->kbdmode == VC_OFF))
 				k_unicode(vc, keysym, !down);
 		return;
 	}


