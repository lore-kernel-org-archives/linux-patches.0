Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6589399375;
	Thu,  2 Jul 2026 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009515; cv=none; b=mFE8p14rFANgGFlI23JXoTJ1wzj/zTSCNTzUtTzAoObbFz6l7W0Zi9hkL7VP0XEycuee0uOaNKlZnQyU04ipAyv9LdBe7Aj9nGAzJZ19plN0B/hnpJqHMVJQCNFQqdsUFB76H9GfPCRbUm9vYq2b1al3G2Ej3zqgikRDfdm53BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009515; c=relaxed/simple;
	bh=aVZldMx04Ne8WEBk1bYtt779d2/hjVXwCAmTdix/kXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUCG0hhtcKlOMwzVRQ2rLNhn0IJRfdiMbPGUPOA04NlKZExTkXe+9Fqa82W/zP9bMTx90m8pepPG+au0shnFoY/UT97rnUbEgyDake0j7KkkuK4JaucgWEA6q8JDwQqDm/v8CODnqK/wSuSdcFCgJEOuhd9WEMEd/T3JyIKZc+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+2qkqgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+2qkqgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C501F00A3D;
	Thu,  2 Jul 2026 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009507;
	bh=0OOAl+H0bjAkaa1+tTvdYdVvAJkK6YwYBTwAuh9qeyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+2qkqgqRucD9sZJYGJOMFebHRmwW1NCzcLIbdee/tu3vhwBskIRgReP4HlJJiP8p
	 djM+P+A10H54A2Ww6iJHBjH/adZOB7l6NQeD2KP//v8NBbZiq25VC+eOAsgRsa/vuP
	 0Pk4Zib8e4CZkqR9cu9vOQ7IcJcwbt/aVBq75hI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 77/96] fbdev: Fix fb_new_modelist to prevent null-ptr-deref in fb_videomode_to_var
Date: Thu,  2 Jul 2026 18:20:09 +0200
Message-ID: <20260702155110.601919662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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
@@ -1989,6 +1989,18 @@ int fb_new_modelist(struct fb_info *info
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


