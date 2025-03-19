Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6511DDC2D;
	Wed, 19 Mar 2025 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394946; cv=none; b=O7CPU7BYwo3fzzorsRdwbcowpDAkdIqPOEUBLRJ+eKinRSrOvGOTTMUcOMqRDVHX7e9fFfzhPk/gXXzGD5YvMa22oZOmp3b9e1wWfkJ/JEmvvD/lxR0rRBQ3OzICxwvBulTyAxhrFreDVLmvha+TZvGebcThBSDTwsah+dPlltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394946; c=relaxed/simple;
	bh=oKzjSAmskOPg3GKFnq8rSO7YKPXNI7z1gN/eHKBIgRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afrIaiOxkwBvw8fW2RYwv6CsYW0Zupm7qWb3HDnCCynQN519HJMuevJW034jqqisYKwv6Uai3KDcSReFy22OgBP1dDVstUPctti6EdtvEWpYvdc+mr38AfwTQWYBVz7EdwaPP4kIUity4nq+mjfCwMcXCJVIuZTs/DepeO1NOPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrMdNect; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrMdNect"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB50C4CEE4;
	Wed, 19 Mar 2025 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394946;
	bh=oKzjSAmskOPg3GKFnq8rSO7YKPXNI7z1gN/eHKBIgRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrMdNectEs8lBz/3kAr0nkN6FgyfuAdDARptNnn+tGpEIGL37rDrvoVqpK32Z41iZ
	 9zTFg37KBrpyjWjM7CZ8jQlt3UpBnl3PVqGWSoM0NubbqEtEFKL/ovdZHD96K6sVtb
	 W2SzeamXzzeAOY3B4/B4FBIj1N9ViEWB4fxeInvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Tamir Duberstein <tamird@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.13 169/241] rust: alloc: satisfy POSIX alignment requirement
Date: Wed, 19 Mar 2025 07:30:39 -0700
Message-ID: <20250319143031.909191595@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@gmail.com>

commit ff64846bee0e7e3e7bc9363ebad3bab42dd27e24 upstream.

ISO C's `aligned_alloc` is partially implementation-defined; on some
systems it inherits stricter requirements from POSIX's `posix_memalign`.

This causes the call added in commit dd09538fb409 ("rust: alloc:
implement `Cmalloc` in module allocator_test") to fail on macOS because
it doesn't meet the requirements of `posix_memalign`.

Adjust the call to meet the POSIX requirement and add a comment. This
fixes failures in `make rusttest` on macOS.

Acked-by: Danilo Krummrich <dakr@kernel.org>
Cc: stable@vger.kernel.org
Fixes: dd09538fb409 ("rust: alloc: implement `Cmalloc` in module allocator_test")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20250213-aligned-alloc-v7-1-d2a2d0be164b@gmail.com
[ Added Cc: stable. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/allocator_test.rs |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -62,6 +62,24 @@ unsafe impl Allocator for Cmalloc {
             ));
         }
 
+        // ISO C (ISO/IEC 9899:2011) defines `aligned_alloc`:
+        //
+        // > The value of alignment shall be a valid alignment supported by the implementation
+        // [...].
+        //
+        // As an example of the "supported by the implementation" requirement, POSIX.1-2001 (IEEE
+        // 1003.1-2001) defines `posix_memalign`:
+        //
+        // > The value of alignment shall be a power of two multiple of sizeof (void *).
+        //
+        // and POSIX-based implementations of `aligned_alloc` inherit this requirement. At the time
+        // of writing, this is known to be the case on macOS (but not in glibc).
+        //
+        // Satisfy the stricter requirement to avoid spurious test failures on some platforms.
+        let min_align = core::mem::size_of::<*const crate::ffi::c_void>();
+        let layout = layout.align_to(min_align).map_err(|_| AllocError)?;
+        let layout = layout.pad_to_align();
+
         // SAFETY: Returns either NULL or a pointer to a memory allocation that satisfies or
         // exceeds the given size and alignment requirements.
         let dst = unsafe { libc_aligned_alloc(layout.align(), layout.size()) } as *mut u8;


