Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D8A1E8855;
	Thu, 30 Jan 2025 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246850; cv=none; b=sJ0jb0kFB2kM/+9CNalUFPop/qP5IPjOJ98jhPWSzluEgg5lwJf3K9LX9+mQQn1TmDFu5pHaupdDMJ56xyacxzeoqfWyp3OBVRuFF+o8PEVL3wdB2I2StPEcPKD+izgbFXu8V1ixxhbZlVIeG52Z+e0UINhvQP0QvLRfUweHMZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246850; c=relaxed/simple;
	bh=G4tkHYke724t2E9MTefArUhwAKmRqaGQjRrUJv7Zigc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8iYyYVYd3h+jUdXV3TutJbXrQ8a9FlZllr0kllJGe/AyOJmy2wbHwiEpc5U8tW5+xO4xs6nQwJcOLBvOZNHQ0Cz+utLI1uRzEjEZpqgwtrhmtmS2btsb/JTLfo5GZOv4zN9IMf/5+dsNKKbAMMmCFQZVAgYHG7dZjsLeuip9To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkYaUVFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkYaUVFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61ACC4CEE4;
	Thu, 30 Jan 2025 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246850;
	bh=G4tkHYke724t2E9MTefArUhwAKmRqaGQjRrUJv7Zigc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkYaUVFJjngAz0VrKR7/z58w3tKo02wDOMJuJQ7CUWS4Pv6QeGMtX448AO15MjyLo
	 jJDel+5LzwbG/NMgRtjt+Y2xUmg3+7+sbLZcszXOYeKd8b5QrexBQsJN5IS5nDI9QC
	 fg5ksYrUbf4e9aLSNi/buHBtIiFjq5yqgFFUD3+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 89/91] Input: atkbd - map F23 key to support default copilot shortcut
Date: Thu, 30 Jan 2025 15:01:48 +0100
Message-ID: <20250130140137.262255720@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

commit 907bc9268a5a9f823ffa751957a5c1dd59f83f42 upstream.

Microsoft defined Meta+Shift+F23 as the Copilot shortcut instead of a
dedicated keycode, and multiple vendors have their keyboards emit this
sequence in response to users pressing a dedicated "Copilot" key.
Unfortunately the default keymap table in atkbd does not map scancode
0x6e (F23) and so the key combination does not work even if userspace
is ready to handle it.

Because this behavior is common between multiple vendors and the
scancode is currently unused map 0x6e to keycode 193 (KEY_F23) so that
key sequence is generated properly.

MS documentation for the scan code:
https://learn.microsoft.com/en-us/windows/win32/inputdev/about-keyboard-input#scan-codes
Confirmed on Lenovo, HP and Dell machines by Canonical.
Tested on Lenovo T14s G6 AMD.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250107034554.25843-1-mpearson-lenovo@squebb.ca
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -84,7 +84,7 @@ static const unsigned short atkbd_set2_k
 	  0, 46, 45, 32, 18,  5,  4, 95,  0, 57, 47, 33, 20, 19,  6,183,
 	  0, 49, 48, 35, 34, 21,  7,184,  0,  0, 50, 36, 22,  8,  9,185,
 	  0, 51, 37, 23, 24, 11, 10,  0,  0, 52, 53, 38, 39, 25, 12,  0,
-	  0, 89, 40,  0, 26, 13,  0,  0, 58, 54, 28, 27,  0, 43,  0, 85,
+	  0, 89, 40,  0, 26, 13,  0,193, 58, 54, 28, 27,  0, 43,  0, 85,
 	  0, 86, 91, 90, 92,  0, 14, 94,  0, 79,124, 75, 71,121,  0,  0,
 	 82, 83, 80, 76, 77, 72,  1, 69, 87, 78, 81, 74, 55, 73, 70, 99,
 


