Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D1D230BF6;
	Mon, 10 Mar 2025 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627260; cv=none; b=CMxAuI9jrIDBp8Ta49hzaJrB59jZJ7OiNnq3MvWEwoW8wysqY626YgOz/jNege0uzd79Gsi35rFfZtDhcokfIdxXrA9SLLUz1/6R4418mwCMr3o3WAKf1KzfzMZNJdtE/zW8Ycu7jndcEdRvktLZvNXNhhm+UVJuKL4TYJIF16o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627260; c=relaxed/simple;
	bh=4/uvbyMZC6hyolwl7SieSSRDXBmb8gvJA66hKhGdjEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmyGHhPRhkrzKSmD8xj8Df/Gbv46cAOeWBmV9viOo17XOVkpSj/XiQZCmSftcxLZEsbBQseo0utuTN+x4qw1Vv6dC2rlQY6RgXDmNtWD1rgvVPOG+C9536h7c6OGrA1rF0AXRqyojspgm6rquBbjU/+4/ItzzjLsQPuVcxpzDL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Xt5k73R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Xt5k73R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC81C4CEE5;
	Mon, 10 Mar 2025 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627260;
	bh=4/uvbyMZC6hyolwl7SieSSRDXBmb8gvJA66hKhGdjEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Xt5k73R/8TekNehAU41wVFJoViZW8CYXaJpcdNNNSJi4fpAAuWAqn9BVzaTnr5s5
	 HG1or3AH7Hea/PoL4a58O8DiLfgmvV+IU41MTORvlCfwFlwo0OtTjL8TNC6lKhOc5J
	 OR7ehpGqvbbig6NBF8MEelhUpkp9S/sU8JNvcZU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 068/269] rust: fix size_t in bindgen prototypes of C builtins
Date: Mon, 10 Mar 2025 18:03:41 +0100
Message-ID: <20250310170500.440207802@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

commit 75c1fd41a671a0843b89d1526411a837a7163fa2 upstream.

Without `-fno-builtin`, for functions like memcpy/memmove (and many
others), bindgen seems to be using the clang-provided prototype. This
prototype is ABI-wise compatible, but the issue is that it does not have
the same information as the source code w.r.t. typedefs.

For example, bindgen generates the following:

    extern "C" {
        pub fn strlen(s: *const core::ffi::c_char) -> core::ffi::c_ulong;
    }

note that the return type is `c_ulong` (i.e. unsigned long), despite the
size_t-is-usize behavior (this is default, and we have not opted out
from it using --no-size_t-is-usize).

Similarly, memchr's size argument should be of type `__kernel_size_t`,
but bindgen generates `c_ulong` directly.

We want to ensure any `size_t` is translated to Rust `usize` so that we
can avoid having them be different type on 32-bit and 64-bit
architectures, and hence would require a lot of excessive type casts
when calling FFI functions.

I found that this bindgen behavior (which probably is caused by
libclang) can be disabled by `-fno-builtin`. Using the flag for compiled
code can result in less optimisation because compiler cannot assume
about their properties anymore, but this should not affect bindgen.

[ Trevor asked: "I wonder how reliable this behavior is. Maybe bindgen
  could do a better job controlling this, is there an open issue?".

  Gary replied: ..."apparently this is indeed the suggested approach in
  https://github.com/rust-lang/rust-bindgen/issues/1770". - Miguel ]

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240913213041.395655-2-gary@garyguo.net
[ Formatted comment. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -264,7 +264,11 @@ else
 bindgen_c_flags_lto = $(bindgen_c_flags)
 endif
 
-bindgen_c_flags_final = $(bindgen_c_flags_lto) -D__BINDGEN__
+# `-fno-builtin` is passed to avoid `bindgen` from using `clang` builtin
+# prototypes for functions like `memcpy` -- if this flag is not passed,
+# `bindgen`-generated prototypes use `c_ulong` or `c_uint` depending on
+# architecture instead of generating `usize`.
+bindgen_c_flags_final = $(bindgen_c_flags_lto) -fno-builtin -D__BINDGEN__
 
 # Each `bindgen` release may upgrade the list of Rust target versions. By
 # default, the highest stable release in their list is used. Thus we need to set


