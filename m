Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF7837B413;
	Tue, 10 Mar 2026 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142157; cv=none; b=aG3RZTrKyAksUyHoXPS2BQa5n1Zu49P0Fg58EuLK5c+A68DFUIv22hr2n64D6gvOp+jCvky7CZVQuaKdsn9N4weJMwCphKKTHvrMAu6OHH4+VLSvNUYSAiRIzY9oDIK8ujlrXM8O6v2yyQODQ0VBcbJPm08gpW9/PATVq6Gp3sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142157; c=relaxed/simple;
	bh=Y8F56Ka1JYGadKYoCDo0MeLTl6GZsmGR1vANpS3OD+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3Q4EHzRHVHmQxf6Q9aSR728OPOoWHEPUCp/j0s+Wty4ZQIMG6TdzberP03lqtgtCFUEgjj4kTekzTd+WcoLUw1o8yVjN1qF9awSSYHVlOi3/01/nk9oHIxDjoAj0uvjYJX+X+JOTuW3UpeXpWgTpULlAlAT08TgqFf8v9lp5Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rPyXfSgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rPyXfSgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EF0C2BCAF;
	Tue, 10 Mar 2026 11:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142157;
	bh=Y8F56Ka1JYGadKYoCDo0MeLTl6GZsmGR1vANpS3OD+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPyXfSgPvE8spNDNe4RwqTk8JpUYHaHo82fO2p9gI91XgPdwMdXXQQ/cXP4UyLpbX
	 3fXXm6bHqHBIK8N7Y7vx2dCdkqK/S7ulIxNbXpRVpueR4flBjOYy7GQ3tPmab0MmVl
	 pL7J238LFwqaUPWQeIhExVMEqWRckep4OXWZuUkwMYQBBhjSa+KN0G2G4SNGWyrP+4
	 WA5t02oMoUEc4SOLJ82lZDA0WQF492vei9AOgdM44n5PV8j2cZyH5yWMpWRlPqGKMd
	 S7sKkJPoDvF+AX6bAqZZWdwAaZ4ngT9qhHWrsLRdLmKes+DpxBEov+DFQyzpLVJabS
	 PugeE47hm58HQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexandre Courbot <acourbot@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 245/314] rust: kunit: fix warning when !CONFIG_PRINTK
Date: Tue, 10 Mar 2026 07:18:24 -0400
Message-ID: <309f211085b3624bc4084d9bb6ec0de4fc3ef9c4.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

