Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501E221703;
	Tue, 29 Apr 2025 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946556; cv=none; b=sVu5eiMS0zkA7EO0OY9aHAdE/NnXwXfMcG8mNIzAeL9vCmAzXv8FNj8fGTfjGUHWqWl7xoJNcaTt0FhiDutlpL84DM6kBHrodNMafNZ4dXr4uWZij/rqxjMdHTa0vUsHcaJRXS1NPTbfOJZbve0k7pu4BDUY2Xmas9HtgPxNu/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946556; c=relaxed/simple;
	bh=hum8NtKl05C/WHvlHP0NWG6s7pHvHd8gyyYjMdjY+BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7V11H1f2OW9uLxQgGf/NEqqHZbT+xlFHw7eqHvf1Gm/MBKP+p8t7/mbNHVuz7WEAWSgUhnq8DNN5sWL8fjVjjaQGB8bDJ58yepT5YIMir3NC9vwruAxV3u3DESL9/B/7LVEFAV9deHJGjRrnHy5LK17n/uIotdaQ3lypp1azJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft+jGuyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft+jGuyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C22C4CEE3;
	Tue, 29 Apr 2025 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946555;
	bh=hum8NtKl05C/WHvlHP0NWG6s7pHvHd8gyyYjMdjY+BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ft+jGuyy0c6K/SU0UwfvPEGwi4kcG0RaJoJbZpM2YqHeS/Q51lF5AQE9ZY6eejif4
	 dTZMHd97QR1r0tt/21DxuDzoKt7B+IZkk+E2R3N/fpfADuuC5BODPY8DcJZVrMv2px
	 39mz0Of2SThC4Cl8GRc3diBVsKPtcnU7II1NAo1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Tamir Duberstein <tamird@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.14 305/311] rust: kbuild: skip `--remap-path-prefix` for `rustdoc`
Date: Tue, 29 Apr 2025 18:42:22 +0200
Message-ID: <20250429161133.489577865@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 2c8725c1dca3de043670b38592b1b43105322496 upstream.

`rustdoc` only recognizes `--remap-path-prefix` starting with
Rust 1.81.0, which is later than on minimum, so we cannot pass it
unconditionally. Otherwise, we get:

    error: Unrecognized option: 'remap-path-prefix'

Note that `rustc` (the compiler) does recognize the flag since a long
time ago (1.26.0).

Moreover, `rustdoc` since Rust 1.82.0 ICEs in out-of-tree builds when
using `--remap-path-prefix`. The issue has been reduced and reported
upstream [1].

Thus workaround both issues by simply skipping the flag when generating
the docs -- it is not critical there anyway.

The ICE does not reproduce under `--test`, but we still need to skip
the flag as well for `RUSTDOC TK` since it is not recognized.

Fixes: dbdffaf50ff9 ("kbuild, rust: use -fremap-path-prefix to make paths relative")
Link: https://github.com/rust-lang/rust/issues/138520 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -57,10 +57,14 @@ endif
 core-cfgs = \
     --cfg no_fp_fmt_parse
 
+# `rustc` recognizes `--remap-path-prefix` since 1.26.0, but `rustdoc` only
+# since Rust 1.81.0. Moreover, `rustdoc` ICEs on out-of-tree builds since Rust
+# 1.82.0 (https://github.com/rust-lang/rust/issues/138520). Thus workaround both
+# issues skipping the flag. The former also applies to `RUSTDOC TK`.
 quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
       cmd_rustdoc = \
 	OBJTREE=$(abspath $(objtree)) \
-	$(RUSTDOC) $(filter-out $(skip_flags),$(if $(rustdoc_host),$(rust_common_flags),$(rust_flags))) \
+	$(RUSTDOC) $(filter-out $(skip_flags) --remap-path-prefix=%,$(if $(rustdoc_host),$(rust_common_flags),$(rust_flags))) \
 		$(rustc_target_flags) -L$(objtree)/$(obj) \
 		-Zunstable-options --generate-link-to-definition \
 		--output $(rustdoc_output) \
@@ -171,7 +175,7 @@ quiet_cmd_rustdoc_test_kernel = RUSTDOC
 	rm -rf $(objtree)/$(obj)/test/doctests/kernel; \
 	mkdir -p $(objtree)/$(obj)/test/doctests/kernel; \
 	OBJTREE=$(abspath $(objtree)) \
-	$(RUSTDOC) --test $(rust_flags) \
+	$(RUSTDOC) --test $(filter-out --remap-path-prefix=%,$(rust_flags)) \
 		-L$(objtree)/$(obj) --extern ffi --extern kernel \
 		--extern build_error --extern macros \
 		--extern bindings --extern uapi \


