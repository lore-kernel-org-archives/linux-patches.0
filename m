Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E79A35F185;
	Tue, 25 Aug 2026 13:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665365; cv=none; b=RH03Zb3a5HK4u/F/Fb72ESTkAaO8K4WaCUS1X5xUjb1fwFIw7ORykcucyBXfGlRpRuq+rutnJ08Bodl7uzAdUkLDJXG3VA/Q4W9TpPAIZa65gvagbN0ym+2O40xgL0wY8trkbi8wi4cxgAUAAENvMAgLdsczkpDt5ZupiTKl/Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665365; c=relaxed/simple;
	bh=iqyQXJQ1jvCu1yQTuiQEw1/18+1oN8cZfyNcPW7T4MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUy1kq1s2A/ZIBti3CzQI222RGJmHxENpbOkL/vFZS2/MJ/4N1wKOXDrsdXy4nOSXstz7z6JCvd8V+hPx9+jc2bOXD7ve37DJwNoDbAgmZpsmJ26QY+5QxqDDnGKCrkCqHefjr2I/IJpp1PAMn6XkqWK5ASfQ/oLCtk3zVXokHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFTSouZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFTSouZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A2A1F000E9;
	Tue, 25 Aug 2026 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665364;
	bh=qZyjh7ntETMHBskPn9QYa9ZCRVXm6HGN+4R8MPDtafg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFTSouZlOvR6DHQi7vNbT8jTGR4niR65mhqCmkQKky+eH/6IdBfzeisW5JkkJDtNS
	 BRdWB4aN8uK8mpTT5//eUZb7EW7YTtrGdI/dxGS+Uota/QOlTYR9yEDD5cZwIhxKKp
	 DOIlfvsQ2yTn4dOE4uK4rm6jIlUO2rieG6jeM+/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.18 75/94] futex/pi: Reject cross-mm private futex owners
Date: Tue, 25 Aug 2026 15:26:11 +0200
Message-ID: <20260825132544.822442053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 59b3732f95dda1fbd2234514d35f4fb6b5bb6d85 upstream.

A private futex key borrows the waiter's mm without taking an mm_users
reference. Nevertheless, attach_to_pi_owner() currently accepts an owner
from a different address space and copies the private key into the owner's
PI state.

When that owner exits, exit_pi_state_list() uses the saved key to find the
hash bucket and acquires a reference to the waiter's private hash. If the
last user of the waiter's mm exits concurrently, futex_hash_free() frees
the hash while the owner still uses its bucket and reference.

Prevent this by validating in attach_to_pi_owner() that, for private
futexes, the owner mm and waiter mm are the same. Perform the check with
the owner's pi_lock held and after validating owner::futex::state to
serialize against a concurrent PI-state exit cleanup.

[ tglx: Amended comment ]

Fixes: 80367ad01d93 ("futex: Add basic infrastructure for local task local hash")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Assisted-by: Codex:gpt-5.6-sol
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/core.c  |    9 ---------
 kernel/futex/futex.h |    9 +++++++++
 kernel/futex/pi.c    |   20 ++++++++++++++++++++
 3 files changed, 29 insertions(+), 9 deletions(-)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -133,15 +133,6 @@ static bool futex_ref_is_dead(struct fut
 
 enum { FR_PERCPU = 0, FR_ATOMIC };
 
-static inline bool futex_key_is_private(union futex_key *key)
-{
-	/*
-	 * Relies on get_futex_key() to set either bit for shared
-	 * futexes -- see comment with union futex_key.
-	 */
-	return !(key->both.offset & (FUT_OFF_INODE | FUT_OFF_MMSHARED));
-}
-
 static bool futex_private_hash_get(struct futex_private_hash *fph)
 {
 	return futex_ref_get(fph);
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -126,6 +126,15 @@ static inline bool should_fail_futex(boo
 }
 #endif
 
+static inline bool futex_key_is_private(union futex_key *key)
+{
+	/*
+	 * Relies on get_futex_key() to set either bit for shared
+	 * futexes -- see comment with union futex_key.
+	 */
+	return !(key->both.offset & (FUT_OFF_INODE | FUT_OFF_MMSHARED));
+}
+
 /*
  * Hash buckets are shared by all the futex_keys that hash to the same
  * location.  Each key may have multiple futex_q structures, one for each task
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -464,6 +464,26 @@ static int attach_to_pi_owner(u32 __user
 		return ret;
 	}
 
+	/*
+	 * If the owner is about to exit() or exec() and tries to modify
+	 * p::futex::exit_state it is serialized against this code by
+	 * p::pi_lock.
+	 */
+	if (IS_ENABLED(CONFIG_MMU) && futex_key_is_private(key)) {
+		/*
+		 * A private futex key holds a pointer to the waiter's mm
+		 * without holding a reference on it. So it must not be attached
+		 * to an owner in a different address space. Otherwise that
+		 * owner's exit cleanup could access the private hash after the
+		 * key's mm is freed.
+		 */
+		if (unlikely(p->mm != key->private.mm)) {
+			raw_spin_unlock_irq(&p->pi_lock);
+			put_task_struct(p);
+			return -EPERM;
+		}
+	}
+
 	__attach_to_pi_owner(p, key, ps);
 	raw_spin_unlock_irq(&p->pi_lock);
 


