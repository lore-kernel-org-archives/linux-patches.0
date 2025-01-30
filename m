Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B571E1E522;
	Thu, 30 Jan 2025 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247314; cv=none; b=uea0POnh+PrvgZFjWT18IFSLb48ffAzbvqHD1qJUxEbvndV1yIXGONa+zAAQF0AvtMmy1qywhubeegI+FWDg5+cLF4BY6pjW5BzahouswITjbkdGGgDw0wyGYvMwtyHVJt9l4txNM7lx7WQzXSFBY0860LTg58nqoG6F625KIQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247314; c=relaxed/simple;
	bh=zhi0NJYFk+7JtpKfZ86At0kmrthBmMsaHUXGuXeug50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb6zl7iKQ+AIpyo2t4owMbm/evVYPCI+BvpNQMCCFYz/N+vB0HAWvyp7dsAQ68B3mvL7JHptKpriYJYAGb7C4MbgJb6nmrdcBdl1gFAkDnObf1qxq2nqSXrkXK46e+rvFWgkT+sw7aKwG4OJTU5GYzMZ8fmbhfPTyElF9KeuwOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbBg7Kcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbBg7Kcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A112C4CED2;
	Thu, 30 Jan 2025 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247314;
	bh=zhi0NJYFk+7JtpKfZ86At0kmrthBmMsaHUXGuXeug50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbBg7Kcf2r/ZpRjfKawU16HeMh3GN8unmammS+55E7P8HWQqswsUOu5Xdm2mxDEgD
	 yacIAV2RJtuIuXisUPzRsMhQni09xXoLPiNqR6K5U9dRAaWTCiOm5QPUFF7OniuaNq
	 k1mtNFuzYzF97CEcLMAoAQF+MX8qdNst+TluVv5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 22/24] Input: atkbd - map F23 key to support default copilot shortcut
Date: Thu, 30 Jan 2025 15:02:14 +0100
Message-ID: <20250130140128.177813970@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -90,7 +90,7 @@ static const unsigned short atkbd_set2_k
 	  0, 46, 45, 32, 18,  5,  4, 95,  0, 57, 47, 33, 20, 19,  6,183,
 	  0, 49, 48, 35, 34, 21,  7,184,  0,  0, 50, 36, 22,  8,  9,185,
 	  0, 51, 37, 23, 24, 11, 10,  0,  0, 52, 53, 38, 39, 25, 12,  0,
-	  0, 89, 40,  0, 26, 13,  0,  0, 58, 54, 28, 27,  0, 43,  0, 85,
+	  0, 89, 40,  0, 26, 13,  0,193, 58, 54, 28, 27,  0, 43,  0, 85,
 	  0, 86, 91, 90, 92,  0, 14, 94,  0, 79,124, 75, 71,121,  0,  0,
 	 82, 83, 80, 76, 77, 72,  1, 69, 87, 78, 81, 74, 55, 73, 70, 99,
 


