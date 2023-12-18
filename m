Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E3537881;
	Mon, 18 Dec 2023 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NB6Oi3jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F99C433C7;
	Mon, 18 Dec 2023 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908569;
	bh=6nyrdkFmSz5tK3TJ/EBsHDbUdne/9ZtJdNl/nEA98m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NB6Oi3jHfrsrN75hotZ7FtiHJaiKqx07+OT9+1H8Ss03DhCPVlp07jHoT+H2WZgzD
	 mv1rXhq8QpziELDhmtlsXNclf4dBZlCbtTpmRvmXKzqESQm/cPN4lZVO2B+HySIxwE
	 ECD9tj3UI1sbO69GKaqTQcVfd/nW/H+x/yU4oVZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Starke <daniel.starke@siemens.com>,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Subject: [PATCH 5.10 58/62] tty: n_gsm: fix tty registration before control channel open
Date: Mon, 18 Dec 2023 14:52:22 +0100
Message-ID: <20231218135048.764877681@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Starke <daniel.starke@siemens.com>

commit 01aecd917114577c423f07cec0d186ad007d76fc upstream.

The current implementation registers/deregisters the user ttys at mux
attach/detach. That means that the user devices are available before any
control channel is open. However, user channel initialization requires an
open control channel. Furthermore, the user is not informed if the mux
restarts due to configuration changes.
Put the registration/deregistration procedure into separate function to
improve readability.
Move registration to mux activation and deregistration to mux cleanup to
keep the user devices only open as long as a control channel exists. The
user will be informed via the device driver if the mux was reconfigured in
a way that required a mux re-activation.
This makes it necessary to add T2 initialization to gsmld_open() for the
ldisc open code path (not the reconfiguration code path) to avoid deletion
of an uninitialized T2 at mux cleanup.

