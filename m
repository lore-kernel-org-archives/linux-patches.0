Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAAF1C82F4;
	Wed, 19 Mar 2025 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395110; cv=none; b=P6j9sbjVX2wuBOlc30r6Hz9iW95TEVVaOwKgut2PSdCkakAbSxaB18UE+N/WOU6xBQjWu/6px3SFVPn1V9S40oPkDt/geKzbCrOekCQyoUpCFC37W9KNWygiicOt2z/A/mPKC7vrqpkRSEUD6tPEuHff8efGzI3TgUXgIi9v19c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395110; c=relaxed/simple;
	bh=tWUWwBSJp4HJ4b/iSeUFtJJGPIoN4RwlHD0VPXUCGIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h52MkLktYKsM1ogppqL6SUaDmcWXfawtb9Hi1OesPfp+dSWcRx8ojeOhW6A8o16GlcbUZj8fKYADIg6zugA9cBGJZiBEslibLpnciynriMJjaiHGINZSe+wtTIR84caecRXLpGk1ZN+EmZJNGxhYGDxN5dWPO8UTlldvF2XhSco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpQ8Qn3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpQ8Qn3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC66AC4CEE4;
	Wed, 19 Mar 2025 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395110;
	bh=tWUWwBSJp4HJ4b/iSeUFtJJGPIoN4RwlHD0VPXUCGIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpQ8Qn3n/GP6Sriyf+3cGIOk0UZWLRXmoYL55KGXX5Fptq44Z2wBIyINq+TcdUUKS
	 SLundyiIua1HYZ/QvF/u3/lIptP1C6Ofg5+cgdZ1Jnaz6tYKVJjk6AA/w57UIWlH5/
	 g5TSELr+6ahg52SQ+/n5DvDT6nizpSZz2xXjawZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Tamir Duberstein <tamird@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 164/231] rust: alloc: satisfy POSIX alignment requirement
Date: Wed, 19 Mar 2025 07:30:57 -0700
Message-ID: <20250319143030.892916572@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


