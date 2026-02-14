Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB983C2D;
	Sat, 14 Feb 2026 21:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104318; cv=none; b=ggsrpNm8Fim8syVyynHGPYxA0q37R0nw36RiazIDWxlfUQErwK/Y4lIK6o6i7pkpmSyN77H6UP6OR6YkGAgya0nqElgJPMwbmpS5rlulXlAv2JACACcml1jE+V2YXUE5RCYmB//KNgXGvEe3CMRYa9zQO4wcICuBRLDc0hxl31s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104318; c=relaxed/simple;
	bh=/cqgyn07X/GNVDX6qvDE04jLrBdHKDPV3bDIlUemsvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjyM4aexdc/qLZ5ZPENR5917jblpR2htguLiYXUCBcwvujsGABeAIVXlpLj8bzeb+5kBAaa1tVVwdGW4hyPrIKBDbXBa+sTy5cCpr5u8UzXDhCi9zKerHkV2AOcQZ9l6TPXln5qREznNXWhScVIfBAojNG+F/+DgrFmK9DhXEuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+CNkrOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+CNkrOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385BBC16AAE;
	Sat, 14 Feb 2026 21:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104317;
	bh=/cqgyn07X/GNVDX6qvDE04jLrBdHKDPV3bDIlUemsvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+CNkrOKho40F0c3r3zQoObZSHzjZrzgKCYG1QNN9WRMwqtkhohF2LA6+qwEL7RUF
	 jtFoSMVoqbuXvMqZ0y1SlIh9vdP1W3IKLFcRdjpAc0NOSrj7Bi29u21UuyL6VjNgL4
	 b7n8Z791ULEahmddoGHyfTUy5BsJny2sw3PIBYNRiU4cV37UXSRFTAoJSLkx5e+KjI
	 aDJrOBZNM1Dw+k3B7UtlmGWb9o1GRI3rJ488rLUwtPbNT9ADckKxZCvtFCiAK+TVkG
	 ZAY/ZC4G/TcYxiP3pvJ2x74/DeCCS7rMDyDBrvtoRShAQEifV9E7d3VlivEY4K7IB8
	 V27sbBJb8d6aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Gomez <da.gomez@samsung.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.6] dm: replace -EEXIST with -EBUSY
Date: Sat, 14 Feb 2026 16:22:37 -0500
Message-ID: <20260214212452.782265-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Daniel Gomez <da.gomez@samsung.com>

[ Upstream commit b13ef361d47f09b7aecd18e0383ecc83ff61057e ]

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

This follows the precedent set by commit 54416fd76770 ("netfilter:
conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
issue in nf_conntrack_helper_register().

Affected modules:
  * dm_cache dm_clone dm_integrity dm_mirror dm_multipath dm_pcache
  * dm_vdo dm-ps-round-robin dm_historical_service_time dm_io_affinity
  * dm_queue_length dm_service_time dm_snapshot

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The precedent commit exists in the tree and was merged through the net
subsystem, confirming this is a recognized bug pattern.

### Stable Kernel Criteria Assessment

1. **Obviously correct and tested**: Yes - trivial error code
   substitution with clear rationale
2. **Fixes a real bug**: Yes - modules can silently fail to initialize,
   and userspace reports success
3. **Fixes an important issue**: Yes - affects many commonly used DM
   modules in enterprise storage environments; silent module load
   failures can cause data availability issues
4. **Small and contained**: Yes - 4 single-line changes, all identical
   in nature
5. **No new features or APIs**: Correct - only changes an error code
6. **Applies cleanly**: These files and functions have been stable for a
   long time; the change should apply cleanly to most stable trees

### User Impact

Device-mapper is heavily used in enterprise Linux (LVM, RAID, encryption
via dm-crypt, thin provisioning, etc.). If any DM module fails to
register its target/type during init and returns `-EEXIST`, kmod will
silently swallow the error. This could lead to:
- Storage subsystems appearing available but not functioning
- Difficult-to-diagnose failures in storage setups
- Potential data availability issues

### Risk vs Benefit

- **Risk**: Near zero. The change is a trivial error code substitution
  that makes the semantics correct.
- **Benefit**: Prevents silent module initialization failures across
  many DM modules, improving error visibility and system reliability.

This is a textbook stable backport candidate: a small, obviously correct
fix to a real bug with meaningful user impact and essentially zero
regression risk.

**YES**

 drivers/md/dm-exception-store.c | 2 +-
 drivers/md/dm-log.c             | 2 +-
 drivers/md/dm-path-selector.c   | 2 +-
 drivers/md/dm-target.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index c3799757bf4a0..88f119a0a2ae0 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -116,7 +116,7 @@ int dm_exception_store_type_register(struct dm_exception_store_type *type)
 	if (!__find_exception_store_type(type->name))
 		list_add(&type->list, &_exception_store_types);
 	else
-		r = -EEXIST;
+		r = -EBUSY;
 	spin_unlock(&_lock);
 
 	return r;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 9d85d045f9d9d..bced5a783ee33 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -121,7 +121,7 @@ int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
 	if (!__find_dirty_log_type(type->name))
 		list_add(&type->list, &_log_types);
 	else
-		r = -EEXIST;
+		r = -EBUSY;
 	spin_unlock(&_lock);
 
 	return r;
diff --git a/drivers/md/dm-path-selector.c b/drivers/md/dm-path-selector.c
index d0b883fabfeb6..2b0ac200f1c02 100644
--- a/drivers/md/dm-path-selector.c
+++ b/drivers/md/dm-path-selector.c
@@ -107,7 +107,7 @@ int dm_register_path_selector(struct path_selector_type *pst)
 
 	if (__find_path_selector_type(pst->name)) {
 		kfree(psi);
-		r = -EEXIST;
+		r = -EBUSY;
 	} else
 		list_add(&psi->list, &_path_selectors);
 
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 8fede41adec00..1fd41289de367 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -88,7 +88,7 @@ int dm_register_target(struct target_type *tt)
 	if (__find_target_type(tt->name)) {
 		DMERR("%s: '%s' target already registered",
 		      __func__, tt->name);
-		rv = -EEXIST;
+		rv = -EBUSY;
 	} else {
 		list_add(&tt->list, &_targets);
 	}
-- 
2.51.0

