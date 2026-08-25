Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD563E6386;
	Tue, 25 Aug 2026 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664659; cv=none; b=sBQuJYtG9ge+hU/C0dhPZyN8/fhbPtRXV7m4NFeB9Lxoitxdc+OdTsFGK/5RHATeReWJZ/y4wxsorzRyW0UFg4o8MsqfThHjjCrzW/FIlPjIMklpc2SEQ3yv2rufeEsrsYCGcT1ip/FJzYjqQirXtFrUDL9MkZuL2gUKEx9v5E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664659; c=relaxed/simple;
	bh=f2Sobdl7wtqXPnBPXQR7kms98qiVD7nQxJCvF/OBRRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJz3w27p1j0coNLZLfhsJIgrqho+1/86Q+zT3OJJc1Pyyt6AnjT5ykZApvXM3noA0ikTThDsPX++Ry3O2v7IHFwhxI07n4t6hBSPHYAQ8iYq78GP234Hu+E0E7WJo/Bg8zU2cOA9djQErsI1Oiy+2FbSoit4+XYtBYPzkXscxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLkNuxFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLkNuxFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8ED1F000E9;
	Tue, 25 Aug 2026 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664658;
	bh=PA9MK2Ya+v1Os49fpWzQmLdr6MjLEaVsgyimTuI1XYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLkNuxFZxzSp6wcKEt4VK8LY4sfTMZdkXlKu1yW2FEdhprR9zL5PWCg+xMZG3yHpG
	 IkzBwbKFCptznp2OmOsYSq2B4FxpVLp2EcurMBFM7F8kl4CaiLoHSXbhvKwAzZg3jB
	 0nQexp417ypPjKJr4JUgqgx20pSfHqxxJTIdm7C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 7.2 09/82] futex/pi: Reject cross-mm private futex owners
Date: Tue, 25 Aug 2026 15:24:56 +0200
Message-ID: <20260825132541.899090487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/futex/pi.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -465,6 +465,26 @@ static int attach_to_pi_owner(u32 __user
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
 


