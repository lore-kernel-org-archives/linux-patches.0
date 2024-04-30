Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D618312C476;
	Tue, 30 Apr 2024 10:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474535; cv=none; b=C9kOZO3Zcx25mv4ra8RH+8RxZg83gUdBB68lwnBHqxUyJQ4Qscs8Gd0tBj0viFHeAyVV0aGkihvy53PXAJgXEQZcD//JJCBGPJG8x/X1QsG/h3h0hcvm7cyUdnEJRa4jxjxwHkpeuH7+guYUv3mioj7OvXw25KqgQSKk12waPEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474535; c=relaxed/simple;
	bh=9XNgg5wwkW19YbfRGKtFpxZo8Qt9xkRoEvWYzxwvQck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9cfIoIgR6TupIbnKpUBWqiW0b6Vp+Bmuwnjekr6u0fzvYmgCwcE3+zqhnigzGdnry4/OnzrcIXb/U0Hg8iOD5791aY+nEPoyntXnlbWBKf/JJkxUN5RdjK474kSieORYBlDPfMdWtt8pbSMi65nvmT8AT7Io59IAnQbzv9kS7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjVGwM17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjVGwM17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF8EC4AF18;
	Tue, 30 Apr 2024 10:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474535;
	bh=9XNgg5wwkW19YbfRGKtFpxZo8Qt9xkRoEvWYzxwvQck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjVGwM17jDf1oj86ZFfAt+KtbGgvbWmh/JpT8B852SSL1OCbsjH5p8CQcTPzIys4l
	 Ckk61JdxWPQtKzvaGOyABVuRe+TTTHeIcAnzKAY52CfbiSkMvTnCcAVxVkC0gnSXvB
	 5czVyTW6EJSMBdRPQRuPE4wNfDQuu4KWAlZrUwA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.8 139/228] kbuild: rust: remove unneeded `@rustc_cfg` to avoid ICE
Date: Tue, 30 Apr 2024 12:38:37 +0200
Message-ID: <20240430103107.811616753@linuxfoundation.org>
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
@@ -175,7 +175,6 @@ quiet_cmd_rustdoc_test_kernel = RUSTDOC
 	mkdir -p $(objtree)/$(obj)/test/doctests/kernel; \
 	OBJTREE=$(abspath $(objtree)) \
 	$(RUSTDOC) --test $(rust_flags) \
-		@$(objtree)/include/generated/rustc_cfg \
 		-L$(objtree)/$(obj) --extern alloc --extern kernel \
 		--extern build_error --extern macros \
 		--extern bindings --extern uapi \


