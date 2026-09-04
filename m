Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375543515D2;
	Fri,  4 Sep 2026 05:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498356; cv=none; b=eGViE4QzkMwPqp/aWymvPqtU7IdAQZfWYrCaEGNxMzx+6S2oeu8Bor548XFuIypzfgKV7XXD4N3OXYXrXNnxEjdUF3ns9JKEal9z8yMGQRRzxhSRXn3esfCv9OX0nugOg1K9o2E0sIFskpWWYGSLjGOtqbXob7UdteG/7YqSwL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498356; c=relaxed/simple;
	bh=ridNOkhBUSJbTOj1xZD50lc5haTWkx2dBCuOd0YzyRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6wQfIuX0OYoSL6mUZLifwOg+IlaOd7pDYsLjPCf5/VBc8CdCe+l9rmnOU/UjDJvokQCakE3KVVOFJdoWs1MM3hwbbT5gAk0wRCDRnGlXn9DXYAHyrb04kdHDouAnJT5wh60V7ms1THeUccnpLwYnD0AHJ04iuCGlZRtdYzwYZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJi96phx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJi96phx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928A41F00A3D;
	Fri,  4 Sep 2026 05:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498355;
	bh=F8dRMmHpO2ZpZArBfGfL51Z03UsFJtW1hO4UP0llrMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJi96phxz5BjdfW6CsKDUBTPC6KXQUK4Ma7iqNDGAwGe9gii+mugPa9fFP5lfRq+a
	 SUyKIisZtXQterMiGA/pq9JWc7/Kqqttl6C2TZLIrq7mEdVMYU274dMMborxejLMCP
	 OF27VKMIUt+EOLQYwulPRVNgdT3oqVxX7oS3EoZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.2 032/713] rust: devres: fix race between concurrent revokers
Date: Fri,  4 Sep 2026 06:50:00 +0200
Message-ID: <20260904045804.551513102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

commit acc516dfa1972d31836b50abc0115216cd0fccc5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -21,7 +21,8 @@ use crate::{
     sync::{
         aref::ARef,
         rcu,
-        Arc, //
+        Arc,
+        Completion, //
     },
     types::{
         ForeignOwnable,
@@ -37,6 +38,8 @@ struct Inner<T> {
     node: Opaque<bindings::devres_node>,
     #[pin]
     data: Revocable<T>,
+    #[pin]
+    revocation: Completion,
 }
 
 /// This abstraction is meant to be used by subsystems to containerize [`Device`] bound resources to
@@ -53,6 +56,10 @@ struct Inner<T> {
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
@@ -218,6 +225,7 @@ impl<T: Send + 'static> Devres<T> {
                     };
                 }),
                 data <- Revocable::new(data),
+                revocation <- Completion::new(),
             }),
             GFP_KERNEL,
         )?;
@@ -255,7 +263,9 @@ impl<T: Send + 'static> Devres<T> {
         // SAFETY: `inner` is a valid `Inner<T>` pointer.
         let inner = unsafe { &*inner };
 
-        inner.data.revoke();
+        if inner.data.revoke() {
+            inner.revocation.complete_all();
+        }
     }
 
     #[allow(clippy::missing_safety_doc)]
@@ -362,6 +372,10 @@ impl<T: Send + 'static> Drop for Devres<
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


