Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15EE2D7D42;
	Wed,  4 Feb 2026 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219191; cv=none; b=knYhSsSlebFoXlq/cDvzRZ97pMXdACdAMMmbx5jyQM7vvhljjbHATP2T3pdZhQU6GJL2qRDmvl5sjC2lg4AInGBPELVWkaEiBaNhtPQq2DSzEd8RxI5cBtp0wWRZZsW7+NM+vjM+Vsbpi/WoxY/FKXOflc/jxv8UAFEP+6drnrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219191; c=relaxed/simple;
	bh=+ruDzITtxit0fUQ2b9d8LzQV2uyWdoAHpGHLArTEF3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhQZXh7WsZzoVBRTjgfBo4/324Zica8nZ9ffFvozAz9pOLCz7foL+cvxBw/uCb3+GeJbwzt0O4IASE/nvguFbwKvrwWbAJ1Hk5b7NIqY/9IzCQOviWoYmqk6I5y2tIlItqrrnltufl6Rmd5TYgHhn7E4FqQTqQAdLG3mI8CgzBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onJlzLUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onJlzLUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D747C4CEF7;
	Wed,  4 Feb 2026 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219191;
	bh=+ruDzITtxit0fUQ2b9d8LzQV2uyWdoAHpGHLArTEF3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onJlzLUW87YQ65BeXw90cWO0WhEGaM09y1ul97kRVTojeSAV2rAqJAJv83TM7lMR6
	 zDBa5XNQhWRQwXQvVYhnSCDSmRM1i9dYQdfDbF6O32wzPo19s29IP2lqysCaPWTT1L
	 iI6HqAVwZ83yDXA4QOpV/r6cK68Zkq84sueKmWu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 093/122] rust: sync: refcount: always inline functions using build_assert with arguments
Date: Wed,  4 Feb 2026 15:41:15 +0100
Message-ID: <20260204143855.197498969@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Courbot <acourbot@nvidia.com>

commit d6ff6e870077ae0f01a6f860ca1e4a5a825dc032 upstream.

`build_assert` relies on the compiler to optimize out its error path.
Functions using it with its arguments must thus always be inlined,
otherwise the error path of `build_assert` might not be optimized out,
triggering a build error.

Cc: stable@vger.kernel.org
Fixes: bb38f35b35f9 ("rust: implement `kernel::sync::Refcount`")
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://patch.msgid.link/20251208-io-build-assert-v3-5-98aded02c1ea@nvidia.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync/refcount.rs | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/sync/refcount.rs b/rust/kernel/sync/refcount.rs
index 19236a5bccde..6c7ae8b05a0b 100644
--- a/rust/kernel/sync/refcount.rs
+++ b/rust/kernel/sync/refcount.rs
@@ -23,7 +23,8 @@ impl Refcount {
     /// Construct a new [`Refcount`] from an initial value.
     ///
     /// The initial value should be non-saturated.
-    #[inline]
+    // Always inline to optimize out error path of `build_assert`.
+    #[inline(always)]
     pub fn new(value: i32) -> Self {
         build_assert!(value >= 0, "initial value saturated");
         // SAFETY: There are no safety requirements for this FFI call.
-- 
2.53.0



