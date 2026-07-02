Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A853A5430;
	Thu,  2 Jul 2026 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010628; cv=none; b=nbQnJ7uZQ8X7jo6KEtHM8XrVOze7dkFcOtgGMHKqCWYRvBSk+f9iIcf0XrhBaFvFiNlVamAVl9A0IL7JunVmUoY4wSji3ayP55hto4DmpLesogWnsf69qQ3yLUiSVt6y4YbTJ8wMO4goK+v1b4+/KbaGnSgFnQc8eSdnf3Q+CGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010628; c=relaxed/simple;
	bh=HUgM5jOt3lUrIQpk4RhYLrBNqwZ8LuHxwtxOs5gdnlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Au4jBJCcmsMwCNixpXjeahgApX2np4iVgHJsLPWRsgXWVILz2IIOip0R7rEifG8Erl+w+utaz4W3PY9dQai3yuAoh7CJLhMqculpnWW0VBrHIIGYj37KdSnawoUyGVyWZZwuFJHZKnsSzKkIyE1H8SOAN3th+q6xBeyVMOLjxIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aqgRGGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aqgRGGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6521E1F000E9;
	Thu,  2 Jul 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010626;
	bh=9y3lgDYbGV7amNJ0ARqoQ/uyhYf9WlGuCRYHZ4hAJxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0aqgRGGLk2uZ88c55KfpllEzvZVIZYDFb7jcdZUixlmtN3fKySZEFBT+qTzYUvvZo
	 ojMS2gstkNh223kSUIKU7XYcF4xyreafdtbn0AyoaFtyYWjLRkwK7NrSInjh9cFLoj
	 +yyFlbjgMgL++w5HvBFRkoRXcEvBNxKNev8EZxv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 181/204] fbdev: Fix fb_new_modelist to prevent null-ptr-deref in fb_videomode_to_var
Date: Thu,  2 Jul 2026 18:20:38 +0200
Message-ID: <20260702155122.449618877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

commit 7f08fc10fa3d3366dc3af723970bd03d7d6d10e3 upstream.

info->var, a framebuffer's current mode, is expected to have a matching
entry in info->modelist. var_to_display() relies on this and treats a
failed fb_match_mode() as "This should not happen". fb_set_var() keeps it
true by adding the mode to the list on every change, and
do_register_framebuffer() does the same at registration.

store_modes() replaces the modelist from userspace. fb_new_modelist()
validates the new modes but does not check that info->var still has a
match. It relies on fbcon_new_modelist() to re-point consoles, but that
only handles consoles mapped to the framebuffer. With fbcon unbound there
are none, so info->var is left describing a mode that is no longer in the
list.

A later console takeover runs var_to_display(), where fb_match_mode()
returns NULL and leaves fb_display[i].mode NULL. fbcon_switch() passes it
to display_to_var(), and fb_videomode_to_var() dereferences the NULL mode.

Keep the current mode in the list in fb_new_modelist(), the same way
fb_set_var() does.

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -680,6 +680,18 @@ int fb_new_modelist(struct fb_info *info
 	if (list_empty(&info->modelist))
 		return 1;
 
+	/*
+	 * The new modelist may not contain the current mode (info->var), and
+	 * fbcon_new_modelist() below only re-points consoles mapped to this
+	 * framebuffer. Add the current mode here so info->var keeps a match
+	 * even when fbcon is unbound.
+	 */
+	if (!fb_match_mode(&info->var, &info->modelist)) {
+		fb_var_to_videomode(&mode, &info->var);
+		if (fb_add_videomode(&mode, &info->modelist))
+			return 1;
+	}
+
 	fbcon_new_modelist(info);
 
 	return 0;


