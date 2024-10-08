Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42CC1DE4CD;
	Tue,  8 Oct 2024 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393642; cv=none; b=axDOY+GAIjm+zIH6JnBFj/qLqFBf7NhyWPkI7LVX4Y5vAY0v9q3uCnd8EUIeTdILnA3GGAbNyoH07SfUrSPHINlS8LIttDguqygFAj6/mSX2SWGecEN3MgoQxCeC+skk7eT5/9o9LPuLnfGTIyBLx26jalFQbiI5cbeg7m8fYfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393642; c=relaxed/simple;
	bh=PW+MOduTbp881l3exYLkB2mGM8SlqvnF/JU6qJFqexg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIsIViZyn2ZVF2n06aqyXeQE4OOZ30TOfume0fzKvjhxncQlYwGjE5WH5dkLz+b3kpLGaXqqPjmCE4OdwEIjiQ+2xPsnOgE2XvNBhpMSkUX8AT3W6E7iXceq6oIQKb92L/i41e94hxjwo1nkvNg/a9T/jtdnKyd06/97aYUJhZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6Q+3V2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6Q+3V2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF26C4CEC7;
	Tue,  8 Oct 2024 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393642;
	bh=PW+MOduTbp881l3exYLkB2mGM8SlqvnF/JU6qJFqexg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6Q+3V2Y4PHhw8ASoFwvsL3pUco9nvOCLAnpxgNsz0nOqTkUyE9IcVGiq/w/lPtoN
	 dZfpXlexgMzmtg+8wLzloJgZPKW2eFbYXiBWQ+8NZM5Uj8sbwwFxORy6SllkRcnRX+
	 mdP/N2l4ZpgCIlMG8iJlL6tMbpyv8c0pG4CvFla0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 212/386] rust: sync: require `T: Sync` for `LockedBy::access`
Date: Tue,  8 Oct 2024 14:07:37 +0200
Message-ID: <20241008115637.749402530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit a8ee30f45d5d57467ddb7877ed6914d0eba0af7f upstream.

The `LockedBy::access` method only requires a shared reference to the
owner, so if we have shared access to the `LockedBy` from several
threads at once, then two threads could call `access` in parallel and
both obtain a shared reference to the inner value. Thus, require that
`T: Sync` when calling the `access` method.

An alternative is to require `T: Sync` in the `impl Sync for LockedBy`.
This patch does not choose that approach as it gives up the ability to
use `LockedBy` with `!Sync` types, which is okay as long as you only use
`access_mut`.

Cc: stable@vger.kernel.org
Fixes: 7b1f55e3a984 ("rust: sync: introduce `LockedBy`")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240915-locked-by-sync-fix-v2-1-1a8d89710392@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync/locked_by.rs |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/rust/kernel/sync/locked_by.rs
+++ b/rust/kernel/sync/locked_by.rs
@@ -80,8 +80,12 @@ pub struct LockedBy<T: ?Sized, U: ?Sized
 // SAFETY: `LockedBy` can be transferred across thread boundaries iff the data it protects can.
 unsafe impl<T: ?Sized + Send, U: ?Sized> Send for LockedBy<T, U> {}
 
-// SAFETY: `LockedBy` serialises the interior mutability it provides, so it is `Sync` as long as the
-// data it protects is `Send`.
+// SAFETY: If `T` is not `Sync`, then parallel shared access to this `LockedBy` allows you to use
+// `access_mut` to hand out `&mut T` on one thread at the time. The requirement that `T: Send` is
+// sufficient to allow that.
+//
+// If `T` is `Sync`, then the `access` method also becomes available, which allows you to obtain
+// several `&T` from several threads at once. However, this is okay as `T` is `Sync`.
 unsafe impl<T: ?Sized + Send, U: ?Sized> Sync for LockedBy<T, U> {}
 
 impl<T, U> LockedBy<T, U> {
@@ -115,7 +119,10 @@ impl<T: ?Sized, U> LockedBy<T, U> {
     ///
     /// Panics if `owner` is different from the data protected by the lock used in
     /// [`new`](LockedBy::new).
-    pub fn access<'a>(&'a self, owner: &'a U) -> &'a T {
+    pub fn access<'a>(&'a self, owner: &'a U) -> &'a T
+    where
+        T: Sync,
+    {
         build_assert!(
             size_of::<U>() > 0,
             "`U` cannot be a ZST because `owner` wouldn't be unique"
@@ -124,7 +131,10 @@ impl<T: ?Sized, U> LockedBy<T, U> {
             panic!("mismatched owners");
         }
 
-        // SAFETY: `owner` is evidence that the owner is locked.
+        // SAFETY: `owner` is evidence that there are only shared references to the owner for the
+        // duration of 'a, so it's not possible to use `Self::access_mut` to obtain a mutable
+        // reference to the inner value that aliases with this shared reference. The type is `Sync`
+        // so there are no other requirements.
         unsafe { &*self.data.get() }
     }
 