Fixes: d50f6dcaf22a ("tty: n_gsm: expose gsmtty device nodes at ldisc open time")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-2-daniel.starke@siemens.com
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |  117 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 79 insertions(+), 38 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -235,6 +235,7 @@ struct gsm_mux {
 	struct gsm_dlci *dlci[NUM_DLCI];
 	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
+	bool has_devices;		/* Devices were registered */
 
 	spinlock_t tx_lock;
 	unsigned int tx_bytes;		/* TX data outstanding */
@@ -465,6 +466,68 @@ static u8 gsm_encode_modem(const struct
 }
 
 /**
+ *	gsm_register_devices	-	register all tty devices for a given mux index
+ *
+ *	@driver: the tty driver that describes the tty devices
+ *	@index:  the mux number is used to calculate the minor numbers of the
+ *	         ttys for this mux and may differ from the position in the
+ *	         mux array.
+ */
+static int gsm_register_devices(struct tty_driver *driver, unsigned int index)
+{
+	struct device *dev;
+	int i;
+	unsigned int base;
+
+	if (!driver || index >= MAX_MUX)
+		return -EINVAL;
+
+	base = index * NUM_DLCI; /* first minor for this index */
+	for (i = 1; i < NUM_DLCI; i++) {
+		/* Don't register device 0 - this is the control channel
+		 * and not a usable tty interface
+		 */
+		dev = tty_register_device(gsm_tty_driver, base + i, NULL);
+		if (IS_ERR(dev)) {
+			if (debug & 8)
+				pr_info("%s failed to register device minor %u",
+					__func__, base + i);
+			for (i--; i >= 1; i--)
+				tty_unregister_device(gsm_tty_driver, base + i);
+			return PTR_ERR(dev);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ *	gsm_unregister_devices	-	unregister all tty devices for a given mux index
+ *
+ *	@driver: the tty driver that describes the tty devices
+ *	@index:  the mux number is used to calculate the minor numbers of the
+ *	         ttys for this mux and may differ from the position in the
+ *	         mux array.
+ */
+static void gsm_unregister_devices(struct tty_driver *driver,
+				   unsigned int index)
+{
+	int i;
+	unsigned int base;
+
+	if (!driver || index >= MAX_MUX)
+		return;
+
+	base = index * NUM_DLCI; /* first minor for this index */
+	for (i = 1; i < NUM_DLCI; i++) {
+		/* Don't unregister device 0 - this is the control
+		 * channel and not a usable tty interface
+		 */
+		tty_unregister_device(gsm_tty_driver, base + i);
+	}
+}
+
+/**
  *	gsm_print_packet	-	display a frame for debug
  *	@hdr: header to print before decode
  *	@addr: address EA from the frame
@@ -2178,6 +2241,10 @@ static void gsm_cleanup_mux(struct gsm_m
 	del_timer_sync(&gsm->t2_timer);
 
 	/* Free up any link layer users and finally the control channel */
+	if (gsm->has_devices) {
+		gsm_unregister_devices(gsm_tty_driver, gsm->num);
+		gsm->has_devices = false;
+	}
 	for (i = NUM_DLCI - 1; i >= 0; i--)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
@@ -2201,15 +2268,21 @@ static void gsm_cleanup_mux(struct gsm_m
 static int gsm_activate_mux(struct gsm_mux *gsm)
 {
 	struct gsm_dlci *dlci;
+	int ret;
 
 	if (gsm->encoding == 0)
 		gsm->receive = gsm0_receive;
 	else
 		gsm->receive = gsm1_receive;
 
+	ret = gsm_register_devices(gsm_tty_driver, gsm->num);
+	if (ret)
+		return ret;
+
 	dlci = gsm_dlci_alloc(gsm, 0);
 	if (dlci == NULL)
 		return -ENOMEM;
+	gsm->has_devices = true;
 	gsm->dead = false;		/* Tty opens are now permissible */
 	return 0;
 }
@@ -2475,39 +2548,14 @@ static int gsmld_output(struct gsm_mux *
  *	will need moving to an ioctl path.
  */
 
-static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
+static void gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 {
-	unsigned int base;
-	int ret, i;
-
 	gsm->tty = tty_kref_get(tty);
 	/* Turn off tty XON/XOFF handling to handle it explicitly. */
 	gsm->old_c_iflag = tty->termios.c_iflag;
 	tty->termios.c_iflag &= (IXON | IXOFF);
-	ret =  gsm_activate_mux(gsm);
-	if (ret != 0)
-		tty_kref_put(gsm->tty);
-	else {
-		/* Don't register device 0 - this is the control channel and not
-		   a usable tty interface */
-		base = mux_num_to_base(gsm); /* Base for this MUX */
-		for (i = 1; i < NUM_DLCI; i++) {
-			struct device *dev;
-
-			dev = tty_register_device(gsm_tty_driver,
-							base + i, NULL);
-			if (IS_ERR(dev)) {
-				for (i--; i >= 1; i--)
-					tty_unregister_device(gsm_tty_driver,
-								base + i);
-				return PTR_ERR(dev);
-			}
-		}
-	}
-	return ret;
 }
 
-
 /**
  *	gsmld_detach_gsm	-	stop doing 0710 mux
  *	@tty: tty attached to the mux
@@ -2518,12 +2566,7 @@ static int gsmld_attach_gsm(struct tty_s
 
 static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 {
-	unsigned int base = mux_num_to_base(gsm); /* Base for this MUX */
-	int i;
-
 	WARN_ON(tty != gsm->tty);
-	for (i = 1; i < NUM_DLCI; i++)
-		tty_unregister_device(gsm_tty_driver, base + i);
 	/* Restore tty XON/XOFF handling. */
 	gsm->tty->termios.c_iflag = gsm->old_c_iflag;
 	tty_kref_put(gsm->tty);
@@ -2619,7 +2662,6 @@ static void gsmld_close(struct tty_struc
 static int gsmld_open(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm;
-	int ret;
 
 	if (tty->ops->write == NULL)
 		return -EINVAL;
@@ -2635,12 +2677,11 @@ static int gsmld_open(struct tty_struct
 	/* Attach the initial passive connection */
 	gsm->encoding = 1;
 
-	ret = gsmld_attach_gsm(tty, gsm);
-	if (ret != 0) {
-		gsm_cleanup_mux(gsm, false);
-		mux_put(gsm);
-	}
-	return ret;
+	gsmld_attach_gsm(tty, gsm);
+
+	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
+
+	return 0;
 }
 
 /**


