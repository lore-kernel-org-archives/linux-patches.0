Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A253D6664;
	Fri,  4 Sep 2026 05:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498503; cv=none; b=pn92Vd0hXgDznh4eQy5xowW4ZBSaF2dzR42Di78qWXqVz84cthnVfAZzOL4Iihom94jx8bt5NIg3Wwm7ibTWpYMpxnsJKhFZEvdqZSY0jyEANybOMTjtNx3WLbEi4S5smYmTg14xkveBb1LtKaNFzFi0QdMNRIvkOyyypbGJ7YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498503; c=relaxed/simple;
	bh=Nk3HXmh+DkA3+YjWAmV12BkD2tqOvbuccVxY9OWFOB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlCLkdjvuRcRA6egda9UTE26QXwUr8zMtDvyawZeHefPNmnIprTTXyPUjkWnUamoOPCreydCAxFHpQvo9Tv3JUkexbMf4bp5QsokXjsOuMCDz9Ehh0MCr+z5ZrBj/s6nrCUb6eHelRxoMvUl376se+Gjz01J7yGNV413bm66qGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLrFghUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLrFghUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F631F00A3D;
	Fri,  4 Sep 2026 05:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498497;
	bh=hoTNyK5pOc+t3uvfL0N7lR5cqCt6P4y6M6RaFKAGvS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLrFghUuH+nxLKXPpAWXeJ8sFjqQz15v1SmYV7HqvRPp/k8TsOtQj6Ulai/aUTnm4
	 Z+F8IHETjgWyAPSyGuykw51EBBHKP3sTEsLOisK9N1yD56WTYZapESBYpp4gEUAt5G
	 WVmSAbbwdSrCmrzYWDyM5jJ0csN8HXEI75Gv0Eqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.2 033/713] rust: devres: ensure revocation is complete before device finishes unbinding
Date: Fri,  4 Sep 2026 06:50:01 +0200
Message-ID: <20260904045804.572867665@linuxfoundation.org>
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

commit a10639966fd72fff8f7fbf3c8e733307daabd38f upstream.

Now that the revocation Completion is in place, also address the
symmetric case. When Devres::drop() wins the is_available swap and the
devres callback loses, the callback returns to devres_release_all()
without waiting. This means device unbinding can complete while
Devres::drop() is still executing drop_in_place() on another CPU, which
is a problem if T's destructor accesses device state.

Make the synchronization bidirectional. Whichever side performs
drop_in_place() signals the Completion, and the other side waits.

This does not reintroduce the nested Devres deadlock fixed by commit
ba268514ea14 ("rust: devres: fix race condition due to nesting"),
because that deadlock was caused by drop waiting for the release
callback to return (the old 'devm' Completion). Here, both sides only
wait for drop_in_place() to finish, which completes within the current
call chain. The Arc<Inner<T>> keeps the Inner allocation alive
independently.

Cc: stable@vger.kernel.org
Fixes: ba268514ea14 ("rust: devres: fix race condition due to nesting")
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260628200304.2365598-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -265,6 +265,11 @@ impl<T: Send + 'static> Devres<T> {
 
         if inner.data.revoke() {
             inner.revocation.complete_all();
+        } else {
+            // Devres::drop() is concurrently revoking; wait for it to finish `drop_in_place()`
+            // before returning to `devres_release_all()`, ensuring `T` is fully torn down before
+            // the device finishes unbinding.
+            inner.revocation.wait_for_completion();
         }
     }
 
@@ -365,6 +370,8 @@ impl<T: Send + 'static> Drop for Devres<
         // SAFETY: When `drop` runs, it is guaranteed that nobody is accessing the revocable data
         // anymore, hence it is safe not to wait for the grace period to finish.
         if unsafe { self.data().revoke_nosync() } {
+            self.inner.revocation.complete_all();
+
             // We revoked `self.data` before devres did, hence try to remove it.
             if self.remove_node() {
                 // SAFETY: In `Self::new` we have taken an additional reference count of `self.data`


