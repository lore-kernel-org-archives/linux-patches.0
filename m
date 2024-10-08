Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E371CF297;
	Tue,  8 Oct 2024 12:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389525; cv=none; b=DrEh+cNZ+j24ZpxaAeRVMtrqIz44GC9hfleUOFC8F1Dws6SV1cekYOQzJykl6xaWqfWFH+wmbrBbfROWKPF/h/2II6XF8IecHBt4zCsYikZlCh9higdnwsnCn6ssqta6eQIZxxfhnEGV32JOZh9AguqgXoHthaveu6ObLOcg6Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389525; c=relaxed/simple;
	bh=ivPXaU73OMyDBRvP6MzqJB4pmctPNPUFxRPbMtFXfUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+IlYdfl4Fz9evkTdU+Tzg7RO2eAIPjPSCNa2CVLTMxUGOJmZhK68QSIa+sCJzO1/K68D53bgHdopmLDYrY2fM2SHHUrA+moqbE0rXOnDQEuLaxvGmxIwJZy9OWMpNHg49GTpYJC3Le51WzGafRrdQndUmT3w7QdiDDiqVtHfgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAghNl5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAghNl5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5B8C4CEC7;
	Tue,  8 Oct 2024 12:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389525;
	bh=ivPXaU73OMyDBRvP6MzqJB4pmctPNPUFxRPbMtFXfUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAghNl5f7c70w+VNX023+FE8rSsbslmWbU5Z5GiRYF+WR7Y9V6FyLJqc7LUKzVG8w
	 Him66od5s0uJDeR/NmNOkA0iDmacm4vgscaADVP4Q2AfvrOcoEo0BL23FjhwR4J9fW
	 7bmgSeHU++j7Harmn5UVzT/pzqE/mi1/UvmfRwBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Klara Modin <klarasmodin@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 004/482] jump_label: Fix static_key_slow_dec() yet again
Date: Tue,  8 Oct 2024 14:01:07 +0200
Message-ID: <20241008115648.466344410@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1d7f856c2ca449f04a22d876e36b464b7a9d28b6 ]

While commit 83ab38ef0a0b ("jump_label: Fix concurrency issues in
static_key_slow_dec()") fixed one problem, it created yet another,
notably the following is now possible:

  slow_dec
    if (try_dec) // dec_not_one-ish, false
    // enabled == 1
                                slow_inc
                                  if (inc_not_disabled) // inc_not_zero-ish
                                  // enabled == 2
                                    return

    guard((mutex)(&jump_label_mutex);
    if (atomic_cmpxchg(1,0)==1) // false, we're 2

                                slow_dec
                                  if (try-dec) // dec_not_one, true
                                  // enabled == 1
                                    return
    else
      try_dec() // dec_not_one, false
      WARN

Use dec_and_test instead of cmpxchg(), like it was prior to
83ab38ef0a0b. Add a few WARNs for the paranoid.

Fixes: 83ab38ef0a0b ("jump_label: Fix concurrency issues in static_key_slow_dec()")
Reported-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 781a1298ce2c2..101572d6a9083 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -165,7 +165,7 @@ bool static_key_slow_inc_cpuslocked(struct static_key *key)
 		jump_label_update(key);
 		/*
 		 * Ensure that when static_key_fast_inc_not_disabled() or
-		 * static_key_slow_try_dec() observe the positive value,
+		 * static_key_dec_not_one() observe the positive value,
 		 * they must also observe all the text changes.
 		 */
 		atomic_set_release(&key->enabled, 1);
@@ -247,7 +247,7 @@ void static_key_disable(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_disable);
 
-static bool static_key_slow_try_dec(struct static_key *key)
+static bool static_key_dec_not_one(struct static_key *key)
 {
 	int v;
 
@@ -271,6 +271,14 @@ static bool static_key_slow_try_dec(struct static_key *key)
 		 * enabled. This suggests an ordering problem on the user side.
 		 */
 		WARN_ON_ONCE(v < 0);
+
+		/*
+		 * Warn about underflow, and lie about success in an attempt to
+		 * not make things worse.
+		 */
+		if (WARN_ON_ONCE(v == 0))
+			return true;
+
 		if (v <= 1)
 			return false;
 	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v - 1)));
@@ -281,15 +289,27 @@ static bool static_key_slow_try_dec(struct static_key *key)
 static void __static_key_slow_dec_cpuslocked(struct static_key *key)
 {
 	lockdep_assert_cpus_held();
+	int val;
 
-	if (static_key_slow_try_dec(key))
+	if (static_key_dec_not_one(key))
 		return;
 
 	guard(mutex)(&jump_label_mutex);
-	if (atomic_cmpxchg(&key->enabled, 1, 0) == 1)
+	val = atomic_read(&key->enabled);
+	/*
+	 * It should be impossible to observe -1 with jump_label_mutex held,
+	 * see static_key_slow_inc_cpuslocked().
+	 */
+	if (WARN_ON_ONCE(val == -1))
+		return;
+	/*
+	 * Cannot already be 0, something went sideways.
+	 */
+	if (WARN_ON_ONCE(val == 0))
+		return;
+
+	if (atomic_dec_and_test(&key->enabled))
 		jump_label_update(key);
-	else
-		WARN_ON_ONCE(!static_key_slow_try_dec(key));
 }
 
 static void __static_key_slow_dec(struct static_key *key)
@@ -326,7 +346,7 @@ void __static_key_slow_dec_deferred(struct static_key *key,
 {
 	STATIC_KEY_CHECK_USE(key);
 
-	if (static_key_slow_try_dec(key))
+	if (static_key_dec_not_one(key))
 		return;
 
 	schedule_delayed_work(work, timeout);
-- 
2.43.0



