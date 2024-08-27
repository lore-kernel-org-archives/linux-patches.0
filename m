Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE791C8FDF;
	Tue, 27 Aug 2024 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772197; cv=none; b=IaY23wcf9hCuT3ttRJ+1JRCFNohQm1Mbt4NSgQ/kypdAO6ptEoJ4a7rI035UBfyNSLFV0uuzfPPirBkatRCimXEHeK50qxomSmo6ezZ9uNjpkXCSLrKubriuXS0VnyLxgtj6PUeKcxJ88PGpcCwxqJnQNLN0O4x/ODgRR1r/puk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772197; c=relaxed/simple;
	bh=Ja4GV8VvfaHb9Xf0YhFvimdf70iesISEqZocGR19k9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Af+PJAQ2tw2NJbcphTxQHhxuDTmQzOpKozTLXKDCMNHfQG27i+Eismb9ANDyuTeaR74k5nWZOrddR8DvX0GYJNKFXuK+wl7W9CBlMuTOysL+pHH8eXy/QMuWHJywNEjyRjT9Jca6ddQCTC4BPQwStDnu580iFmHifoqlU5CY5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6hsue+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6hsue+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAABDC6105D;
	Tue, 27 Aug 2024 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772197;
	bh=Ja4GV8VvfaHb9Xf0YhFvimdf70iesISEqZocGR19k9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6hsue+WWv+7GLYTyWq8aoip8zmbFxfpUzXmqR39gG5aO91Q7ZXrqb0k7Trofzqah
	 kcgnNAHOqSkReRm1zJ220aKxety3G/UfSEm52KqFLzf5f6iiQZZpou0m1WOAsaSs5J
	 XwPKJSxKWpNk963yk1VIwMbl/bD9fVv5YA3aSvqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/321] kbuild: rust_is_available: normalize version matching
Date: Tue, 27 Aug 2024 16:37:31 +0200
Message-ID: <20240827143843.682389537@linuxfoundation.org>
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

[ Upstream commit 7cd6a3e1f94bab4f2a3425e06f70ab13eb8190d4 ]

In order to match the version string, `sed` is used in a couple
cases, and `grep` and `head` in a couple others.

Make the script more consistent and easier to understand by
using the same method, `sed`, for all of them.

This makes the version matching also a bit more strict for
the changed cases, since the strings `rustc ` and `bindgen `
will now be required, which should be fine since `rustc`
complains if one attempts to call it with another program
name, and `bindgen` uses a hardcoded string.

In addition, clarify why one of the existing `sed` commands
does not provide an address like the others.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Link: https://lore.kernel.org/r/20230616001631.463536-9-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 5ce86c6c8613 ("rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/rust_is_available.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 7a925d2b20fc7..db4519945f534 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -40,8 +40,7 @@ fi
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
 rust_compiler_version=$( \
 	LC_ALL=C "$RUSTC" --version 2>/dev/null \
-		| head -n 1 \
-		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
+		| sed -nE '1s:.*rustc ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
 )
 rust_compiler_min_version=$($min_tool_version rustc)
 rust_compiler_cversion=$(get_canonical_version $rust_compiler_version)
@@ -67,8 +66,7 @@ fi
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
 rust_bindings_generator_version=$( \
 	LC_ALL=C "$BINDGEN" --version 2>/dev/null \
-		| head -n 1 \
-		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
+		| sed -nE '1s:.*bindgen ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
 )
 rust_bindings_generator_min_version=$($min_tool_version bindgen)
 rust_bindings_generator_cversion=$(get_canonical_version $rust_bindings_generator_version)
@@ -110,6 +108,9 @@ fi
 
 # `bindgen` returned successfully, thus use the output to check that the version
 # of the `libclang` found by the Rust bindings generator is suitable.
+#
+# Unlike other version checks, note that this one does not necessarily appear
+# in the first line of the output, thus no `sed` address is provided.
 bindgen_libclang_version=$( \
 	echo "$bindgen_libclang_output" \
 		| sed -nE 's:.*clang version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
-- 
2.43.0



