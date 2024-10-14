Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045581AA793;
	Mon, 14 Oct 2024 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918643; cv=none; b=u3en5flkZm7l9nx6kA0saUGX/NxsN1lV+98JP75leUlreJYzT8noeDuf5XdftTBDoG1//ky5O55VW4AHzt934STogmdZzEMRglpkmrLimpMhxu44lHc+xOBe+7d4yKUeluvaoAs/p9IuDpBB0KgGGdLsymqJhrUPwQuBHuXUMOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918643; c=relaxed/simple;
	bh=tdAq2HhBMnsCFK3pkFMBjmfHJbGwWHFr3BBHjhwIalo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/dOqAAsfOfePUqILV2TrKQyFm37CRLNjuPF/vnJ9Q7eeeW65yz4StNQu8Vdc4CSFT8nOFIlTmghJNL/p/STBf+QTU2znw51w06B1ocqop0366H4Tyf3Sa5uv1Xn7zBGsW7m0mdvHsBf8F68dLvmI+NyDl/TShZQ7CUWdDog7Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1c7AWH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1c7AWH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63572C4CEC3;
	Mon, 14 Oct 2024 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918642;
	bh=tdAq2HhBMnsCFK3pkFMBjmfHJbGwWHFr3BBHjhwIalo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1c7AWH4xVNMbHQxSnJDTJdmfBAin8cPqQbucMr+rQahIRwMCfgzuxwD1A0El9h3a
	 Af4LgwrCZALaxYD9FdPvdeYXIVICXoD2Y8FtZZQoRcrOzVl5LWaQeRTyvhaOt+Wiwb
	 RC2o7zoSHArnEGfDhe3yI5C65TJ1ZbC4B6Q5x/OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Klara Modin <klarasmodin@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 380/798] jump_label: Fix static_key_slow_dec() yet again
Date: Mon, 14 Oct 2024 16:15:34 +0200
Message-ID: <20241014141232.882481578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 7374053bbe049..554e04b25b13a 100644
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



