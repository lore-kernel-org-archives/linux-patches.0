Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113E8255F2B;
	Mon, 23 Jun 2025 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684968; cv=none; b=KKZ2w/3XehL1ylTtnrYl4ieAb4R01lO6B5l5OCzOSM2HnbH6V+tNJpzRkxnk3MrN8R4xo907fwk18ZsTs+49NKw/tbY3gLRT0BqGj1WXICl5UnREK9iYWGzF0wntkk5Sokg+MdR2qcUyPpp5FszCPya5Mx7PLOcHCv+0zzydIoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684968; c=relaxed/simple;
	bh=gS5eck2fQz2XeCHZZMEW4KqUPtG979GQShpdyd2Pnro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbcUT/zYuIWTCAfoemYmIPKxqElQmekHBZl9DA+igIqMDjZU7xf5PWZ4BB0O6naN7adEasiHPCpbR2VrVd+owTprNEC3/KT4vlj394+QCxytY5dxjl7E87V862K7/tsbhS6HstAMMo51+rnvh6cjXhw2jBsUuZhGaMlj1n3HZyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBnj0vsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBnj0vsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D31C4CEEA;
	Mon, 23 Jun 2025 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684967;
	bh=gS5eck2fQz2XeCHZZMEW4KqUPtG979GQShpdyd2Pnro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBnj0vsjUK7HZdZ1yZI/nRonrAODKZ2xRm51wpbS81JkqhmHef/zIwJgM0CRPk9Gx
	 e8TCnLjnaIQV77Me2jD2qpb8N1GwOu0e+OvP6LpWbfRxu8kUxrnyotaLjV2vWz3F2Z
	 e2bHbGgQJiUWaVMfGgTYXrwE0GDlJlYa08B4XJ9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Andrei Borzenkov <arvidjaar@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.15 196/592] dummycon: Trigger redraw when switching consoles with deferred takeover
Date: Mon, 23 Jun 2025 15:02:34 +0200
Message-ID: <20250623130704.951858026@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 03bcbbb3995ba5df43af9aba45334e35f2dfe27b upstream.

Signal vt subsystem to redraw console when switching to dummycon
with deferred takeover enabled. Makes the console switch to fbcon
and displays the available output.

With deferred takeover enabled, dummycon acts as the placeholder
until the first output to the console happens. At that point, fbcon
takes over. If the output happens while dummycon is not active, it
cannot inform fbcon. This is the case if the vt subsystem runs in
graphics mode.

A typical graphical boot starts plymouth, a display manager and a
compositor; all while leaving out dummycon. Switching to a text-mode
console leaves the console with dummycon even if a getty terminal
has been started.

Returning true from dummycon's con_switch helper signals the vt
subsystem to redraw the screen. If there's output available dummycon's
con_putc{s} helpers trigger deferred takeover of fbcon, which sets a
display mode and displays the output. If no output is available,
dummycon remains active.

v2:
- make the comment slightly more verbose (Javier)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Andrei Borzenkov <arvidjaar@gmail.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1242191
Tested-by: Andrei Borzenkov <arvidjaar@gmail.com>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 83d83bebf401 ("console/fbcon: Add support for deferred console takeover")
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.19+
Link: https://lore.kernel.org/r/20250520071418.8462-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/dummycon.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/video/console/dummycon.c
+++ b/drivers/video/console/dummycon.c
@@ -85,6 +85,15 @@ static bool dummycon_blank(struct vc_dat
 	/* Redraw, so that we get putc(s) for output done while blanked */
 	return true;
 }
+
+static bool dummycon_switch(struct vc_data *vc)
+{
+	/*
+	 * Redraw, so that we get putc(s) for output done while switched
+	 * away. Informs deferred consoles to take over the display.
+	 */
+	return true;
+}
 #else
 static void dummycon_putc(struct vc_data *vc, u16 c, unsigned int y,
 			  unsigned int x) { }
@@ -95,6 +104,10 @@ static bool dummycon_blank(struct vc_dat
 {
 	return false;
 }
+static bool dummycon_switch(struct vc_data *vc)
+{
+	return false;
+}
 #endif
 
 static const char *dummycon_startup(void)
@@ -123,11 +136,6 @@ static bool dummycon_scroll(struct vc_da
 {
 	return false;
 }
-
-static bool dummycon_switch(struct vc_data *vc)
-{
-	return false;
-}
 
 /*
  *  The console `switch' structure for the dummy console


