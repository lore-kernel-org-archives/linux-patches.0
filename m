Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1852E2EFD8B;
	Thu,  3 Jul 2025 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555397; cv=none; b=YmQUc4KFxqhAB5l/jHgyXXzuAYQ15/V9JJTMpiozUT9AcQklLcVU6SB6CJQBY3IZCEINUzSNBIAj+FOccihINQUbfaBIrnEBVh8l83MubsZuofIi7kxX34ZCR4ihJsJX3tswe4PrCdTq+CBJFhIo0p99r9ghuJW3W9B4JewPSqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555397; c=relaxed/simple;
	bh=32t3hHRiGOQlE6dUXlh+3Pvm2K+jrmMtoxfJcIdfuUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3ACtJEeXi/8RMyr5+Bhkm0PLfuDgls4QdMmCO369Rzlft6grn8/7dnAiVVJMBuPIqyT3xb7pblzIVlm0sdSXcl9lepT90D9StHAYB/6DytdZ95tv4/hAe27EXbgsT80vp6UO5c1CPBKv1i3h0mN08XEt7T+sS1Q1YTz1DTosY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFlszCXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFlszCXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE14C4CEF7;
	Thu,  3 Jul 2025 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555396;
	bh=32t3hHRiGOQlE6dUXlh+3Pvm2K+jrmMtoxfJcIdfuUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFlszCXqEsSZozNAuqM1tqcyPMyL0fYKQc1dEjSARDufsLfvUOfDRcnJNV2WKjw4R
	 JTNpltrFnwpAhkD7JgtZ8V1W7MVvEVDqUZRjpLU8ArfliiHqnJ9J07hY2BCr+wsp4w
	 Knkv26s1yj7NeB1G23rJaIoy14uPGDU4e3GqAmlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.15 257/263] rust: devres: do not dereference to the internal Revocable
Date: Thu,  3 Jul 2025 16:42:57 +0200
Message-ID: <20250703144014.712154982@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 20c96ed278e362ae4e324ed7d8c69fb48c508d3c upstream.

We can't expose direct access to the internal Revocable, since this
allows users to directly revoke the internal Revocable without Devres
having the chance to synchronize with the devres callback -- we have to
guarantee that the internal Revocable has been fully revoked before
the device is fully unbound.

Hence, remove the corresponding Deref implementation and, instead,
provide indirect accessors for the internal Revocable.

Note that we can still support Devres::revoke() by implementing the
required synchronization (which would be almost identical to the
synchronization in Devres::drop()).

Fixes: 76c01ded724b ("rust: add devres abstraction")
Reviewed-by: Benno Lossin <lossin@kernel.org>
Link: https://lore.kernel.org/r/20250611174827.380555-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -12,13 +12,11 @@ use crate::{
     error::{Error, Result},
     ffi::c_void,
     prelude::*,
-    revocable::Revocable,
-    sync::{Arc, Completion},
+    revocable::{Revocable, RevocableGuard},
+    sync::{rcu, Arc, Completion},
     types::ARef,
 };
 
-use core::ops::Deref;
-
 #[pin_data]
 struct DevresInner<T> {
     dev: ARef<Device>,
@@ -196,13 +194,15 @@ impl<T> Devres<T> {
 
         Ok(())
     }
-}
 
-impl<T> Deref for Devres<T> {
-    type Target = Revocable<T>;
+    /// [`Devres`] accessor for [`Revocable::try_access`].
+    pub fn try_access(&self) -> Option<RevocableGuard<'_, T>> {
+        self.0.data.try_access()
+    }
 
-    fn deref(&self) -> &Self::Target {
-        &self.0.data
+    /// [`Devres`] accessor for [`Revocable::try_access_with_guard`].
+    pub fn try_access_with_guard<'a>(&'a self, guard: &'a rcu::Guard) -> Option<&'a T> {
+        self.0.data.try_access_with_guard(guard)
     }
 }
 
@@ -210,7 +210,7 @@ impl<T> Drop for Devres<T> {
     fn drop(&mut self) {
         // SAFETY: When `drop` runs, it is guaranteed that nobody is accessing the revocable data
         // anymore, hence it is safe not to wait for the grace period to finish.
-        if unsafe { self.revoke_nosync() } {
+        if unsafe { self.0.data.revoke_nosync() } {
             // We revoked `self.0.data` before the devres action did, hence try to remove it.
             if !DevresInner::remove_action(&self.0) {
                 // We could not remove the devres action, which means that it now runs concurrently,


