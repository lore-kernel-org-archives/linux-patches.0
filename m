Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4853563FBF;
	Wed,  9 Sep 2026 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964507; cv=none; b=jquAmbW3Yjy4eniU3lDcWW8DnStmhBPeq5y+JyRocvmJB+4ES6DSxUAUzV8U/EiLylemPiH6j5pViHdmU5Q5xaYP5VEQMvzyK2Rgw7PaPkcNmI4tV6m3fF0IoFn3+IOr4QI6k5EqKPo/tmNZmMxN8/a0TT/C/Bp7tusaM59we68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964507; c=relaxed/simple;
	bh=D2dzprBryVZrwq+RknknnozQuoFo1zZpA/BRjtPAg3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3eH5YU/5xQGod6mgTYVJ9wiOhCwt0syzr8Vij2YESPdyXYkxDFDWizQ5zs9XBI8PRMwaTYQtKxADDBw8KT1mjgmoLyUXLqQmQNlLr6DQzrtTxykzZJGPu9dVFTaTtjNKV4oiS2uqWXTPdaNI91JdcGdldIpk2SNHhmgV+Z5ALw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adn5CCG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adn5CCG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432341F00A3A;
	Wed,  9 Sep 2026 14:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964505;
	bh=CsSmgp+4F8Bay5a/nNbdXh5LI+WiGaK5lpSi0rYNYH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Adn5CCG+RbWB42tGXyR6LoK4HHrqQUns+mSDLorNEbMltFXn2gb7zvDV7s2O8kJk0
	 u3+PF7ygEsrs7EYQctjupwIYsXrGLuMed8CpR/+HO83yZNe/tXJgi76HXb4GKz5Id2
	 lT7jHXHVszWbiMS1G1m/9TYhPyd90RiQfnpQblLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 447/583] rust: bug: prevent dead_code warning from warn_on!s flags constant
Date: Wed,  9 Sep 2026 15:42:12 +0200
Message-ID: <20260909134253.450480334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

[ Upstream commit e66cfc29e0d06fec34c06bb40d4d281f595677b1 ]

Fix the following dead_code warning on some configurations in an
atomic development branch:

warning: constant `WARN_ON_FLAGS` is never used
   --> linux/rust/kernel/bug.rs:126:19
    |
126 |               const WARN_ON_FLAGS: u32 = $crate::bug::bugflag_taint($crate::bindings::TAINT_WARN);
    |                     ^^^^^^^^^^^^^
    |
   ::: linux/rust/kernel/sync/srcu.rs:106:12
    |
106 |           if crate::warn_on!(
    |  ____________-
107 | |             // SAFETY: By the type invariants, `self` contains a valid and pinned `struct srcu_struct`
108 | |             // and `srcu_readers_active()` only checks the active reader count.
109 | |             unsafe { bindings::srcu_readers_active(ptr) }
110 | |         ) {
    | |_________- in this macro invocation
    |
    = note: `#[warn(dead_code)]` (part of `#[warn(unused)]`) on by default
    = note: this warning originates in the macro `crate::warn_on` (in Nightly builds, run with -Z macro-backtrace for more info)

The warn_on! macro always defines a WARN_ON_FLAGS constant and hands it
to warn_flags!. On configurations where warn_flags! does not reference
its flags argument (the LOONGARCH/ARM variant, which only calls
WARN_ON(), and the !CONFIG_BUG no-op variant), the constant is left
unused and triggers a dead_code warning.

warn_flags! is the macro that accepts (and here discards) the flags
argument, so make it responsible for the argument it drops.

Also rename `_COND_STR` to `COND_STR` and consume `$file` for consistency.

Fixes: dff64b072708 ("rust: Add warn_on macro")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260801024841.786664-1-tomo@flapping.org
[ Added newlines. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ adapted unreachable flag consumption to the older one-argument warn_flags! interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bug.rs |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -98,6 +98,10 @@ macro_rules! warn_flags {
 #[cfg(all(CONFIG_BUG, any(CONFIG_LOONGARCH, CONFIG_ARM)))]
 macro_rules! warn_flags {
     ($flags:expr) => {
+        if false {
+            _ = $flags;
+        }
+
         // SAFETY: It is always safe to call `WARN_ON()`.
         unsafe { $crate::bindings::WARN_ON(true) }
     };
@@ -107,7 +111,11 @@ macro_rules! warn_flags {
 #[doc(hidden)]
 #[cfg(any(testlib, not(CONFIG_BUG)))]
 macro_rules! warn_flags {
-    ($flags:expr) => {};
+    ($flags:expr) => {
+        if false {
+            _ = $flags;
+        }
+    };
 }
 
 #[doc(hidden)]


