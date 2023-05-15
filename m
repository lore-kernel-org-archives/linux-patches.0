Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1375FC1B
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F425C4339B;
	Mon, 15 May 2023 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172876;
	bh=oJS4S/x6wRok+G8dpID+Ve5Eo482i+91oGF8GCbNMwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnKQN+qVmUGy6BciQ4h/IsUb4jviZ8qjKEB7k2DNwHTKK13ofAzQhE8SlkWbuxGrh
	 ae6mnNps7+huXgsqlpFQUjoq1vL8GJ31FdsK3MCE73Y491iYZeRILcYtwW0O6nLy5L
	 fkbKQusOxv/t2VTLGBXoyYzUOy7MfDfQ1fIDh+rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/381] tty: create internal tty.h file
Date: Mon, 15 May 2023 18:29:07 +0200
Message-Id: <20230515161750.168975425@linuxfoundation.org>
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

[ Upstream commit 98602c010ceba82f2c2384122dbd07bc965fd367 ]

There are a number of functions and #defines in include/linux/tty.h that
do not belong there as they are private to the tty core code.

Create an initial drivers/tty/tty.h file and copy the odd "tty logging"
macros into it to seed the file with some initial things that we know
nothing outside of the tty core should be calling.

Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20210408125134.3016837-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 094fb49a2d0d ("tty: Prevent writing chars during tcsetattr TCSADRAIN/FLUSH")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_tty.c       |  1 +
 drivers/tty/pty.c         |  1 +
 drivers/tty/tty.h         | 21 +++++++++++++++++++++
 drivers/tty/tty_io.c      |  1 +
 drivers/tty/tty_jobctrl.c |  1 +
 drivers/tty/tty_ldisc.c   |  1 +
 drivers/tty/tty_port.c    |  1 +
 include/linux/tty.h       | 12 ------------
 8 files changed, 27 insertions(+), 12 deletions(-)
 create mode 100644 drivers/tty/tty.h

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 12dde01e576b5..8e7931d935438 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
+#include "tty.h"
 
 /*
  * Until this number of characters is queued in the xmit buffer, select will
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 16498f5fba64d..ca3e5a6c1a497 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -29,6 +29,7 @@
 #include <linux/file.h>
 #include <linux/ioctl.h>
 #include <linux/compat.h>
+#include "tty.h"
 
 #undef TTY_DEBUG_HANGUP
 #ifdef TTY_DEBUG_HANGUP
diff --git a/drivers/tty/tty.h b/drivers/tty/tty.h
new file mode 100644
index 0000000000000..f4cd20261e914
--- /dev/null
+++ b/drivers/tty/tty.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * TTY core internal functions
+ */
+
+#ifndef _TTY_INTERNAL_H
+#define _TTY_INTERNAL_H
+
+#define tty_msg(fn, tty, f, ...) \
+	fn("%s %s: " f, tty_driver_name(tty), tty_name(tty), ##__VA_ARGS__)
+
+#define tty_debug(tty, f, ...)	tty_msg(pr_debug, tty, f, ##__VA_ARGS__)
+#define tty_info(tty, f, ...)	tty_msg(pr_info, tty, f, ##__VA_ARGS__)
+#define tty_notice(tty, f, ...)	tty_msg(pr_notice, tty, f, ##__VA_ARGS__)
+#define tty_warn(tty, f, ...)	tty_msg(pr_warn, tty, f, ##__VA_ARGS__)
+#define tty_err(tty, f, ...)	tty_msg(pr_err, tty, f, ##__VA_ARGS__)
+
+#define tty_info_ratelimited(tty, f, ...) \
+		tty_msg(pr_info_ratelimited, tty, f, ##__VA_ARGS__)
+
+#endif
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c37d2657308cd..86fbfe42ce0ac 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -108,6 +108,7 @@
 
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
+#include "tty.h"
 
 #undef TTY_DEBUG_HANGUP
 #ifdef TTY_DEBUG_HANGUP
diff --git a/drivers/tty/tty_jobctrl.c b/drivers/tty/tty_jobctrl.c
index aa6d0537b379e..95d67613b25b6 100644
--- a/drivers/tty/tty_jobctrl.c
+++ b/drivers/tty/tty_jobctrl.c
@@ -11,6 +11,7 @@
 #include <linux/tty.h>
 #include <linux/fcntl.h>
 #include <linux/uaccess.h>
+#include "tty.h"
 
 static int is_ignored(int sig)
 {
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index fe37ec331289b..c23938b8628d1 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/ratelimit.h>
+#include "tty.h"
 
 #undef LDISC_DEBUG_HANGUP
 
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index ea80bf872f543..cbb56f725bc4a 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/serdev.h>
+#include "tty.h"
 
 static int tty_port_default_receive_buf(struct tty_port *port,
 					const unsigned char *p,
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5972f43b9d5ae..9e3725589214e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -786,16 +786,4 @@ static inline void proc_tty_register_driver(struct tty_driver *d) {}
 static inline void proc_tty_unregister_driver(struct tty_driver *d) {}
 #endif
 
-#define tty_msg(fn, tty, f, ...) \
-	fn("%s %s: " f, tty_driver_name(tty), tty_name(tty), ##__VA_ARGS__)
-
-#define tty_debug(tty, f, ...)	tty_msg(pr_debug, tty, f, ##__VA_ARGS__)
-#define tty_info(tty, f, ...)	tty_msg(pr_info, tty, f, ##__VA_ARGS__)
-#define tty_notice(tty, f, ...)	tty_msg(pr_notice, tty, f, ##__VA_ARGS__)
-#define tty_warn(tty, f, ...)	tty_msg(pr_warn, tty, f, ##__VA_ARGS__)
-#define tty_err(tty, f, ...)	tty_msg(pr_err, tty, f, ##__VA_ARGS__)
-
-#define tty_info_ratelimited(tty, f, ...) \
-		tty_msg(pr_info_ratelimited, tty, f, ##__VA_ARGS__)
-
 #endif
-- 
2.39.2



