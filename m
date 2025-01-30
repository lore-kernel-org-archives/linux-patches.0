Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F971E3775;
	Thu, 30 Jan 2025 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245597; cv=none; b=FpGLH93Fs2Q4fF8y7V1u2aLxAkGo8zX76Ba+NXdtJV17wJ2CzrEYj7Hhy9JqhDsDy/hdZeQ0qS/nHurlTW69iKnUTFzgJ27ySGt13HOj1Xhj1mg5bvjSo/aZAJdgDXs3QykQhzf12aJUFBgXFF1JKDbU9igGf6MtDLaHI5AGDdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245597; c=relaxed/simple;
	bh=NSfHs+EZmkefQgTEaN+EUTLO/45491pZMr4HQjBGQR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIDKXmnWwKlrTofmYk/KruF5cA4jWCb/3uBB6J1W9fGi5pUo00v/m7kDjKPV109MWWK9JawJgih9mVBmdigNM1DdZrmZmpP//0ytbV29KpYbPCxkE6w34BvxKVIOO51Yr6INE/Nlvw/kCAGw9CIG6cJeYmLta8YAOTYu8jY41T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaSAT5Jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaSAT5Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851E9C4CED2;
	Thu, 30 Jan 2025 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245596;
	bh=NSfHs+EZmkefQgTEaN+EUTLO/45491pZMr4HQjBGQR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaSAT5JwJ2uwRGqzJmYgHwhqXLi77qG1zF21Ce18zf1YaeWlxDafVyd9efMdD+cyw
	 aZtozPR2CE8BFb8m/CybXF1MFRD/dB6mIWld7MPyp2M0VyEAFuMZ78YV5AonUxyNTa
	 rrPoJK4MXnkcvFOWwNSHEhwXONokZqAiSXwimopA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 20/25] Input: atkbd - map F23 key to support default copilot shortcut
Date: Thu, 30 Jan 2025 14:59:06 +0100
Message-ID: <20250130133457.750762915@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,7 +89,7 @@ static const unsigned short atkbd_set2_k
 	  0, 46, 45, 32, 18,  5,  4, 95,  0, 57, 47, 33, 20, 19,  6,183,
 	  0, 49, 48, 35, 34, 21,  7,184,  0,  0, 50, 36, 22,  8,  9,185,
 	  0, 51, 37, 23, 24, 11, 10,  0,  0, 52, 53, 38, 39, 25, 12,  0,
-	  0, 89, 40,  0, 26, 13,  0,  0, 58, 54, 28, 27,  0, 43,  0, 85,
+	  0, 89, 40,  0, 26, 13,  0,193, 58, 54, 28, 27,  0, 43,  0, 85,
 	  0, 86, 91, 90, 92,  0, 14, 94,  0, 79,124, 75, 71,121,  0,  0,
 	 82, 83, 80, 76, 77, 72,  1, 69, 87, 78, 81, 74, 55, 73, 70, 99,
 


