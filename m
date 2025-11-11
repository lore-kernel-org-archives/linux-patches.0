Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64187311C20;
	Tue, 11 Nov 2025 01:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825295; cv=none; b=OyhqxPfNlgdT74FDqKb8wJ++2HzUbaSNQpUgj5JRHa6Q/sXBMWSZZ+Eirt8BcfmTTs+AJABv2FDkRPVe+KiEbQFnL8WqaV68GPEP9e1240uoPyUg2ruOi1N3WEUl/Ixy1XxyRDr4KOL4q1eHVgAgAjapvyQ0pLLm3fiNRCEEVKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825295; c=relaxed/simple;
	bh=8kgdMshhzm3kI1ZdimcOwfZ0q7ZqfTofvh1UP9kj4SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=re6NgYikQWzYQ/t2G1Glob6Q4ZDX8Xam9jGqa4YU5BSIl+IKYDjsOMDCcoKCSf8HwvvWM0C3IrwvXnVCJKkQdyTBJ9SuZZU1C3REhMYi92w5v/otWgWl0yjSQlM9B7n6oJPFQimbGvZs6g/aXJPSNxoYprpSO1CuQtpng6LTV2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cd9ocUs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cd9ocUs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047FEC4CEFB;
	Tue, 11 Nov 2025 01:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825295;
	bh=8kgdMshhzm3kI1ZdimcOwfZ0q7ZqfTofvh1UP9kj4SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cd9ocUs1pIwbx6QK58HFkDNdTkS8khDne0BVF19oLXQL4Esj9LheVOYt7AAdqMp7v
	 FszEqvyJAv7cSfkIbeQ53GJh1Kw2vnnbiU7YxZwZKUQhM6DXV4KaGu0x5It5Mvp6FG
	 f7p6ALIMTXJUfRUsgv7OudlhoN115hCOsuPBeHnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.17 741/849] rust: kbuild: treat `build_error` and `rustdoc` as kernel objects
Date: Tue, 11 Nov 2025 09:45:11 +0900
Message-ID: <20251111004554.354283156@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 16c43a56b79e2c3220b043236369a129d508c65a upstream.

Even if normally `build_error` isn't a kernel object, it should still
be treated as such so that we pass the same flags. Similarly, `rustdoc`
targets are never kernel objects, but we need to treat them as such.

Otherwise, starting with Rust 1.91.0 (released 2025-10-30), `rustc`
will complain about missing sanitizer flags since `-Zsanitizer` is a
target modifier too [1]:

    error: mixing `-Zsanitizer` will cause an ABI mismatch in crate `build_error`
     --> rust/build_error.rs:3:1
      |
    3 | //! Build-time error.
      | ^
      |
      = help: the `-Zsanitizer` flag modifies the ABI so Rust crates compiled with different values of this flag cannot be used together safely
      = note: unset `-Zsanitizer` in this crate is incompatible with `-Zsanitizer=kernel-address` in dependency `core`
      = help: set `-Zsanitizer=kernel-address` in this crate or unset `-Zsanitizer` in `core`
      = help: if you are sure this will not cause problems, you may use `-Cunsafe-allow-abi-mismatch=sanitizer` to silence this error

Thus explicitly mark them as kernel objects.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/138736 [1]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
Link: https://patch.msgid.link/20251102212853.1505384-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -124,9 +124,14 @@ rustdoc-core: private rustc_target_flags
 rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs rustdoc-clean FORCE
 	+$(call if_changed,rustdoc)
 
+# Even if `rustdoc` targets are not kernel objects, they should still be
+# treated as such so that we pass the same flags. Otherwise, for instance,
+# `rustdoc` will complain about missing sanitizer flags causing an ABI mismatch.
+rustdoc-compiler_builtins: private is-kernel-object := y
 rustdoc-compiler_builtins: $(src)/compiler_builtins.rs rustdoc-core FORCE
 	+$(call if_changed,rustdoc)
 
+rustdoc-ffi: private is-kernel-object := y
 rustdoc-ffi: $(src)/ffi.rs rustdoc-core FORCE
 	+$(call if_changed,rustdoc)
 
@@ -144,6 +149,7 @@ rustdoc-pin_init: $(src)/pin-init/src/li
     rustdoc-macros FORCE
 	+$(call if_changed,rustdoc)
 
+rustdoc-kernel: private is-kernel-object := y
 rustdoc-kernel: private rustc_target_flags = --extern ffi --extern pin_init \
     --extern build_error --extern macros \
     --extern bindings --extern uapi
@@ -526,6 +532,10 @@ $(obj)/pin_init.o: $(src)/pin-init/src/l
     $(obj)/$(libpin_init_internal_name) $(obj)/$(libmacros_name) FORCE
 	+$(call if_changed_rule,rustc_library)
 
+# Even if normally `build_error` is not a kernel object, it should still be
+# treated as such so that we pass the same flags. Otherwise, for instance,
+# `rustc` will complain about missing sanitizer flags causing an ABI mismatch.
+$(obj)/build_error.o: private is-kernel-object := y
 $(obj)/build_error.o: private skip_gendwarfksyms = 1
 $(obj)/build_error.o: $(src)/build_error.rs $(obj)/compiler_builtins.o FORCE
 	+$(call if_changed_rule,rustc_library)


