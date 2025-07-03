Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FBA2C3266;
	Thu,  3 Jul 2025 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555591; cv=none; b=L6y3+2vPvz9wkFFZeGRYfeVwmKIZovsoGqrtqthV3GBLmd+9VSav9gqavDxaD2+/GdTt5GBVUP8Z3eCpNzRqT2cv3YG+FW5lnevxmlWZC5Y5yMIOk8AQjeNRiZ77Bd+Do9v8pfx56eS0DNqavaQ/AHPsjNsLqNCZKNYFnydiAWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555591; c=relaxed/simple;
	bh=kPRRQIdajowrvuWvSfLhZYiUYr95/9iEWlCK9lgEiMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFwoIZmaFyh1xLAMyd7l1Ify4bwcfuba4gjdHzTVSVXU2cisNlYE5vns4SVQBRceFbKHoZlUphTyyZy4Vj7MYew/12U1z3j4mCpHBgg4+H54Lq1I9/9SwKvRxMiOeaYlITTlqTofyz/ny9FeuJNATF6LexSUbfAodQrO3bzmJW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OW9YnW2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OW9YnW2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4206AC4CEE3;
	Thu,  3 Jul 2025 15:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555591;
	bh=kPRRQIdajowrvuWvSfLhZYiUYr95/9iEWlCK9lgEiMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW9YnW2JQuVXEoj632+yixv4wSot7Taq6qwK920p5zkNajOmwPQ2s/DmCB+twNkee
	 8aMXhgl+K+zChk0Yera9SMajZInygRcjjGeVMODYZjiKbGRO+dA83TTzNKbh9wlI0P
	 kPTVUi59WNESKJ+RPEk4Da3tFXZw86dmG1qch4CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Andrei Borzenkov <arvidjaar@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/139] dummycon: Trigger redraw when switching consoles with deferred takeover
Date: Thu,  3 Jul 2025 16:42:04 +0200
Message-ID: <20250703143943.553875999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 03bcbbb3995ba5df43af9aba45334e35f2dfe27b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/console/dummycon.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/video/console/dummycon.c b/drivers/video/console/dummycon.c
index d701f2b51f5b1..d99e1b3e4e5c1 100644
--- a/drivers/video/console/dummycon.c
+++ b/drivers/video/console/dummycon.c
@@ -82,6 +82,15 @@ static int dummycon_blank(struct vc_data *vc, int blank, int mode_switch)
 	/* Redraw, so that we get putc(s) for output done while blanked */
 	return 1;
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
 static void dummycon_putc(struct vc_data *vc, int c, int ypos, int xpos) { }
 static void dummycon_putcs(struct vc_data *vc, const unsigned short *s,
@@ -90,6 +99,10 @@ static int dummycon_blank(struct vc_data *vc, int blank, int mode_switch)
 {
 	return 0;
 }
+static bool dummycon_switch(struct vc_data *vc)
+{
+	return false;
+}
 #endif
 
 static const char *dummycon_startup(void)
@@ -119,11 +132,6 @@ static bool dummycon_scroll(struct vc_data *vc, unsigned int top,
 	return false;
 }
 
-static bool dummycon_switch(struct vc_data *vc)
-{
-	return false;
-}
-
 /*
  *  The console `switch' structure for the dummy console
  *
-- 
2.39.5



