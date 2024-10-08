Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993D9192594;
	Tue,  8 Oct 2024 12:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391142; cv=none; b=kVm+EaaX+G1zR3kpvXAO40PTysxNXrn269ft4j/IvwrnmRJqycapeKdQA1DzwsP4Tsk3UdblbaTzGEJ8CKqUXuZNyLGSHv7oRWmoUDaaYHsZ5J/cRqYceWYfulgnbO0xpmASaxkN5g9lMTOEBLYgLVd2uAl52v+ZmPDtaWsGwyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391142; c=relaxed/simple;
	bh=cavsj7dCJZlhWTt3pOAnuQlRwEfajGzNU/QJ2ECclAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwcT3tw8ir8EuAgFztZnagakBcB1EIWN7tF6f9TSCnGypNjLUBgxKEjNp98ERndK6F4nx1Y9zpwjeBLWWmlSM2F0HVVowgyDH+UqoT2RGaVOjU9XvxrxWa8Kg399SSIuc3e+LFQggm1SUuRvBefSpFVbB9W4pOD19pAnnOtUpK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FCbCrsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FCbCrsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C0FC4CEC7;
	Tue,  8 Oct 2024 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391142;
	bh=cavsj7dCJZlhWTt3pOAnuQlRwEfajGzNU/QJ2ECclAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FCbCrsVhTHIlAG4B/x+CnsdS5YBlc4LfWkrLiz0kl0jHFXq1HsIZQgT3VD3E5l4a
	 b7WM72QnWb9NGnqFEqYFOUO341K9hPU4PgQlzriuf9vSYvZ3nMXpzsrp1uQEEQo0zR
	 p8TUQLwLGbUmS2Vw2qH0rv04yh4qRHmN64/Q0T8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Klara Modin <klarasmodin@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 003/558] jump_label: Fix static_key_slow_dec() yet again
Date: Tue,  8 Oct 2024 14:00:33 +0200
Message-ID: <20241008115702.356969408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 6dc76b590703e..93a822d3c468c 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -168,7 +168,7 @@ bool static_key_slow_inc_cpuslocked(struct static_key *key)
 		jump_label_update(key);
 		/*
 		 * Ensure that when static_key_fast_inc_not_disabled() or
-		 * static_key_slow_try_dec() observe the positive value,
+		 * static_key_dec_not_one() observe the positive value,
 		 * they must also observe all the text changes.
 		 */
 		atomic_set_release(&key->enabled, 1);
@@ -250,7 +250,7 @@ void static_key_disable(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_disable);
 
-static bool static_key_slow_try_dec(struct static_key *key)
+static bool static_key_dec_not_one(struct static_key *key)
 {
 	int v;
 
@@ -274,6 +274,14 @@ static bool static_key_slow_try_dec(struct static_key *key)
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
@@ -284,15 +292,27 @@ static bool static_key_slow_try_dec(struct static_key *key)
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
@@ -329,7 +349,7 @@ void __static_key_slow_dec_deferred(struct static_key *key,
 {
 	STATIC_KEY_CHECK_USE(key);
 
-	if (static_key_slow_try_dec(key))
+	if (static_key_dec_not_one(key))
 		return;
 
 	schedule_delayed_work(work, timeout);
-- 
2.43.0



