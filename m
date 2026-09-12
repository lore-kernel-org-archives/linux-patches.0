Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B8A4BEE2C;
	Sat, 12 Sep 2026 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229798; cv=none; b=ED2laRI1bH75eU4Os+iTln125nWHG7FlqNzD9RQMzrFmOWEjs43JP8ENx+HHHA/h5S4JCPfmrCcSwoKZOKEw0eKgoLV44Oq9dK9LEVXz0PuAIe8+qj2QfZOZhcIYgNWHP5tjkWos/vFe/HVuGqkqhL+pF17ljdPM0U4qfJeV+q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229798; c=relaxed/simple;
	bh=Ehn5vO+YEOnJYEIeXTkpzmB8VW/lI6RXJXFwe5USSN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dl0PFTvEFxIRtAgYaGkpcGj75Hughf3ErB1QD9RtMOqHKcSxlHWHn1NYRb03AmZ4wY/mElprd8mJlpvJV+f9BWIw12Ab99crywbiUZn/UudfBj7IvFljhqaQoMFeV5Aseq3VMR4KCMktPl4eVuXqfb6ZjUgGCXeEGmFswPN2OvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ao3orGVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ao3orGVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137091F008A1;
	Sat, 12 Sep 2026 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229796;
	bh=aTZgd0xk/xICRXnkg644HMlCE7mxVjmek7OPbEZEeV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ao3orGVbsQVYTfkiGt/9V+iqSPYco6JKF2Wz800x7eQPO/a35Wv8F/zHhnhM0CdBc
	 vS2YvwM7jDthZbIBoTNyY0dWQnz37VhsnrPib4xycBes0PzhrwQ2S8OW16gB8VU0O3
	 jW59tExvZ/YE2JebpBgLp7X7blbFj3L38JUvflc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0646/1191] s390/tty3270: add tty3270_create_view()
Date: Sat, 12 Sep 2026 08:56:14 +0200
Message-ID: <20260912065602.764590560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit a21e962e129db40ae08af9fc80ea7babf3632d77 ]

Will be used later for the console driver.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: b6b5d64cb161 ("ipack: ipoctal: fix UAF, null-ptr-deref, and use-after-free in cleanup on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/tty3270.c | 57 +++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 26e3995ac062c..3ea5df58b64bd 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -953,27 +953,14 @@ static struct raw3270_fn tty3270_fn = {
 	.resize = tty3270_resize
 };
 
-/*
- * This routine is called whenever a 3270 tty is opened first time.
- */
-static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
+static int
+tty3270_create_view(int index, struct tty3270 **newtp)
 {
-	struct raw3270_view *view;
 	struct tty3270 *tp;
 	int i, rc;
 
-	/* Check if the tty3270 is already there. */
-	view = raw3270_find_view(&tty3270_fn, tty->index + RAW3270_FIRSTMINOR);
-	if (!IS_ERR(view)) {
-		tp = container_of(view, struct tty3270, view);
-		tty->driver_data = tp;
-		tty->winsize.ws_row = tp->view.rows - 2;
-		tty->winsize.ws_col = tp->view.cols;
-		tp->inattr = TF_INPUT;
-		goto port_install;
-	}
-	if (tty3270_max_index < tty->index + 1)
-		tty3270_max_index = tty->index + 1;
+	if (tty3270_max_index < index + 1)
+		tty3270_max_index = index + 1;
 
 	/* Allocate tty3270 structure on first open. */
 	tp = tty3270_alloc_view();
@@ -981,7 +968,7 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		return PTR_ERR(tp);
 
 	rc = raw3270_add_view(&tp->view, &tty3270_fn,
-			      tty->index + RAW3270_FIRSTMINOR,
+			      index + RAW3270_FIRSTMINOR,
 			      RAW3270_VIEW_LOCK_BH);
 	if (rc) {
 		tty3270_free_view(tp);
@@ -997,9 +984,6 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		return rc;
 	}
 
-	tty->winsize.ws_row = tp->view.rows - 2;
-	tty->winsize.ws_col = tp->view.cols;
-
 	tty3270_create_prompt(tp);
 	tty3270_create_status(tp);
 	tty3270_update_status(tp);
@@ -1016,16 +1000,41 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 	kbd_ascebc(tp->kbd, tp->view.ascebc);
 
 	raw3270_activate_view(&tp->view);
+	raw3270_put_view(&tp->view);
+	*newtp = tp;
+	return 0;
+}
+
+/*
+ * This routine is called whenever a 3270 tty is opened first time.
+ */
+static int
+tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct raw3270_view *view;
+	struct tty3270 *tp;
+	int rc;
 
-port_install:
+	/* Check if the tty3270 is already there. */
+	view = raw3270_find_view(&tty3270_fn, tty->index + RAW3270_FIRSTMINOR);
+	if (IS_ERR(view)) {
+		rc = tty3270_create_view(tty->index, &tp);
+		if (rc)
+			return rc;
+	} else {
+		tp = container_of(view, struct tty3270, view);
+		tty->driver_data = tp;
+		tp->inattr = TF_INPUT;
+	}
+
+	tty->winsize.ws_row = tp->view.rows - 2;
+	tty->winsize.ws_col = tp->view.cols;
 	rc = tty_port_install(&tp->port, driver, tty);
 	if (rc) {
 		raw3270_put_view(&tp->view);
 		return rc;
 	}
-
 	tty->driver_data = tp;
-
 	return 0;
 }
 
-- 
2.53.0



