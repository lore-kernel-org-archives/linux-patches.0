Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7383914A0A4;
	Tue, 25 Jun 2024 09:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308336; cv=none; b=eaNO+uFNZRUdtJTsMN1Gx2EYD4uWfkscB04DeJO9SLHGng2EMkWr6autPsv1EzhxiZAsn8h+ow8bj5axMex2EIBI/ASF5T2Dy6vkZUrfIUr/qfp6VHN/PPFALarX8eh5zAsw31muAJeYPjRHIOAO8QGbJcCNqtrga9lvNhKyiuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308336; c=relaxed/simple;
	bh=fad+DEvk7M/iy4V61KoHFKQWK+V77ZivJCVJXgLFzjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crItNmbTIPU1cGQ7fxYc8zEhLGeufL/dzbzDFCcvB/Er9XWcl4MCTQEiaszNjUpqZa2i75WCIGDRi2Wy1RK513KSeUtEbNQo3zyCkhN2aSLPEaY0pZS1JS9jQVXikQgA2kizn7/yxrNQnznfD43zuWkjdRrDXAPESWnvE0pYzF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqfIoSAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqfIoSAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88286C32781;
	Tue, 25 Jun 2024 09:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308335;
	bh=fad+DEvk7M/iy4V61KoHFKQWK+V77ZivJCVJXgLFzjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqfIoSADaPSp1qotO4I32DWNfr0vf7bDkwNOb90dFEorc2Ox5ymZwfEK94CJFynw/
	 +KEIBDHa5ABUV1bQ3ivyHbs9yY18+Eq4WL85YSiPcnIiYA+ohJidIVbV9rmQKzkfbm
	 DUQI1f6sAF6UrYAnjnCfnGihOUJlJ9djeQP4qcyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jiri Slaby <jirislaby@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Starke <daniel.starke@siemens.com>,
	syzbot <syzbot+dbac96d8e73b61aa559c@syzkaller.appspotmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 086/250] tty: add the option to have a tty reject a new ldisc
Date: Tue, 25 Jun 2024 11:30:44 +0200
Message-ID: <20240625085551.368621044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 6bd23e0c2bb6c65d4f5754d1456bc9a4427fc59b ]

... and use it to limit the virtual terminals to just N_TTY.  They are
kind of special, and in particular, the "con_write()" routine violates
the "writes cannot sleep" rule that some ldiscs rely on.

This avoids the

   BUG: sleeping function called from invalid context at kernel/printk/printk.c:2659

when N_GSM has been attached to a virtual console, and gsmld_write()
calls con_write() while holding a spinlock, and con_write() then tries
to get the console lock.

Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Starke <daniel.starke@siemens.com>
Reported-by: syzbot <syzbot+dbac96d8e73b61aa559c@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=dbac96d8e73b61aa559c
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240423163339.59780-1-torvalds@linux-foundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_ldisc.c    |  6 ++++++
 drivers/tty/vt/vt.c        | 10 ++++++++++
 include/linux/tty_driver.h |  8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 3f68e213df1f7..d80e9d4c974b4 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -545,6 +545,12 @@ int tty_set_ldisc(struct tty_struct *tty, int disc)
 		goto out;
 	}
 
+	if (tty->ops->ldisc_ok) {
+		retval = tty->ops->ldisc_ok(tty, disc);
+		if (retval)
+			goto out;
+	}
+
 	old_ldisc = tty->ldisc;
 
 	/* Shutdown the old discipline. */
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 9b5b98dfc8b40..cd87e3d1291ed 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3576,6 +3576,15 @@ static void con_cleanup(struct tty_struct *tty)
 	tty_port_put(&vc->port);
 }
 
+/*
+ * We can't deal with anything but the N_TTY ldisc,
+ * because we can sleep in our write() routine.
+ */
+static int con_ldisc_ok(struct tty_struct *tty, int ldisc)
+{
+	return ldisc == N_TTY ? 0 : -EINVAL;
+}
+
 static int default_color           = 7; /* white */
 static int default_italic_color    = 2; // green (ASCII)
 static int default_underline_color = 3; // cyan (ASCII)
@@ -3695,6 +3704,7 @@ static const struct tty_operations con_ops = {
 	.resize = vt_resize,
 	.shutdown = con_shutdown,
 	.cleanup = con_cleanup,
+	.ldisc_ok = con_ldisc_ok,
 };
 
 static struct cdev vc0_cdev;
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 7372124fbf90b..dd4b31ce6d5d4 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -154,6 +154,13 @@ struct serial_struct;
  *
  *	Optional. Called under the @tty->termios_rwsem. May sleep.
  *
+ * @ldisc_ok: ``int ()(struct tty_struct *tty, int ldisc)``
+ *
+ *	This routine allows the @tty driver to decide if it can deal
+ *	with a particular @ldisc.
+ *
+ *	Optional. Called under the @tty->ldisc_sem and @tty->termios_rwsem.
+ *
  * @set_ldisc: ``void ()(struct tty_struct *tty)``
  *
  *	This routine allows the @tty driver to be notified when the device's
@@ -372,6 +379,7 @@ struct tty_operations {
 	void (*hangup)(struct tty_struct *tty);
 	int (*break_ctl)(struct tty_struct *tty, int state);
 	void (*flush_buffer)(struct tty_struct *tty);
+	int (*ldisc_ok)(struct tty_struct *tty, int ldisc);
 	void (*set_ldisc)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
 	void (*send_xchar)(struct tty_struct *tty, u8 ch);
-- 
2.43.0



