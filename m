Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D3F376BCC;
	Wed,  3 Dec 2025 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780507; cv=none; b=Rl5I6MnwCAXq7rLUvmErE2FajV2GA1VNnXYjU4NN3IwId9Vo+y+Qi5SgBJpTOlJqPyq6NoGQPicL3jHRasK+pyz8i/iiqJ+z+iCHCyFbBEWFrQ+ZtqvUbsFAdkrv2IbRcJjv8OI7m1Xxm9zlhCDd8s/nZYh+9t6sUpMISSmaQj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780507; c=relaxed/simple;
	bh=FCvoBqRWDm7u4KVA6H82r/WWxo/Fs5MrneDMG13HemI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU1FXXwHBpu0BA1bniCwSjR99vU1IpUuFn95llrAo+RlBg5isFQyNtOO6qxM6kgdg/HYm6EOQm9SRxCy0wIVfIw4x8/Hc+D/4t0IKBgce0LrTMmakNj4X0X4JqMDcTyFzCqQhPrseG7dTfxDYbc7mcX5vYETVauRZb4bxsiflwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uRUXMR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uRUXMR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3669C116C6;
	Wed,  3 Dec 2025 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780507;
	bh=FCvoBqRWDm7u4KVA6H82r/WWxo/Fs5MrneDMG13HemI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uRUXMR3KKWQ9T3MPwtxer9VzWV8QvtQN4wgHbAHVxdel168vX09HoTSQ7Naxap6k
	 Nc1On1RJBmYZnbJ0DOJa8KqByIqB2i7aH3RYCLz3wUsAH3VY9dJeHxnABCK4XcTD7m
	 gKWGxH44Pig0C8jzTgwQbu9c6U1eVeFoGOixO7ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.1 568/568] HID: core: Harden s32ton() against conversion to 0 bits
Date: Wed,  3 Dec 2025 16:29:30 +0100
Message-ID: <20251203152501.554151430@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit a6b87bfc2ab5bccb7ad953693c85d9062aef3fdd ]

Testing by the syzbot fuzzer showed that the HID core gets a
shift-out-of-bounds exception when it tries to convert a 32-bit
quantity to a 0-bit quantity.  Ideally this should never occur, but
there are buggy devices and some might have a report field with size
set to zero; we shouldn't reject the report or the device just because
of that.

Instead, harden the s32ton() routine so that it returns a reasonable
result instead of crashing when it is called with the number of bits
set to 0 -- the same as what snto32() does.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/68753a08.050a0220.33d347.0008.GAE@google.com/
Tested-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Fixes: dde5845a529f ("[PATCH] Generic HID layer - code split")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/613a66cd-4309-4bce-a4f7-2905f9bce0c9@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
[ s32ton() was moved by c653ffc28340 ("HID: stop exporting hid_snto32()").
  Minor context change fixed. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1354,7 +1354,12 @@ EXPORT_SYMBOL_GPL(hid_snto32);
 
 static u32 s32ton(__s32 value, unsigned n)
 {
-	s32 a = value >> (n - 1);
+	s32 a;
+	if (!value || !n)
+		return 0;
+
+	a = value >> (n - 1);
+
 	if (a && a != -1)
 		return value < 0 ? 1 << (n - 1) : (1 << (n - 1)) - 1;
 	return value & ((1 << n) - 1);


