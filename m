Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0864918026;
	Tue, 14 May 2024 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686445; cv=none; b=RK6gHJBFpkeTJOrHqOL9fQDkn6hRS+5lDfiKDk6Cu0U2gOpRJk1uVSAuQogssL499sfqoUa8pFlYsDiA67xI9PdiPIHegKf8uoLtps7eYWEY2LR7eydSezOTzOy2Og9495WI2BUYEK1Moa6wMR29nvXhdn2q9OYW4pDzqST+gRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686445; c=relaxed/simple;
	bh=8CLlqijSUbz3/blQNtvw9q6bR3ecbSjnaSjNhPutpps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI0cEWCNe3opL1klsyrqx/YwMJnr97NswPoQcx9IqaAgbS16ss4VcYIsZGo5oTkDMl0wsasLAAyVlfeqUrkIeyyXtTqDe4yWWAGvYmw5qKDJ0DrSNV58xWhU0og/fGHC4maGBLE1rfwMF+y9gTPX8gbNNk5zC/u+CGNobrmQW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fh+tH/ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fh+tH/ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832C2C2BD10;
	Tue, 14 May 2024 11:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686444;
	bh=8CLlqijSUbz3/blQNtvw9q6bR3ecbSjnaSjNhPutpps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fh+tH/olVkhUD42BIBANxGFD9xQs5gYXTKdorl8+iJKQ5TljIeZ4OyqP1+0PIcVlR
	 WQrPyfm7EOIX9IgCgm7wP9mVEc7ZV96gmuUoj19vaYYaEbHpSbRXM9J+SZXPi/7qBU
	 gwqVM2D3m8ewHhefpffJtwe3QBaQbG6xew/bQ3XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Nestler <raphael.nestler@gmail.com>,
	Andrea Righi <andrea.righi@canonical.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/236] kbuild: rust: avoid creating temporary files
Date: Tue, 14 May 2024 12:18:22 +0200
Message-ID: <20240514101025.683116475@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit df01b7cfcef08bf3fdcac2909d0e1910781d6bfd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 5 ++++-
 scripts/Makefile.host  | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9ae02542b9389..1827bc1db1e98 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -277,6 +277,9 @@ $(obj)/%.lst: $(src)/%.c FORCE
 
 rust_allowed_features := core_ffi_c
 
+# `--out-dir` is required to avoid temporaries being created by `rustc` in the
+# current working directory, which may be not accessible in the out-of-tree
+# modules case.
 rust_common_cmd = \
 	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \
 	-Zallow-features=$(rust_allowed_features) \
@@ -285,7 +288,7 @@ rust_common_cmd = \
 	--extern alloc --extern kernel \
 	--crate-type rlib -L $(objtree)/rust/ \
 	--crate-name $(basename $(notdir $@)) \
-	--emit=dep-info=$(depfile)
+	--out-dir $(dir $@) --emit=dep-info=$(depfile)
 
 rust_handle_depfile = \
 	sed -i '/^\#/d' $(depfile)
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index d812241144d44..a447c91893de6 100644
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
 
-- 
2.43.0



