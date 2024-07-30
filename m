Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55669187FF6;
	Tue, 30 Jul 2024 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355476; cv=none; b=KZzUhjjbvAPTWymYheJ6DryaG5IJ9sugJY7+BojF4A4fN8H24GW04lfpooihulnfz5F4n7uaIKtbflNCFJOiVRq5YarCMdNKUZueQbkCcOt+GWAz0dwRMGjvnybohB/UDZNn9rdbccQBrh6IJKXczYvkgIO+7DHrhaestKgsenk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355476; c=relaxed/simple;
	bh=DtxdF7PZxO+rbkza3fT8p4mzQrZ3n2MhfEPf6tB4yH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEhh3uclKLegfpAzoFaCokHjehkQKLW7gfWuUbYkBTaQ9UZ2vBCCyQM18OConzsj23sTpskjFczmBQ7trII+Sc9sfCt6tJ9R4E+XBwv1RWAx4nHqiNuCdHwKN6LiPzsolFIhjeIaFeAce1cOPj5F6b0522FUmGnRSarxnVdUGNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0S3b40d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0S3b40d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5547FC4AF0A;
	Tue, 30 Jul 2024 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355475;
	bh=DtxdF7PZxO+rbkza3fT8p4mzQrZ3n2MhfEPf6tB4yH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0S3b40d8ORKPYOzmYEoWuKd6FsaaMq99Ye/10rFfutXrlkimmbKC3Ac0hxrel4qE
	 3kZwLBgBk16kVJmVxrsGmC0K6zq8PIAmlGrdvxAFVHVGPLA5+gJkQDL/IUdIO6jmKB
	 cJ8yZJMPgF6YymoZiS1+KEOcY35xZ4GJ4fRAKcfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <dima@arista.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/440] jump_label: Prevent key->enabled int overflow
Date: Tue, 30 Jul 2024 17:45:31 +0200
Message-ID: <20240730151619.714219484@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit eb8c507296f6038d46010396d91b42a05c3b64d9 ]

1. With CONFIG_JUMP_LABEL=n static_key_slow_inc() doesn't have any
   protection against key->enabled refcounter overflow.
2. With CONFIG_JUMP_LABEL=y static_key_slow_inc_cpuslocked()
   still may turn the refcounter negative as (v + 1) may overflow.

key->enabled is indeed a ref-counter as it's documented in multiple
places: top comment in jump_label.h, Documentation/staging/static-keys.rst,
etc.

As -1 is reserved for static key that's in process of being enabled,
functions would break with negative key->enabled refcount:
- for CONFIG_JUMP_LABEL=n negative return of static_key_count()
  breaks static_key_false(), static_key_true()
- the ref counter may become 0 from negative side by too many
  static_key_slow_inc() calls and lead to use-after-free issues.

These flaws result in that some users have to introduce an additional
mutex and prevent the reference counter from overflowing themselves,
see bpf_enable_runtime_stats() checking the counter against INT_MAX / 2.

Prevent the reference counter overflow by checking if (v + 1) > 0.
Change functions API to return whether the increment was successful.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 83ab38ef0a0b ("jump_label: Fix concurrency issues in static_key_slow_dec()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/jump_label.h | 21 +++++++++++---
 kernel/jump_label.c        | 56 ++++++++++++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 16 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 570831ca99518..4e968ebadce60 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -224,9 +224,10 @@ extern bool arch_jump_label_transform_queue(struct jump_entry *entry,
 					    enum jump_label_type type);
 extern void arch_jump_label_transform_apply(void);
 extern int jump_label_text_reserved(void *start, void *end);
-extern void static_key_slow_inc(struct static_key *key);
+extern bool static_key_slow_inc(struct static_key *key);
+extern bool static_key_fast_inc_not_disabled(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
-extern void static_key_slow_inc_cpuslocked(struct static_key *key);
+extern bool static_key_slow_inc_cpuslocked(struct static_key *key);
 extern void static_key_slow_dec_cpuslocked(struct static_key *key);
 extern int static_key_count(struct static_key *key);
 extern void static_key_enable(struct static_key *key);
@@ -278,11 +279,23 @@ static __always_inline bool static_key_true(struct static_key *key)
 	return false;
 }
 
-static inline void static_key_slow_inc(struct static_key *key)
+static inline bool static_key_fast_inc_not_disabled(struct static_key *key)
 {
+	int v;
+
 	STATIC_KEY_CHECK_USE(key);
-	atomic_inc(&key->enabled);
+	/*
+	 * Prevent key->enabled getting negative to follow the same semantics
+	 * as for CONFIG_JUMP_LABEL=y, see kernel/jump_label.c comment.
+	 */
+	v = atomic_read(&key->enabled);
+	do {
+		if (v < 0 || (v + 1) < 0)
+			return false;
+	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)));
+	return true;
 }
+#define static_key_slow_inc(key)	static_key_fast_inc_not_disabled(key)
 
 static inline void static_key_slow_dec(struct static_key *key)
 {
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 4d6c6f5f60db8..d9c822bbffb8d 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -113,9 +113,40 @@ int static_key_count(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_count);
 
-void static_key_slow_inc_cpuslocked(struct static_key *key)
+/*
+ * static_key_fast_inc_not_disabled - adds a user for a static key
+ * @key: static key that must be already enabled
+ *
+ * The caller must make sure that the static key can't get disabled while
+ * in this function. It doesn't patch jump labels, only adds a user to
+ * an already enabled static key.
+ *
+ * Returns true if the increment was done. Unlike refcount_t the ref counter
+ * is not saturated, but will fail to increment on overflow.
+ */
+bool static_key_fast_inc_not_disabled(struct static_key *key)
 {
+	int v;
+
 	STATIC_KEY_CHECK_USE(key);
+	/*
+	 * Negative key->enabled has a special meaning: it sends
+	 * static_key_slow_inc() down the slow path, and it is non-zero
+	 * so it counts as "enabled" in jump_label_update().  Note that
+	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
+	 */
+	v = atomic_read(&key->enabled);
+	do {
+		if (v <= 0 || (v + 1) < 0)
+			return false;
+	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)));
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(static_key_fast_inc_not_disabled);
+
+bool static_key_slow_inc_cpuslocked(struct static_key *key)
+{
 	lockdep_assert_cpus_held();
 
 	/*
@@ -124,15 +155,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 	 * jump_label_update() process.  At the same time, however,
 	 * the jump_label_update() call below wants to see
 	 * static_key_enabled(&key) for jumps to be updated properly.
-	 *
-	 * So give a special meaning to negative key->enabled: it sends
-	 * static_key_slow_inc() down the slow path, and it is non-zero
-	 * so it counts as "enabled" in jump_label_update().  Note that
-	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
 	 */
-	for (int v = atomic_read(&key->enabled); v > 0; )
-		if (likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)))
-			return;
+	if (static_key_fast_inc_not_disabled(key))
+		return true;
 
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
@@ -144,16 +169,23 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 		 */
 		atomic_set_release(&key->enabled, 1);
 	} else {
-		atomic_inc(&key->enabled);
+		if (WARN_ON_ONCE(!static_key_fast_inc_not_disabled(key))) {
+			jump_label_unlock();
+			return false;
+		}
 	}
 	jump_label_unlock();
+	return true;
 }
 
-void static_key_slow_inc(struct static_key *key)
+bool static_key_slow_inc(struct static_key *key)
 {
+	bool ret;
+
 	cpus_read_lock();
-	static_key_slow_inc_cpuslocked(key);
+	ret = static_key_slow_inc_cpuslocked(key);
 	cpus_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc);
 
-- 
2.43.0



