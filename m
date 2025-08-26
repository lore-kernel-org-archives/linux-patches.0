Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF0F22A4E5;
	Tue, 26 Aug 2025 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213514; cv=none; b=b7xUbSONxwZjQpV1ObPVs+Q0rZnIhm9XTJu652hxsj8YBI/oOSVIeDdZH/8nSVUXpiNysfDyWeE/EBlq5DCD7odjAgmzCbMo5AAhNTQZZ/XTsYjLrxZCBZwkeqXg1IU7o3QHurX8gOAEmFpJs5ds+DR8pGg5BSee6yhBWIYyH6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213514; c=relaxed/simple;
	bh=AoabVf4hnx2UgB8EiJiWoO2AnIQRuznsKTRv87QjV9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg0JePkJtUkEzBUIKOUG7j6ni21CXIBrQunDwZzWaOoiwR7znIPgT19ANX9NWzDVUwnf6AuZpLbqkouU6+IIJ0QNjwrIay/h9DLGlh5Z14fkOg1lZJvPjhU5hxjiNPGL0vxoSnKPOGYhCdWELQK7TC7sKyooMMazpLgtAHdXKAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2npzDnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2npzDnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22433C4CEF1;
	Tue, 26 Aug 2025 13:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213514;
	bh=AoabVf4hnx2UgB8EiJiWoO2AnIQRuznsKTRv87QjV9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2npzDnqqLBCTdW4a82CahQM/0K8wgivPl/kM+U+iEtgAPXebR5xP4OYqat1xH7c3
	 BLZOP2VKfXz/tSb0ppAdXkDi8F91CG/XOR9ZGUqh4IoejtPtUEUZZskp95tJxEiQCv
	 kyQzbj3nL0lwGLKtSnLe7XLTyuG3WFfmjo+GR33Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.6 339/587] vt: keyboard: Dont process Unicode characters in K_OFF mode
Date: Tue, 26 Aug 2025 13:08:08 +0200
Message-ID: <20250826111001.540060939@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1496,7 +1496,7 @@ static void kbd_keycode(unsigned int key
 		rc = atomic_notifier_call_chain(&keyboard_notifier_list,
 						KBD_UNICODE, &param);
 		if (rc != NOTIFY_STOP)
-			if (down && !raw_mode)
+			if (down && !(raw_mode || kbd->kbdmode == VC_OFF))
 				k_unicode(vc, keysym, !down);
 		return;
 	}


