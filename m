Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97B32D2491;
	Thu, 12 Mar 2026 20:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347078; cv=none; b=R+ssaS1TrB66GuR75amI8WeJSCz97GglwW/e54UHwvM3XYxGeTs+J8TAaEhL6/tlTYh1RR8W3PPHzscBgXxkl8BYX+JVLcP8QII88PpHc6zPLfbeBNfYJbrNBBrW4NubnS4Jsb9ZDzUV5nnt9CxwLSKgkkole1qPgm7qw5TMo7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347078; c=relaxed/simple;
	bh=vYrCAsyxW3JSCQXLV/52jlQDlfHnbSznHzuCStxGh2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN+FQ9lWfZgybVu3ggeM8GXQoGalS32fkPw46rngQ/wA+sMPdDZ7qmwXo106i4gpcZ65pgOqAwfU/U5JqAqrFs95DNFw4FcDD5Ye6M1uUno9VoMZguT5OlZ4SoXtqHwhnr1t43aNtXl176I2SWHp2Wd1ySPIA6xJlOaRrnlIkNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8VjidZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8VjidZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30908C2BC86;
	Thu, 12 Mar 2026 20:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347078;
	bh=vYrCAsyxW3JSCQXLV/52jlQDlfHnbSznHzuCStxGh2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8VjidZ8JeUQ1hYDabH+e+XS33mC2vQQlS4xXyUCMYs+lHTkxGYIIUGrMWgctcJkC
	 03Zrbtgu59G/tWKkoEiCeYQncp00+a5uJV0eKXZEOCdubJOfvd1SBhSX8UxrBJ5x6v
	 YbOKHUqpgyJUT3Uzqr9wqKwQ1NvwSqqJpZsgqnSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/265] rust: kunit: fix warning when !CONFIG_PRINTK
Date: Thu, 12 Mar 2026 21:09:44 +0100
Message-ID: <20260312201025.433737450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit 7dd34dfc8dfa92a7244242098110388367996ac3 ]

If `CONFIG_PRINTK` is not set, then the following warnings are issued
during build:

  warning: unused variable: `args`
    --> ../rust/kernel/kunit.rs:16:12
    |
  16 | pub fn err(args: fmt::Arguments<'_>) {
    |            ^^^^ help: if this is intentional, prefix it with an underscore: `_args`
    |
    = note: `#[warn(unused_variables)]` (part of `#[warn(unused)]`) on by default

  warning: unused variable: `args`
    --> ../rust/kernel/kunit.rs:32:13
    |
  32 | pub fn info(args: fmt::Arguments<'_>) {
    |             ^^^^ help: if this is intentional, prefix it with an underscore: `_args`

Fix this by adding a no-op assignment using `args` when `CONFIG_PRINTK`
is not set.

Fixes: a66d733da801 ("rust: support running Rust documentation tests as KUnit ones")
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/kunit.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
index 824da0e9738a0..7b38fca9f2429 100644
--- a/rust/kernel/kunit.rs
+++ b/rust/kernel/kunit.rs
@@ -13,6 +13,10 @@
 /// Public but hidden since it should only be used from KUnit generated code.
 #[doc(hidden)]
 pub fn err(args: fmt::Arguments<'_>) {
+    // `args` is unused if `CONFIG_PRINTK` is not set - this avoids a build-time warning.
+    #[cfg(not(CONFIG_PRINTK))]
+    let _ = args;
+
     // SAFETY: The format string is null-terminated and the `%pA` specifier matches the argument we
     // are passing.
     #[cfg(CONFIG_PRINTK)]
@@ -29,6 +33,10 @@ pub fn err(args: fmt::Arguments<'_>) {
 /// Public but hidden since it should only be used from KUnit generated code.
 #[doc(hidden)]
 pub fn info(args: fmt::Arguments<'_>) {
+    // `args` is unused if `CONFIG_PRINTK` is not set - this avoids a build-time warning.
+    #[cfg(not(CONFIG_PRINTK))]
+    let _ = args;
+
     // SAFETY: The format string is null-terminated and the `%pA` specifier matches the argument we
     // are passing.
     #[cfg(CONFIG_PRINTK)]
-- 
2.51.0



