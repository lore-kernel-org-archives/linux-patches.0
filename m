Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A6375241;
	Sat, 28 Feb 2026 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301565; cv=none; b=B9el3L7jPOvznIam8lqkIBuvkDRLjMmZmPEp53tzAy1wBQhdydvO3UbLJz2F/9+xkQOgzDLHaPIqx+KQJgzO87/QlZcWfmDYdr0f03E+5FJNs5SO7erKLMLcIbWDCnibmVIM+uwPBVxEWaxdIiDokFcVepqdOis4cC2g8Nzm0SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301565; c=relaxed/simple;
	bh=dtV3Lrlv+tFenHcEPaB1+OGX3h/2+YPE7lEZIEDdyF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6xT760eFoGZvCjH4Hui7y494cqQpPihlaYCh/q4/T849+5aqg2x0wSx6ngH/co30Ukw7dmPwJC2T2B5LRD93JDRfYbLTxxL6VDv0g+UeoB5ovGzP3h38gOYQhheufN9Ek8B4EJvl0OFBZLanXVlGuz8eWX1TXi3B3fdKaOhUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFejJsLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFejJsLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389F0C116D0;
	Sat, 28 Feb 2026 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301565;
	bh=dtV3Lrlv+tFenHcEPaB1+OGX3h/2+YPE7lEZIEDdyF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFejJsLDpk6YFflbxyv7en/q2UqMrEY3JFsfHUJDBXeYjjcRktgrxjXY3VjvgnZ8m
	 75B+Ul4ZwcuD0USQmpQxh/Ft07vGs0PBHp7FkBPWCaBu0nv+MpK70XIZc2l7BcnjC3
	 ZTukyCZ9YQu1pmSNOcNNzz23vDnw7P0Q0KViis+JQyhmbsPtyl4v1kZXPZVmI/jt4t
	 3yBcenFtPVlnuAPcdr2q3QHCxnDz/t8WGGTe8leP8D2TLs3frnqQy2lnkLcs0jcnLp
	 cOU9oZfsJuEY+kcvWUZ7c/iU2fJ4ANdklwUOHBsIFBpaih+ljqvokXBnDTBt3GDf5l
	 cFlvcNQIWx3OQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Philipp Stanner <phasta@kernel.org>,
	stable@vger.kernel.org,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 748/752] rust: list: Add unsafe blocks for container_of and safety comments
Date: Sat, 28 Feb 2026 12:47:39 -0500
Message-ID: <20260228174750.1542406-748-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Philipp Stanner <phasta@kernel.org>

[ Upstream commit 97b281d7edb2ae662365be2809cd728470119720 ]

impl_list_item_mod.rs calls container_of! without unsafe blocks at a
couple of places. Since container_of! is unsafe, the blocks are strictly
necessary.

The problem was so far not visible because the "unsafe-op-in-unsafe-fn"
check is a lint rather than a hard compiler error, and Rust suppresses
lints triggered inside of a macro from another crate.

