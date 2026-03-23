Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096E317A305;
	Mon, 23 Mar 2026 15:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278057; cv=none; b=q5jabpEYT2H/yr8jqglH+uFTYY0WEV7L+XWpR9P3THjGOLdSO2NZLSI1BuzIXe6I/GA2afpZy/vJYkR5wQXZdoMXItt6H4z7ddMOvTHXx64nc98hD6RcYq4fJzV1dUyKLhbz8shyx21MdHmRTRjb+gKoXQhAD9hsCh8WtG+m6N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278057; c=relaxed/simple;
	bh=YFWQUb3WTN5QHf14mK5fMJL6i/Rg42tvgiW3nM0WK+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMQCRc6yupPCWqR/p9toMX08Wq06VrKqK/PG1upbtQIMksp+xjM1ljDfy1wIMbLTwepVu8fK387p8ClVK8dDqIxg9A3WufQ/cY0Rojfumx6AjlbfvB6i2JyJTHOKS881fEuYHSVqh8nDJryIsq3TGol97CLowZLtGIyexjbQMQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkVFKhV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkVFKhV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48876C4CEF7;
	Mon, 23 Mar 2026 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278056;
	bh=YFWQUb3WTN5QHf14mK5fMJL6i/Rg42tvgiW3nM0WK+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkVFKhV70g0hyloS3vAWZTR4qxxxqrb5m6Y/kp6Nm1FrO/C49cnmGc4hBZpQ3LTtp
	 r9btykjDq+EAeXgIk0MFT23UL+NgUQAcHY6WEZZR5hBSs44TzYsYTXMYL1JGLnz4l9
	 SVKhL2Jq/HH2nyt9mzO9OteCEbwjjp27T32ar+zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/567] rust: kunit: fix warning when !CONFIG_PRINTK
Date: Mon, 23 Mar 2026 14:41:05 +0100
Message-ID: <20260323134537.415402856@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 722655b2d62df..f33d8f5f1851a 100644
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



