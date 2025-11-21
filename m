Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705C43F9D2;
	Fri, 21 Nov 2025 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732051; cv=none; b=J52IL3NCD5Z7I/7/yaQRBnPjtX3iaj7z6iC53ufb/a8MV4RobwTYBFMArfMfJuWGkQUqoAJjr7V9anH0zE53hx1CvTDSY2GS/Qr9l2SHPnQDg4hhi7cGv62VfSmr+spDr9jdMAqQDxBg7jnHzTe00TETMiw2Nc9Q3YlJjvyl5Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732051; c=relaxed/simple;
	bh=7yGlqQPkJk5eZZnUa8nT1STlQMVmBajZj7JCZewua0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckU5HgJNBNZoDKNyCJmEWNyyfxNjhxrkdIngxGk89PFPCq/2fni0/9xLtROqO04TSLLyE1LyXbrNx2T+dCdv9mG1XKT9xE55lTaflUMCvFRid0B36GyQxj4DgNOxJrwxWRTQQCJeOhInmF+TdUMA4z9RpHcz7EqEowq3UUc8Wfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff20ExAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff20ExAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18A0C4CEFB;
	Fri, 21 Nov 2025 13:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732051;
	bh=7yGlqQPkJk5eZZnUa8nT1STlQMVmBajZj7JCZewua0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ff20ExAmdPYJhIlFido2QGY5cZK9jYqHYvIFPiMw4+ogYmXPWB6VYijVzUrjMYqNa
	 dGfKVN+/3Bt+eX4xwg+wisVs4Vy+mX9PMCYhlrGCbitIuTUGBaA4eUoLEIr3NiN5bp
	 FfJjDICmJ9xN475xtLDiWEnvJfvBFqS1p589s5g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/185] rust: kbuild: treat `build_error` and `rustdoc` as kernel objects
Date: Fri, 21 Nov 2025 14:13:20 +0100
Message-ID: <20251121130150.130827779@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 16c43a56b79e2c3220b043236369a129d508c65a ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -107,12 +107,18 @@ rustdoc-core: private rustc_target_flags
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
 
+rustdoc-kernel: private is-kernel-object := y
 rustdoc-kernel: private rustc_target_flags = --extern ffi \
     --extern build_error --extern macros=$(objtree)/$(obj)/libmacros.so \
     --extern bindings --extern uapi
@@ -433,6 +439,10 @@ $(obj)/compiler_builtins.o: private rust
 $(obj)/compiler_builtins.o: $(src)/compiler_builtins.rs $(obj)/core.o FORCE
 	+$(call if_changed_rule,rustc_library)
 
+# Even if normally `build_error` is not a kernel object, it should still be
+# treated as such so that we pass the same flags. Otherwise, for instance,
+# `rustc` will complain about missing sanitizer flags causing an ABI mismatch.
+$(obj)/build_error.o: private is-kernel-object := y
 $(obj)/build_error.o: $(src)/build_error.rs $(obj)/compiler_builtins.o FORCE
 	+$(call if_changed_rule,rustc_library)
 


