Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECD11E87B;
	Mon, 23 Jun 2025 22:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716340; cv=none; b=caYJaakuKnOH1iLvQlX7w3GvSZq78OoHLDSyyv9jcwWvAvcG1cJSUNqD1XbLcRI5tY6Nup6lNR4xioMdiuFLt/DKo1wkEczrH7QjvGBZz2Ff+qnhEXFAmxMRgktmrhGEgwrDQWjfilS0rPckmg+PbIoJBQaEcy2qTXcSgfwN4qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716340; c=relaxed/simple;
	bh=npkUWVhQtOH0RRTa61aIm8bcBU46MZNb5w7wTiXzYMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ap+kUvN15G8kjGkZrYTevUXJ5SWBJHXiVDE6ldmEq/bpmfsVHU+TJdm+CgatuZYUk0lMytwiUPM82uzRHq93YBvP7c7T7qP209TL+GPS4uWiuGBIcgvJtAje8Dj0KDVWc3aORi+sGKaQ1g3JyCIZSwJO/Hu5kSJwW/6qgRHUXM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upVkzZaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upVkzZaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3780DC4CEEA;
	Mon, 23 Jun 2025 22:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716340;
	bh=npkUWVhQtOH0RRTa61aIm8bcBU46MZNb5w7wTiXzYMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upVkzZaX7C4sqGGbtQP3Hua0iPrlLT6F/xzs14eeqG0+KHrkoUJ2imVQtaolMVEns
	 lsvQ+T0tokQ+iQg938PWxlPt3tRY2HyfKGzsa4ztwd2NeoA6sangz6McfOpD10SUiI
	 B+QjAFVHYdtK16L/Z73B/uOjRxEnsDvxzwJRvIKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 517/592] rust: devres: do not dereference to the internal Revocable
Date: Mon, 23 Jun 2025 15:07:55 +0200
Message-ID: <20250623130712.734400052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

[ Upstream commit 20c96ed278e362ae4e324ed7d8c69fb48c508d3c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/devres.rs | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index acb8e1d13ddd9..5f1a7be2ed512 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -12,13 +12,11 @@
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
@@ -232,15 +230,22 @@ pub fn access<'a>(&'a self, dev: &'a Device<Bound>) -> Result<&'a T> {
         // SAFETY: `dev` being the same device as the device this `Devres` has been created for
         // proves that `self.0.data` hasn't been revoked and is guaranteed to not be revoked as
         // long as `dev` lives; `dev` lives at least as long as `self`.
-        Ok(unsafe { self.deref().access() })
+        Ok(unsafe { self.0.data.access() })
     }
-}
 
-impl<T> Deref for Devres<T> {
-    type Target = Revocable<T>;
+    /// [`Devres`] accessor for [`Revocable::try_access`].
+    pub fn try_access(&self) -> Option<RevocableGuard<'_, T>> {
+        self.0.data.try_access()
+    }
+
+    /// [`Devres`] accessor for [`Revocable::try_access_with`].
+    pub fn try_access_with<R, F: FnOnce(&T) -> R>(&self, f: F) -> Option<R> {
+        self.0.data.try_access_with(f)
+    }
 
-    fn deref(&self) -> &Self::Target {
-        &self.0.data
+    /// [`Devres`] accessor for [`Revocable::try_access_with_guard`].
+    pub fn try_access_with_guard<'a>(&'a self, guard: &'a rcu::Guard) -> Option<&'a T> {
+        self.0.data.try_access_with_guard(guard)
     }
 }
 
@@ -248,7 +253,7 @@ impl<T> Drop for Devres<T> {
     fn drop(&mut self) {
         // SAFETY: When `drop` runs, it is guaranteed that nobody is accessing the revocable data
         // anymore, hence it is safe not to wait for the grace period to finish.
-        if unsafe { self.revoke_nosync() } {
+        if unsafe { self.0.data.revoke_nosync() } {
             // We revoked `self.0.data` before the devres action did, hence try to remove it.
             if !DevresInner::remove_action(&self.0) {
                 // We could not remove the devres action, which means that it now runs concurrently,
-- 
2.39.5



