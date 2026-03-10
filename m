Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E222635AC23;
	Tue, 10 Mar 2026 11:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141226; cv=none; b=YkLYAqCg0lTIwDNVLdY++i/spsLzEXMrz07W0CtPPHgBXSMUaNwCEoE6v0IyPTPRnXrDy9BWUm5tzKCP2/OuyiM1wduSxzvvsy3juQqWz7WsPO5tSOTfqMCHySOC+jsfsVxJm+xFXjqU+VVS/LLUrilo2kTnogUJve3gQHffTu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141226; c=relaxed/simple;
	bh=Y8F56Ka1JYGadKYoCDo0MeLTl6GZsmGR1vANpS3OD+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1+IoTn6q4FHoiPR0gUkOIvovjfIDXU3zIF6yxxZ330GAML0yyMu5ZoAu7pwPUI3UHDhbG1UY8UeMJXooHD4WL/fENsU5rFwQ3OdbwE5JqMhPjttsdyv5xEwDuMITOZmZH2rx1VcHhghbF9F35hYooMH+FbWjHH1ByizKJfIUcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/AReN8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/AReN8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C17C2BCAF;
	Tue, 10 Mar 2026 11:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141225;
	bh=Y8F56Ka1JYGadKYoCDo0MeLTl6GZsmGR1vANpS3OD+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/AReN8RIBSQDT0gZeqnJeGMVSeJoL+6e0I5MuVhY4FKp9zsRcBx3mJyzklz+g8E8
	 xzr/Otb8TiHwnIszw7RCGrSt/ILxtD0D/sqPIqUxJs340lqWMKrluaR+8SeKVq25Ev
	 +ac3VYntkQveVP2RzkGcfAbsjIF6VUQa9fKGnVJwCIVcaXKiSySOY7GhlYJKSj1ebc
	 d4Za+qQ7Ap29A3ndWfX6bDPr6WncJJKecKjswFo1FrCvjCwfbdKz2xRDBKLpL/kBP+
	 odtRkw7p94hN3XfwDArcOTAwRk+QpE7QPHaTgJ6Hdkn1YTo9HVXJ6USf4jq1gWcnV5
	 mt70D3cD7V9HQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexandre Courbot <acourbot@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 227/311] rust: kunit: fix warning when !CONFIG_PRINTK
Date: Tue, 10 Mar 2026 07:04:34 -0400
Message-ID: <d96cabc5abc93f828275ecda9ae4e330dcbab062.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 79436509dd73d..8907b6f89ece5 100644
--- a/rust/kernel/kunit.rs
+++ b/rust/kernel/kunit.rs
@@ -17,6 +17,10 @@
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
@@ -33,6 +37,10 @@ pub fn err(args: fmt::Arguments<'_>) {
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

