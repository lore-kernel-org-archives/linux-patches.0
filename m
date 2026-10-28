Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208332;
	b=3Odln2mAVLHbSYPHftyTDKZ+rrzZYYI4hpT2DdMLOirNWHhdKWxTIi/gLbAunQvq+4d3
	 AnBHKimDdsXzSwAHA5KpDtkvmV5+17lxP27bNgIZ69Ocqh/LX6SlJWxjsYiu1k/7OEdtl
	 DI+Kp7gPYl+jazzM0ZZTr8iuUJLzCwLozSIe/T7r6LQoxeeobAgpwYxpWiVGDMFDKbKbi
	 v8njoxiIv3PuOHp4JP8/7i2O9/AunDYseUC5bNZMZhnqXte4QJygKdZWlqiVyg7j2DzRB
	 q8Odle1LmUIuHSNQJrKgTB8p43XiVlmsC5TXviQijoihR47NqyLhDEf1HUSa7KVsJ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eQ3bmigCvxsqjhw7i3b6WV9tKYddYqH7lVCqphRu7Do=;
	b=a/0n3g8XmBKBIcXVyRGvkoPLhOCUIF271u+jCsIRwGDnU/8XOgWEpI/LxikUezIKCI4M
	 H1aD5RCe+nmvr1PC3OBW/pCfaBvnNxWa/j3G+oTUpVy+zDudhkATL4Za9weq7T/jKovvh
	 SuXY9j1Wvl3QLbs5r67bTXWv/L+5J2CGwnuuSt791Lxfgdu0+IU3z3cip9nIo1EpLojdK
	 e7hhyoVUHGO3e0nyC6HV86m8vTYW6jYeIpCUFPRlpmjBWO+4Lhq+s7j4j2BC/lQqUmumb
	 rxv6b2nkO6kS88wMBC45kdKg3OMU3AqL2cp1rMK7Qwi6dp0glqMVVz0ZJdL6y94be0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKxZhD3r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD4606A31A;
	Wed, 28 Oct 2026 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKxZhD3r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1819D1F01825;
	Wed, 28 Oct 2026 17:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208331;
	bh=eQ3bmigCvxsqjhw7i3b6WV9tKYddYqH7lVCqphRu7Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKxZhD3rTSEbbDOSgQO0jZbhFs1LACxpUSpsfzSc9EnPQVKixgPft/bMiokIHIsXB
	 nqrNMOZCHdHdZcYjuFi5MgKwHNC9mNMWdidgHShxSw0jKnpKmC2RfJgijtSe8Er+Jr
	 T4jvVA7pZWR5mqQLZUQSVWdI4V0ByARz23pdPz1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/516] ftrace: Synchronize the initialization of ftrace_ops
Date: Wed, 28 Oct 2026 17:53:53 +0100
Message-ID: <20261028170005.438414011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 4617721c502b2ddaa4e324e86da4997edf738fa5 ]

There's some internal state that ftrace_ops needs to have set, but since
it can be declared outside of the ftrace.c code, it calls
ftrace_ops_init() on the ops in every global function. The issue is that
if two tasks call it on the same ops at the same time it is possible to
have the initialization of one corrupt the initialization of the other
call.

Create a ops_mutex to use to synchronize every initialization of the
ftrace_ops. The mutex is taken within checking the ftrace_ops flag that
states it was initializied but the flag is checked again after the mutex
has been taken. Checking first outside the mutex allows it to shortcut
having to take the mutex. But then the check needs to be done again after
the mute is taken in case of races.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902095501.6b59af20@gandalf.local.home
Fixes: f04f24fb7e48d ("ftrace, kprobes: Fix a deadlock on ftrace_regex_lock")
Reported-by: sashiko-bot@kernel.org
Close: https://lore.kernel.org/all/20260829025528.49A831F000E9@smtp.kernel.org/
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ adjusted INIT_OPS_HASH macro context for the missing subop_list member. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 765f5f6778946..cc4077a77eaac 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -69,6 +69,8 @@
 #define INIT_OPS_HASH(opsname)	\
 	.func_hash		= &opsname.local_hash,			\
 	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock),
+/* Used only to synchronize the initialization of ftrace_ops */
+static DEFINE_MUTEX(ops_mutex);
 #else
 #define INIT_OPS_HASH(opsname)
 #endif
@@ -131,10 +133,17 @@ static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
 static inline void ftrace_ops_init(struct ftrace_ops *ops)
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
-	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED)) {
+	unsigned long flags = smp_load_acquire(&ops->flags);
+
+	if (!(flags & FTRACE_OPS_FL_INITIALIZED)) {
+		guard(mutex)(&ops_mutex);
+		/* Could have been initialized before lock taken */
+		if (unlikely(ops->flags & FTRACE_OPS_FL_INITIALIZED))
+			return;
 		mutex_init(&ops->local_hash.regex_lock);
 		ops->func_hash = &ops->local_hash;
-		ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+		flags = ops->flags | FTRACE_OPS_FL_INITIALIZED;
+		smp_store_release(&ops->flags, flags);
 	}
 #endif
 }
-- 
2.53.0



