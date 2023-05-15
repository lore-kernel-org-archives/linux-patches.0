Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F82FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32296C433EF;
	Mon, 15 May 2023 17:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172879;
	bh=L4jDGtev27TReWHRZCBduzZwjPFoB9nhDPtCPdj+hTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGAc6b80d7NTMYCPCBdlrkdDK2qyqWbnVVnH54s+JyaQ+lkLxFsE2AKCq2WSsPjn0
	 AwWO+yekT4nRzrNYesMOpHZcoH03LQTHbd8fHvDtkTksLJ1Zmf0pS+QGqpOd8LRhM+
	 ITQHXMcuU0zDr7N/4LSGzhy5aVIPAO4WpQZUjhj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/381] tty: audit: move some local functions out of tty.h
Date: Mon, 15 May 2023 18:29:08 +0200
Message-Id: <20230515161750.208873154@linuxfoundation.org>
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

[ Upstream commit da5d669e00d2c437b3f508d60add417fc74f4bb6 ]

The functions tty_audit_add_data() and tty_audit_tiocsti() are local to
the tty core code, and do not need to be in a "kernel-wide" header file
so move them to drivers/tty/tty.h

Cc: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20210408125134.3016837-9-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 094fb49a2d0d ("tty: Prevent writing chars during tcsetattr TCSADRAIN/FLUSH")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty.h       | 14 ++++++++++++++
 drivers/tty/tty_audit.c |  1 +
 include/linux/tty.h     | 10 ----------
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/tty.h b/drivers/tty/tty.h
index f4cd20261e914..f131d538b62b9 100644
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -18,4 +18,18 @@
 #define tty_info_ratelimited(tty, f, ...) \
 		tty_msg(pr_info_ratelimited, tty, f, ##__VA_ARGS__)
 
+/* tty_audit.c */
+#ifdef CONFIG_AUDIT
+void tty_audit_add_data(struct tty_struct *tty, const void *data, size_t size);
+void tty_audit_tiocsti(struct tty_struct *tty, char ch);
+#else
+static inline void tty_audit_add_data(struct tty_struct *tty, const void *data,
+				      size_t size)
+{
+}
+static inline void tty_audit_tiocsti(struct tty_struct *tty, char ch)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index 9f906a5b8e810..9b30edee71fe9 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -10,6 +10,7 @@
 #include <linux/audit.h>
 #include <linux/slab.h>
 #include <linux/tty.h>
+#include "tty.h"
 
 struct tty_audit_buf {
 	struct mutex mutex;	/* Protects all data below */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9e3725589214e..a1a9c4b8210ea 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -731,20 +731,10 @@ static inline void n_tty_init(void) { }
 
 /* tty_audit.c */
 #ifdef CONFIG_AUDIT
-extern void tty_audit_add_data(struct tty_struct *tty, const void *data,
-			       size_t size);
 extern void tty_audit_exit(void);
 extern void tty_audit_fork(struct signal_struct *sig);
-extern void tty_audit_tiocsti(struct tty_struct *tty, char ch);
 extern int tty_audit_push(void);
 #else
-static inline void tty_audit_add_data(struct tty_struct *tty, const void *data,
-				      size_t size)
-{
-}
-static inline void tty_audit_tiocsti(struct tty_struct *tty, char ch)
-{
-}
 static inline void tty_audit_exit(void)
 {
 }
-- 
2.39.2



