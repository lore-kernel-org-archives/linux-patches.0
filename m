Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6051E285048;
	Tue, 17 Jun 2025 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178561; cv=none; b=BsvSlpgN06kwTJwncBN/VK08lm/uay+HcO9EBlcO1qHAFCsvB+pGybEqa3AC4aQT5bxWlxjrlx4h46jXPda4rHLCAyRCQ2LTNiNGajoYRJ4iUkCfVFNlSGtHdSNrLCn62w1D/rdUwi8o5G7W2GERYI7b1SuKBaEcZrCNcgLKIU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178561; c=relaxed/simple;
	bh=FUldUU2rSJIj2WtTj4dT0ERCpIRqvKa0GLSC9x0dvOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWYhxQRFHca0AWJVQKhtO6MEBopUy6WF1yckxZQmKy/Y7wVo1g4rVRDVucD2kKpsIhi+eVCvOiGO3KwdGRF+UnFIi6GN1s7rfEPqSPCLlrp8hL+C8VhQjVaKT0t7ERbY0zKNVpBXh2ukaYXh29yIgXdSrP5IXXWE4jQmaGuPOhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=An8xtmiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="An8xtmiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F31C4CEE3;
	Tue, 17 Jun 2025 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178561;
	bh=FUldUU2rSJIj2WtTj4dT0ERCpIRqvKa0GLSC9x0dvOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=An8xtmiDz7TJyQHFlCzVn9fxtfeFFREAxhW8yrI6rG3YQTfwA8j65yAUjnYBcmFcM
	 FdbTMmCI/ej4ESdsGyKGix/vgKZpSgVlmUG8Q4SJRTX+mNkYaLk/t20kFxb9Dei2so
	 X4JK3WGTryrMywNXQrrAtCazJI928CI8OIFH1dmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pekka Ristola <pekkarr@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 485/780] rust: file: mark `LocalFile` as `repr(transparent)`
Date: Tue, 17 Jun 2025 17:23:13 +0200
Message-ID: <20250617152511.240571547@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekka Ristola <pekkarr@protonmail.com>

[ Upstream commit 15ecd83dc06277385ad71dc7ea26911d9a79acaf ]

Unsafe code in `LocalFile`'s methods assumes that the type has the same
layout as the inner `bindings::file`. This is not guaranteed by the default
struct representation in Rust, but requires specifying the `transparent`
representation.

The `File` struct (which also wraps `bindings::file`) is already marked as
`repr(transparent)`, so this change makes their layouts equivalent.

Fixes: 851849824bb5 ("rust: file: add Rust abstraction for `struct file`")
Closes: https://github.com/Rust-for-Linux/linux/issues/1165
Signed-off-by: Pekka Ristola <pekkarr@protonmail.com>
Link: https://lore.kernel.org/20250527204636.12573-1-pekkarr@protonmail.com
Reviewed-by: Benno Lossin <lossin@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/fs/file.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/fs/file.rs b/rust/kernel/fs/file.rs
index 13a0e44cd1aa8..138693bdeb3fd 100644
--- a/rust/kernel/fs/file.rs
+++ b/rust/kernel/fs/file.rs
@@ -219,6 +219,7 @@ unsafe impl AlwaysRefCounted for File {
 ///   must be on the same thread as this file.
 ///
 /// [`assume_no_fdget_pos`]: LocalFile::assume_no_fdget_pos
+#[repr(transparent)]
 pub struct LocalFile {
     inner: Opaque<bindings::file>,
 }
-- 
2.39.5



