Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E215AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5055AC433C7;
	Tue, 25 Jul 2023 10:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282695;
	bh=RTZJyYl0kZtVhirUa6qyZyNNRl63+lbtRe8XQTQXLNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkF+dIf5KudiH6fyygLLEbwsMLrLjVoaF0cXnO7E7Iy6iaJpDtVgb1EaaRHd2ZW7i
	 5s5LeOBdxHg1xIuV+sj5KxC0TVhjLzRFLdvTupNI8A8Cht7XZ3aYAW3psSpKllxi+J
	 AW6LrkjqBp83py0I32Lv+01X0UtzbMuqX8gQ72Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Nestler <raphael.nestler@gmail.com>,
	Andrea Righi <andrea.righi@canonical.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.4 220/227] kbuild: rust: avoid creating temporary files
Date: Tue, 25 Jul 2023 12:46:27 +0200
Message-ID: <20230725104523.822012845@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miguel Ojeda <ojeda@kernel.org>

commit df01b7cfcef08bf3fdcac2909d0e1910781d6bfd upstream.

`rustc` outputs by default the temporary files (i.e. the ones saved
by `-Csave-temps`, such as `*.rcgu*` files) in the current working
directory when `-o` and `--out-dir` are not given (even if
`--emit=x=path` is given, i.e. it does not use those for temporaries).

Since out-of-tree modules are compiled from the `linux` tree,
`rustc` then tries to create them there, which may not be accessible.

Thus pass `--out-dir` explicitly, even if it is just for the temporary
files.

Similarly, do so for Rust host programs too.

Reported-by: Raphael Nestler <raphael.nestler@gmail.com>
Closes: https://github.com/Rust-for-Linux/linux/issues/1015
Reported-by: Andrea Righi <andrea.righi@canonical.com>
Tested-by: Raphael Nestler <raphael.nestler@gmail.com> # non-hostprogs
Tested-by: Andrea Righi <andrea.righi@canonical.com> # non-hostprogs
Fixes: 295d8398c67e ("kbuild: specify output names separately for each emission type from rustc")
Cc: stable@vger.kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.build |    5 ++++-
 scripts/Makefile.host  |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -279,6 +279,9 @@ $(obj)/%.lst: $(src)/%.c FORCE
 
 rust_allowed_features := core_ffi_c,explicit_generic_args_with_impl_trait,new_uninit,pin_macro
 
+# `--out-dir` is required to avoid temporaries being created by `rustc` in the
+# current working directory, which may be not accessible in the out-of-tree
+# modules case.
 rust_common_cmd = \
 	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \
 	-Zallow-features=$(rust_allowed_features) \
@@ -287,7 +290,7 @@ rust_common_cmd = \
 	--extern alloc --extern kernel \
 	--crate-type rlib -L $(objtree)/rust/ \
 	--crate-name $(basename $(notdir $@)) \
-	--emit=dep-info=$(depfile)
+	--out-dir $(dir $@) --emit=dep-info=$(depfile)
 
 # `--emit=obj`, `--emit=asm` and `--emit=llvm-ir` imply a single codegen unit
 # will be used. We explicitly request `-Ccodegen-units=1` in any case, and
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -86,7 +86,11 @@ hostc_flags    = -Wp,-MMD,$(depfile) \
 hostcxx_flags  = -Wp,-MMD,$(depfile) \
                  $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
                  $(HOSTCXXFLAGS_$(target-stem).o)
-hostrust_flags = --emit=dep-info=$(depfile) \
+
+# `--out-dir` is required to avoid temporaries being created by `rustc` in the
+# current working directory, which may be not accessible in the out-of-tree
+# modules case.
+hostrust_flags = --out-dir $(dir $@) --emit=dep-info=$(depfile) \
                  $(KBUILD_HOSTRUSTFLAGS) $(HOST_EXTRARUSTFLAGS) \
                  $(HOSTRUSTFLAGS_$(target-stem))
 


