Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FAB12D1EA;
	Tue, 30 Apr 2024 11:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475510; cv=none; b=n5hTi9dggbvrBnuQvk6te8XY/z+jeIj8nj7QVHxsutRCFepfOiujC07xxG33v5O0mXwPrFQ0HSA24RrYR4CW/xn6zy9Ycg99hpIFULmW7l2jh6qle5BNu4DMNPe1Kz6ejnIKttJYEhHsML7/iMhgzGVsTsw6ijQm26vysui7PNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475510; c=relaxed/simple;
	bh=Oqun/sJoVDl3iMS4GT082TTqhpMjchOClV3yvdbzgPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA7JozjuJvT+gXkOFW7iqTUdJ+kopWI5PXTOBDllY5SDnHs8hrTeW0ZEk0/o8AgWmJoIy4/vGHEAAALuFjm5RtwLFn46MF65ixmj+AtHC4n3+gVjXGfweCOP7LXitdmG8BGrWctoxbEQEp2b0bo0Ixre38q2deLMIkl2RdOv1BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ2I/JdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ2I/JdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357C4C2BBFC;
	Tue, 30 Apr 2024 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475509;
	bh=Oqun/sJoVDl3iMS4GT082TTqhpMjchOClV3yvdbzgPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZ2I/JdBTJVj51IkRZFn7Zs8zqhYb4MrLr8zBWl2IP6Z9D/WOcLOh3Bg+ma1mRCOu
	 0/Lj7t6L/EqKJYZqH5YknbJsJ+dtVZZgUC9hdWOIhZ2a22TuWVT0y+eivf5SZUuKyV
	 EMa4M+JR95LH8hy0fsEomA4NcwPS36TZXInVn3u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 115/186] kbuild: rust: remove unneeded `@rustc_cfg` to avoid ICE
Date: Tue, 30 Apr 2024 12:39:27 +0200
Message-ID: <20240430103101.371382867@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 50cfe93b01475ba36878b65d35d812e1bb48ac71 upstream.

When KUnit tests are enabled, under very big kernel configurations
(e.g. `allyesconfig`), we can trigger a `rustdoc` ICE [1]:

      RUSTDOC TK rust/kernel/lib.rs
    error: the compiler unexpectedly panicked. this is a bug.

The reason is that this build step has a duplicated `@rustc_cfg` argument,
which contains the kernel configuration, and thus a lot of arguments. The
factor 2 happens to be enough to reach the ICE.

Thus remove the unneeded `@rustc_cfg`. By doing so, we clean up the
command and workaround the ICE.

The ICE has been fixed in the upcoming Rust 1.79 [2].

Cc: stable@vger.kernel.org
Fixes: a66d733da801 ("rust: support running Rust documentation tests as KUnit ones")
Link: https://github.com/rust-lang/rust/issues/122722 [1]
Link: https://github.com/rust-lang/rust/pull/122840 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240422091215.526688-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    1 -
 1 file changed, 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -173,7 +173,6 @@ quiet_cmd_rustdoc_test_kernel = RUSTDOC
 	mkdir -p $(objtree)/$(obj)/test/doctests/kernel; \
 	OBJTREE=$(abspath $(objtree)) \
 	$(RUSTDOC) --test $(rust_flags) \
-		@$(objtree)/include/generated/rustc_cfg \
 		-L$(objtree)/$(obj) --extern alloc --extern kernel \
 		--extern build_error --extern macros \
 		--extern bindings --extern uapi \


