Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B412D1FC;
	Tue, 30 Apr 2024 10:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474407; cv=none; b=cw8QGINjk3PeuVJtawbjkDkziF+S/8rZpERl84+rn5/TXi44m4yVVjUEOgP4Qhk2IVDB6xZvByJ6RB3GHqAahv9EMKcXc9rMkIQJjcHMhT+MGVHnO6lV0r3hvawYoq+yWGv4FDz8ueMTfi5euzxA0GY1w+9lnG9/4PHyFU5pBjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474407; c=relaxed/simple;
	bh=W5mszfd6r4e7nsIylhZneDltH0/ubFhYU1+7SkNStuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSPdiuJVAVy6fV3ktDdRkFWin5JcdQXIwDyDqxSgpn+WNEp9+K1G0SiFDO69riDBlFUJjrHRMojdbYCH96BWv0k4QGDoDKNyRy8XY0XP3HoMkYIOa0K2HKHtnafq8YmYEllKNDBWA6gWNJKL23446ei+cscwHv96+ohS4qKXQ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pvfXcyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pvfXcyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4073DC2BBFC;
	Tue, 30 Apr 2024 10:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474406;
	bh=W5mszfd6r4e7nsIylhZneDltH0/ubFhYU1+7SkNStuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pvfXcyNUncrq8J8eGyOaYYLuNRsN62SsQAlOLf0pwhXtvIluTQsoCNm9LG3MT+3N
	 fQL7wrZC2oGLCrDK2dPzKGudCXA8iTYnYgZd6oPALmUzW+86K2bozAYvq3KjeFGEa5
	 sBAfLj4oXmH30koi4YvZVMoIt8aFLtQvIrnNwHZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.8 140/228] kbuild: rust: force `alloc` extern to allow "empty" Rust files
Date: Tue, 30 Apr 2024 12:38:38 +0200
Message-ID: <20240430103107.840339234@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit ded103c7eb23753f22597afa500a7c1ad34116ba upstream.

If one attempts to build an essentially empty file somewhere in the
kernel tree, it leads to a build error because the compiler does not
recognize the `new_uninit` unstable feature:

    error[E0635]: unknown feature `new_uninit`
     --> <crate attribute>:1:9
      |
    1 | feature(new_uninit)
      |         ^^^^^^^^^^

The reason is that we pass `-Zcrate-attr='feature(new_uninit)'` (together
with `-Zallow-features=new_uninit`) to let non-`rust/` code use that
unstable feature.

However, the compiler only recognizes the feature if the `alloc` crate
is resolved (the feature is an `alloc` one). `--extern alloc`, which we
pass, is not enough to resolve the crate.

Introducing a reference like `use alloc;` or `extern crate alloc;`
solves the issue, thus this is not seen in normal files. For instance,
`use`ing the `kernel` prelude introduces such a reference, since `alloc`
is used inside.

While normal use of the build system is not impacted by this, it can still
be fairly confusing for kernel developers [1], thus use the unstable
`force` option of `--extern` [2] (added in Rust 1.71 [3]) to force the
compiler to resolve `alloc`.

This new unstable feature is only needed meanwhile we use the other
unstable feature, since then we will not need `-Zcrate-attr`.

Cc: stable@vger.kernel.org # v6.6+
Reported-by: Daniel Almeida <daniel.almeida@collabora.com>
Reported-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-General/topic/x/near/424096982 [1]
Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Link: https://github.com/rust-lang/rust/issues/111302 [2]
Link: https://github.com/rust-lang/rust/pull/109421 [3]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240422090644.525520-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.build |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -272,7 +272,7 @@ rust_common_cmd = \
 	-Zallow-features=$(rust_allowed_features) \
 	-Zcrate-attr=no_std \
 	-Zcrate-attr='feature($(rust_allowed_features))' \
-	--extern alloc --extern kernel \
+	-Zunstable-options --extern force:alloc --extern kernel \
 	--crate-type rlib -L $(objtree)/rust/ \
 	--crate-name $(basename $(notdir $@)) \
 	--sysroot=/dev/null \


