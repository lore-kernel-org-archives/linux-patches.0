Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD771A76A5;
	Mon, 14 Oct 2024 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918639; cv=none; b=WpqMho6+IBORmz9WPC+FAPm/nYZPPsgP8PsmzblIBTJX+TZZZz8wfEo/QNUKJini0wUhIDRCfaA55kL9CCne2QWdKurvuN/cTCVNTo4WHYasmnZi9K2dGoGY/nw4M0REb4WSk3s0Bpx5e+aVPxj3hXc4Q/zI8coIMALVtXDU+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918639; c=relaxed/simple;
	bh=pR+NwAfGs3fAHHeQTse1STWDw/wFZfU0H/8pfpRqm/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzrGPdaJJrLc8rp5AuIk9Rx5ukI9N+yBaWpJ+eR0Npso0oZokKMANgAckz6zVvZqjSpO26U4e6VvT50EABFg873EWtbmzOFn8EAuFQ06/kOQ5Fr7HOBMfET52F20KbgzmlmuHZVmELFd4LSAhNfYWA+Ca+LtA4M8c7WyqR0b+lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PplLxm7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PplLxm7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBC8C4CEC3;
	Mon, 14 Oct 2024 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918639;
	bh=pR+NwAfGs3fAHHeQTse1STWDw/wFZfU0H/8pfpRqm/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PplLxm7cJ8qmIWCKBQUCppnf5FVPHL/3MDR9GAJOsYUuP93XtE4J+ZaSn2Vw0nw6V
	 InD2fQFdGM9MDpRhZEbqXmI6J4pcDcpUVIYIJklMiWk3EVZJ7oLgblNPNsOudtgFgH
	 oZMoYkDkv2EJJzqexyLQysvmINdYZ0LX7/Qv2yUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 379/798] jump_label: Simplify and clarify static_key_fast_inc_cpus_locked()
Date: Mon, 14 Oct 2024 16:15:33 +0200
Message-ID: <20241014141232.844299962@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 9bc2ff871f00437ad2f10c1eceff51aaa72b478f ]

Make the code more obvious and add proper comments to avoid future head
scratching.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240610124406.548322963@linutronix.de
Stable-dep-of: 1d7f856c2ca4 ("jump_label: Fix static_key_slow_dec() yet again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 1ed269b2c4035..7374053bbe049 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -159,22 +159,24 @@ bool static_key_slow_inc_cpuslocked(struct static_key *key)
 	if (static_key_fast_inc_not_disabled(key))
 		return true;
 
-	jump_label_lock();
-	if (atomic_read(&key->enabled) == 0) {
-		atomic_set(&key->enabled, -1);
+	guard(mutex)(&jump_label_mutex);
+	/* Try to mark it as 'enabling in progress. */
+	if (!atomic_cmpxchg(&key->enabled, 0, -1)) {
 		jump_label_update(key);
 		/*
-		 * Ensure that if the above cmpxchg loop observes our positive
-		 * value, it must also observe all the text changes.
+		 * Ensure that when static_key_fast_inc_not_disabled() or
+		 * static_key_slow_try_dec() observe the positive value,
+		 * they must also observe all the text changes.
 		 */
 		atomic_set_release(&key->enabled, 1);
 	} else {
-		if (WARN_ON_ONCE(!static_key_fast_inc_not_disabled(key))) {
-			jump_label_unlock();
+		/*
+		 * While holding the mutex this should never observe
+		 * anything else than a value >= 1 and succeed
+		 */
+		if (WARN_ON_ONCE(!static_key_fast_inc_not_disabled(key)))
 			return false;
-		}
 	}
-	jump_label_unlock();
 	return true;
 }
 
-- 
2.43.0



