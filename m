Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F81AFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F55C4339E;
	Mon, 15 May 2023 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172886;
	bh=nGOTDam4prBbRCePOlz24Q0aJmx8Oowxzk9YAZkAGhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3SJ4DBft2j9mp7tQ1KU5aD+MEom3pKTRnvx7JW6zbKs1wjlgxlexyAd4g9Oxh+Tp
	 MzifVAvoDPQaNYMCCH6NTF1PQE6zD5u9ciBKP48hIJGRRMqqUCtoq/dLE0sESQi5XK
	 3nL0tQ64pVC1Dpr9obN4Zyurx1meLWrs2oDiTtEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 299/381] tty: move some tty-only functions to drivers/tty/tty.h
Date: Mon, 15 May 2023 18:29:10 +0200
Message-Id: <20230515161750.306470946@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 9f72cab1596327e1011ab4599c07b165e0fb45db ]

The flow change and restricted_tty_write() logic is internal to the tty
core only, so move it out of the include/linux/tty.h file.

Cc: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20210408125134.3016837-12-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 094fb49a2d0d ("tty: Prevent writing chars during tcsetattr TCSADRAIN/FLUSH")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty.h       | 17 +++++++++++++++++
 drivers/tty/tty_ioctl.c |  1 +
 include/linux/tty.h     | 16 ----------------
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/tty.h b/drivers/tty/tty.h
index 552e263e02dfb..9eda9e5f8ad5e 100644
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -41,6 +41,21 @@ enum {
 	TTY_LOCK_SLAVE,
 };
 
+/* Values for tty->flow_change */
+#define TTY_THROTTLE_SAFE	1
+#define TTY_UNTHROTTLE_SAFE	2
+
+static inline void __tty_set_flow_change(struct tty_struct *tty, int val)
+{
+	tty->flow_change = val;
+}
+
+static inline void tty_set_flow_change(struct tty_struct *tty, int val)
+{
+	tty->flow_change = val;
+	smp_mb();
+}
+
 int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout);
 void tty_ldisc_unlock(struct tty_struct *tty);
 
@@ -58,4 +73,6 @@ static inline void tty_audit_tiocsti(struct tty_struct *tty, char ch)
 }
 #endif
 
+ssize_t redirected_tty_write(struct kiocb *, struct iov_iter *);
+
 #endif
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 803da2d111c8c..50e65784fbf77 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -21,6 +21,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/compat.h>
+#include "tty.h"
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
diff --git a/include/linux/tty.h b/include/linux/tty.h
index af398d0aa9fdc..a641fc6a7fa8b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -350,21 +350,6 @@ struct tty_file_private {
 #define TTY_LDISC_CHANGING	20	/* Change pending - non-block IO */
 #define TTY_LDISC_HALTED	22	/* Line discipline is halted */
 
-/* Values for tty->flow_change */
-#define TTY_THROTTLE_SAFE 1
-#define TTY_UNTHROTTLE_SAFE 2
-
-static inline void __tty_set_flow_change(struct tty_struct *tty, int val)
-{
-	tty->flow_change = val;
-}
-
-static inline void tty_set_flow_change(struct tty_struct *tty, int val)
-{
-	tty->flow_change = val;
-	smp_mb();
-}
-
 static inline bool tty_io_nonblock(struct tty_struct *tty, struct file *file)
 {
 	return file->f_flags & O_NONBLOCK ||
@@ -395,7 +380,6 @@ extern const char *tty_name(const struct tty_struct *tty);
 extern struct tty_struct *tty_kopen(dev_t device);
 extern void tty_kclose(struct tty_struct *tty);
 extern int tty_dev_name_to_number(const char *name, dev_t *number);
-extern ssize_t redirected_tty_write(struct kiocb *, struct iov_iter *);
 #else
 static inline void tty_kref_put(struct tty_struct *tty)
 { }
-- 
2.39.2