Thus, the error becomes only visible once someone from within the kernel
crate tries to use linked lists:

    error[E0133]: call to unsafe function `core::ptr::mut_ptr::<impl *mut T>::byte_sub`
    is unsafe and requires unsafe block
       --> rust/kernel/lib.rs:252:29
        |
    252 |           let container_ptr = field_ptr.byte_sub(offset).cast::<$Container>();
        |                               ^^^^^^^^^^^^^^^^^^^^^^^^^^ call to unsafe function
        |
       ::: rust/kernel/drm/jq.rs:98:1
        |
    98  | / impl_list_item! {
    99  | |     impl ListItem<0> for BasicItem { using ListLinks { self.links }; }
    100 | | }
        | |_- in this macro invocation
        |
    note: an unsafe function restricts its caller, but its body is safe by default
       --> rust/kernel/list/impl_list_item_mod.rs:216:13
        |
    216 |               unsafe fn view_value(me: *mut $crate::list::ListLinks<$num>) -> *const Self {
        |               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
       ::: rust/kernel/drm/jq.rs:98:1
        |
    98  | / impl_list_item! {
    99  | |     impl ListItem<0> for BasicItem { using ListLinks { self.links }; }
    100 | | }
        | |_- in this macro invocation
        = note: requested on the command line with `-D unsafe-op-in-unsafe-fn`
        = note: this error originates in the macro `$crate::container_of` which comes
        from the expansion of the macro `impl_list_item`

Therefore, add unsafe blocks to container_of! calls to fix the issue.

[ As discussed, let's fix the build for those that want to use the
  macro within the `kernel` crate now and we can discuss the proper
  safety comments afterwards. Thus I removed the ones from the patch.

  However, we cannot just avoid the comments with `CLIPPY=1`, so I
  provided placeholders for now, like we did in the past. They were
  also needed for an `unsafe impl`.

  While I am not happy about it, it isn't worse than the current
  status (the comments were meant to be there), and at least this
  shows what is missing -- our pre-existing "good first issue" [1]
  may motivate new contributors to complete them properly.

  Finally, I moved one of the existing safety comments one line down
  so that Clippy could locate it.

  Link: https://github.com/Rust-for-Linux/linux/issues/351 [1]

    - Miguel ]

Cc: stable@vger.kernel.org
Fixes: c77f85b347dd ("rust: list: remove OFFSET constants")
Suggested-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260216131613.45344-3-phasta@kernel.org
[ Fixed formatting. Reworded to fix the lint suppression
  explanation. Indent build error. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/list/impl_list_item_mod.rs | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/list/impl_list_item_mod.rs b/rust/kernel/list/impl_list_item_mod.rs
index 202bc6f97c132..ee53d0387e63d 100644
--- a/rust/kernel/list/impl_list_item_mod.rs
+++ b/rust/kernel/list/impl_list_item_mod.rs
@@ -84,11 +84,12 @@ macro_rules! impl_has_list_links_self_ptr {
         // right type.
         unsafe impl$(<$($generics)*>)? $crate::list::HasSelfPtr<$item_type $(, $id)?> for $self {}
 
+        // SAFETY: TODO.
         unsafe impl$(<$($generics)*>)? $crate::list::HasListLinks$(<$id>)? for $self {
             #[inline]
             unsafe fn raw_get_list_links(ptr: *mut Self) -> *mut $crate::list::ListLinks$(<$id>)? {
-                // SAFETY: The caller promises that the pointer is not dangling.
                 let ptr: *mut $crate::list::ListLinksSelfPtr<$item_type $(, $id)?> =
+                    // SAFETY: The caller promises that the pointer is not dangling.
                     unsafe { ::core::ptr::addr_of_mut!((*ptr)$(.$field)*) };
                 ptr.cast()
             }
@@ -217,7 +218,7 @@ macro_rules! impl_list_item {
                 // SAFETY: `me` originates from the most recent call to `prepare_to_insert`, so it
                 // points at the field `$field` in a value of type `Self`. Thus, reversing that
                 // operation is still in-bounds of the allocation.
-                $crate::container_of!(me, Self, $($field).*)
+                unsafe { $crate::container_of!(me, Self, $($field).*) }
             }
 
             // GUARANTEES:
@@ -242,7 +243,7 @@ macro_rules! impl_list_item {
                 // SAFETY: `me` originates from the most recent call to `prepare_to_insert`, so it
                 // points at the field `$field` in a value of type `Self`. Thus, reversing that
                 // operation is still in-bounds of the allocation.
-                $crate::container_of!(me, Self, $($field).*)
+                unsafe { $crate::container_of!(me, Self, $($field).*) }
             }
         }
     )*};
@@ -270,9 +271,12 @@ macro_rules! impl_list_item {
                 // SAFETY: The caller promises that `me` points at a valid value of type `Self`.
                 let links_field = unsafe { <Self as $crate::list::ListItem<$num>>::view_links(me) };
 
-                let container = $crate::container_of!(
-                    links_field, $crate::list::ListLinksSelfPtr<Self, $num>, inner
-                );
+                // SAFETY: TODO.
+                let container = unsafe {
+                    $crate::container_of!(
+                        links_field, $crate::list::ListLinksSelfPtr<Self, $num>, inner
+                    )
+                };
 
                 // SAFETY: By the same reasoning above, `links_field` is a valid pointer.
                 let self_ptr = unsafe {
@@ -319,9 +323,12 @@ macro_rules! impl_list_item {
             //   `ListArc` containing `Self` until the next call to `post_remove`. The value cannot
             //   be destroyed while a `ListArc` reference exists.
             unsafe fn view_value(links_field: *mut $crate::list::ListLinks<$num>) -> *const Self {
-                let container = $crate::container_of!(
-                    links_field, $crate::list::ListLinksSelfPtr<Self, $num>, inner
-                );
+                // SAFETY: TODO.
+                let container = unsafe {
+                    $crate::container_of!(
+                        links_field, $crate::list::ListLinksSelfPtr<Self, $num>, inner
+                    )
+                };
 
                 // SAFETY: By the same reasoning above, `links_field` is a valid pointer.
                 let self_ptr = unsafe {
-- 
2.51.0

