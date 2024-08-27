Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1FF1C57BF;
	Tue, 27 Aug 2024 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772201; cv=none; b=LuXxiuYN8PoomPZF0m0/+IsXOw4BG9xVR0zImUl5sPWvW66RKpp1JMYlKLbHPiCiOg3fzgiVUxQETGo6BQo+VVzkl4SYbiQ4EcSuafXF9b/fetfLFC861tHaLPKtqodtSxANLlpefmdB751BwIdI7frY+Tam5FTbaOqIeh5EHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772201; c=relaxed/simple;
	bh=nYxZ4zvw5B4ZhcOnFKLIlivTV2g8hFt/kS6iOtoVMmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfM1ixOl53fS8CFwASZ5TfE/qvWzArTa6racOFhM2P/j6Fa0qcqlOlC3qcUAAxj9xvnzbfltWydI49EuDl4dUnHYsB7WNN05ITgqNPHOijuer8H7Q+wrzWPSgiz+UFC9ESFc4Kxjq6JqQ/UpN3bz/JX6EZh9OheuvvVEsl/YPqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/HhyqNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/HhyqNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218BAC6105E;
	Tue, 27 Aug 2024 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772200;
	bh=nYxZ4zvw5B4ZhcOnFKLIlivTV2g8hFt/kS6iOtoVMmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/HhyqNO4kGTMNQgR3agxFfnzcfBtGUIghWH9qnYQOVw8vFcsTbtzgD7dRP2PtEtQ
	 Xi1vrHS7cDS6NjMrnU6EOmSr5sMlUGIN9zEGMltIV8M515rNkoEdJXL4ZDkc5cPKxK
	 6mN7g9ajAcc9pjwJSgVeD2vnYnCjSy3sEUokuZzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/321] kbuild: rust_is_available: handle failures calling `$RUSTC`/`$BINDGEN`
Date: Tue, 27 Aug 2024 16:37:32 +0200
Message-ID: <20240827143843.719414862@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit f295522886a4ebb628cadb2cd74d0661d6292978 ]

The script already checks if `$RUSTC` and `$BINDGEN` exists via
`command`, but the environment variables may point to a
non-executable file, or the programs may fail for some other reason.
While the script successfully exits with a failure as it should,
the error given can be quite confusing depending on the shell and
the behavior of its `command`. For instance, with `dash`:

    $ RUSTC=./mm BINDGEN=bindgen CC=clang scripts/rust_is_available.sh
    scripts/rust_is_available.sh: 19: arithmetic expression: expecting primary: "100000 *  + 100 *  + "

Thus detect failure exit codes when calling `$RUSTC` and `$BINDGEN` and
print a better message, in a similar way to what we do when extracting
the `libclang` version found by `bindgen`.

Link: https://lore.kernel.org/rust-for-linux/CAK7LNAQYk6s11MASRHW6oxtkqF00EJVqhHOP=5rynWt-QDUsXw@mail.gmail.com/
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Link: https://lore.kernel.org/r/20230616001631.463536-10-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 5ce86c6c8613 ("rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/rust_is_available.sh | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index db4519945f534..1c9081d9dbea7 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -38,8 +38,20 @@ fi
 # Check that the Rust compiler version is suitable.
 #
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
+rust_compiler_output=$( \
+	LC_ALL=C "$RUSTC" --version 2>/dev/null
+) || rust_compiler_code=$?
+if [ -n "$rust_compiler_code" ]; then
+	echo >&2 "***"
+	echo >&2 "*** Running '$RUSTC' to check the Rust compiler version failed with"
+	echo >&2 "*** code $rust_compiler_code. See output and docs below for details:"
+	echo >&2 "***"
+	echo >&2 "$rust_compiler_output"
+	echo >&2 "***"
+	exit 1
+fi
 rust_compiler_version=$( \
-	LC_ALL=C "$RUSTC" --version 2>/dev/null \
+	echo "$rust_compiler_output" \
 		| sed -nE '1s:.*rustc ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
 )
 rust_compiler_min_version=$($min_tool_version rustc)
@@ -64,8 +76,20 @@ fi
 # Check that the Rust bindings generator is suitable.
 #
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
+rust_bindings_generator_output=$( \
+	LC_ALL=C "$BINDGEN" --version 2>/dev/null
+) || rust_bindings_generator_code=$?
+if [ -n "$rust_bindings_generator_code" ]; then
+	echo >&2 "***"
+	echo >&2 "*** Running '$BINDGEN' to check the Rust bindings generator version failed with"
+	echo >&2 "*** code $rust_bindings_generator_code. See output and docs below for details:"
+	echo >&2 "***"
+	echo >&2 "$rust_bindings_generator_output"
+	echo >&2 "***"
+	exit 1
+fi
 rust_bindings_generator_version=$( \
-	LC_ALL=C "$BINDGEN" --version 2>/dev/null \
+	echo "$rust_bindings_generator_output" \
 		| sed -nE '1s:.*bindgen ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
 )
 rust_bindings_generator_min_version=$($min_tool_version bindgen)
-- 
2.43.0



