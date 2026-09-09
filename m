Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F6E57D20A;
	Wed,  9 Sep 2026 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964504; cv=none; b=lvMkWtPLkY+Etz47N7j7feHYthAWd0TN4sNgvwN4LgonMTb1p6cji447m8XZVT1eHkHQlSv8zhr2nRGuvN3mpMHbj/DSmc9lRxjCBEZth7qlrcKceiVRuvCovqG8os8zqZvWj2JNdQSJQZwFyrqvnCEydj9xHvDePWejMOiYxlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964504; c=relaxed/simple;
	bh=inpqEiaM3MPRQikzh0WMc9UN/gdvC6LpvdHaPOp124g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zlv1f808wXBVwTLTnctfyMtlgCJWthkPsSiQl4albDByCTTtBjdYzNjmkr6/wq1nA+1BcJWT5Qy042vfhJBiNNHHj81t8mSHtcd+POCbE3ad2MBh461E7vyYPFwcpdorG7Nv9sWLv4lFWziL92PohXO9A6TIr5xkjajA6pK8TuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmYx0iGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmYx0iGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E0B1F00A3A;
	Wed,  9 Sep 2026 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964502;
	bh=MT3ZZmV2YhLDS0pU8KSAEV1XHO2XnDVyBgtkJyDwJ/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmYx0iGLeEfQBVqMOGFAIPemTRDozOo4OCiDFJNwxOsMehLDA9WEonLfAzEe9TcpS
	 S5ssBaUtidqcTl9+Kjolr7QFq+13HjFkQH8WfEhnOqnJd8RReaO0xj07XeDrwIb0+e
	 me3JcHJWq6qbUhi83fG8ceEg8XvHfGgv4PMU28W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 446/583] rust: devres: fix race between concurrent revokers
Date: Wed,  9 Sep 2026 15:42:11 +0200
Message-ID: <20260909134253.419084511@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit acc516dfa1972d31836b50abc0115216cd0fccc5 ]

There is a potential race condition when two paths try to revoke a
Devres concurrently.

The driver core's devres_release_all() calls Revocable::revoke() via the
release callback, while Devres::drop() calls revoke_nosync() on another
CPU.

The revoker that does not claim the is_available swap returns
immediately, but the revoker that did may still be executing
drop_in_place() on the inner data. This can cause a use-after-free when
the other revoker's caller proceeds to drop adjacent resources that
drop_in_place() still references (e.g., Devres<DmaMappedSgt> racing with
SGTable freeing the backing sg_table and pages).

Fix this by adding a Completion. The release callback signals the
Completion after revoke() finishes, and Devres::drop() waits for it when
it loses the is_available swap. This ensures the wrapped object is fully
torn down before Devres::drop() returns.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/dri-devel/20260612202841.2577C1F000E9@smtp.kernel.org/
Fixes: 05aa6fb1c21d ("rust: scatterlist: Add abstraction for sg_table")
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260628174451.2275679-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -19,7 +19,8 @@ use crate::{
     sync::{
         aref::ARef,
         rcu,
-        Arc, //
+        Arc,
+        Completion, //
     },
     types::ForeignOwnable,
 };
@@ -28,6 +29,8 @@ use crate::{
 struct Inner<T: Send> {
     #[pin]
     data: Revocable<T>,
+    #[pin]
+    revocation: Completion,
 }
 
 /// This abstraction is meant to be used by subsystems to containerize [`Device`] bound resources to
@@ -44,6 +47,10 @@ struct Inner<T: Send> {
 /// After the [`Devres`] has been unbound it is not possible to access the encapsulated resource
 /// anymore.
 ///
+/// When a [`Devres`] is dropped, it is guaranteed that `T` has been fully dropped by the time
+/// [`Devres::drop`] returns, even if a concurrent revocation through the release callback is in
+/// progress.
+///
 /// [`Devres`] users should make sure to simply free the corresponding backing resource in `T`'s
 /// [`Drop`] implementation.
 ///
@@ -133,6 +140,7 @@ impl<T: Send> Devres<T> {
         let inner = Arc::pin_init(
             try_pin_init!(Inner {
                 data <- Revocable::new(data),
+                revocation <- Completion::new(),
             }),
             GFP_KERNEL,
         )?;
@@ -171,7 +179,9 @@ impl<T: Send> Devres<T> {
         // `devm_add_action()`, hence `ptr` must be a valid pointer to `Inner<T>`.
         let inner = unsafe { Arc::from_raw(ptr.cast::<Inner<T>>()) };
 
-        inner.data.revoke();
+        if inner.data.revoke() {
+            inner.revocation.complete_all();
+        }
     }
 
     fn remove_action(&self) -> bool {
@@ -266,6 +276,10 @@ impl<T: Send> Drop for Devres<T> {
                 // this additional reference count.
                 drop(unsafe { Arc::from_raw(Arc::as_ptr(&self.inner)) });
             }
+        } else {
+            // The release callback is concurrently revoking; wait for it to finish
+            // `drop_in_place()` of the wrapped object before returning.
+            self.inner.revocation.wait_for_completion();
         }
     }
 }


