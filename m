Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5804417E9
	for <patches@lists.linux.dev>; Mon,  3 Oct 2022 18:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2DAC433C1
	for <patches@lists.linux.dev>; Mon,  3 Oct 2022 18:17:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="W2V4aCY3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1664821052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wbr6l1liVmpcbEEJMAT6hI4uzp1OCJusYxnU8Enxb70=;
	b=W2V4aCY3h0OS5l+s/plEQh3oqgQihg1S935DeQJ7hfcBVqEVh9zQqeizXM5+rRvkfbT98u
	ulsh1V2MgbKRbbkW14x9WN7s9mhJdvlQEXg/DMxjtxnYWs6d91KSipLZsGhydNcxGEGQSp
	gV3eNaBDGd0o35gSIVyv+FbBkpCtSg0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 855d1dca (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Mon, 3 Oct 2022 18:17:31 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kuba@kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH net-next] once: rename _SLOW to _SLEEPABLE
Date: Mon,  3 Oct 2022 20:14:13 +0200
Message-Id: <20221003181413.1221968-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9oh1aFCMBeV-vvtfMoCx4N5r_tABp79tkPNNLJnc1ug7Q@mail.gmail.com>
References: <CAHmME9oh1aFCMBeV-vvtfMoCx4N5r_tABp79tkPNNLJnc1ug7Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The _SLOW designation wasn't really descriptive of anything. This is
meant to be called from process context when it's possible to sleep. So
name this more aptly _SLEEPABLE, which better fits its intended use.

Fixes: 62c07983bef9 ("once: add DO_ONCE_SLOW() for sleepable contexts")
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/once.h       | 38 +++++++++++++++++++-------------------
 lib/once.c                 | 10 +++++-----
 net/ipv4/inet_hashtables.c |  4 ++--
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/once.h b/include/linux/once.h
index 176ab75b42df..bc714d414448 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -13,9 +13,9 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 		    unsigned long *flags, struct module *mod);
 
 /* Variant for process contexts only. */
-bool __do_once_slow_start(bool *done);
-void __do_once_slow_done(bool *done, struct static_key_true *once_key,
-			 struct module *mod);
+bool __do_once_sleepable_start(bool *done);
+void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
+			      struct module *mod);
 
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
@@ -61,26 +61,26 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
 	})
 
 /* Variant of DO_ONCE() for process/sleepable contexts. */
-#define DO_ONCE_SLOW(func, ...)						     \
-	({								     \
-		bool ___ret = false;					     \
-		static bool __section(".data.once") ___done = false;	     \
-		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
-		if (static_branch_unlikely(&___once_key)) {		     \
-			___ret = __do_once_slow_start(&___done);	     \
-			if (unlikely(___ret)) {				     \
-				func(__VA_ARGS__);			     \
-				__do_once_slow_done(&___done, &___once_key,  \
-						    THIS_MODULE);	     \
-			}						     \
-		}							     \
-		___ret;							     \
+#define DO_ONCE_SLEEPABLE(func, ...)						\
+	({									\
+		bool ___ret = false;						\
+		static bool __section(".data.once") ___done = false;		\
+		static DEFINE_STATIC_KEY_TRUE(___once_key);			\
+		if (static_branch_unlikely(&___once_key)) {			\
+			___ret = __do_once_sleepable_start(&___done);		\
+			if (unlikely(___ret)) {					\
+				func(__VA_ARGS__);				\
+				__do_once_sleepable_done(&___done, &___once_key,\
+						    THIS_MODULE);		\
+			}							\
+		}								\
+		___ret;								\
 	})
 
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
 
-#define get_random_slow_once(buf, nbytes)				     \
-	DO_ONCE_SLOW(get_random_bytes, (buf), (nbytes))
+#define get_random_sleepable_once(buf, nbytes)				     \
+	DO_ONCE_SLEEPABLE(get_random_bytes, (buf), (nbytes))
 
 #endif /* _LINUX_ONCE_H */
diff --git a/lib/once.c b/lib/once.c
index 351f66aad310..2c306f0e891e 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -69,7 +69,7 @@ EXPORT_SYMBOL(__do_once_done);
 
 static DEFINE_MUTEX(once_mutex);
 
-bool __do_once_slow_start(bool *done)
+bool __do_once_sleepable_start(bool *done)
 	__acquires(once_mutex)
 {
 	mutex_lock(&once_mutex);
@@ -77,7 +77,7 @@ bool __do_once_slow_start(bool *done)
 		mutex_unlock(&once_mutex);
 		/* Keep sparse happy by restoring an even lock count on
 		 * this mutex. In case we return here, we don't call into
-		 * __do_once_done but return early in the DO_ONCE_SLOW() macro.
+		 * __do_once_done but return early in the DO_ONCE_SLEEPABLE() macro.
 		 */
 		__acquire(once_mutex);
 		return false;
@@ -85,9 +85,9 @@ bool __do_once_slow_start(bool *done)
 
 	return true;
 }
-EXPORT_SYMBOL(__do_once_slow_start);
+EXPORT_SYMBOL(__do_once_sleepable_start);
 
-void __do_once_slow_done(bool *done, struct static_key_true *once_key,
+void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 			 struct module *mod)
 	__releases(once_mutex)
 {
@@ -95,4 +95,4 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
 	mutex_unlock(&once_mutex);
 	once_disable_jump(once_key, mod);
 }
-EXPORT_SYMBOL(__do_once_slow_done);
+EXPORT_SYMBOL(__do_once_sleepable_done);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index dc1c5629cd0d..a0ad34e4f044 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -958,8 +958,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	get_random_slow_once(table_perturb,
-			     INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
+	get_random_sleepable_once(table_perturb,
+				  INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
-- 
2.37.3

