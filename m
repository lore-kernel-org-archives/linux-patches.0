Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A8B31F99C;
	Tue, 21 Jul 2026 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648867; cv=none; b=NOIkiqNpUSxHIB0UtoH02K5umCQr98bP2wzQr+ZZ6zKrJ5MsxvfdgeedGVMlw8RHtgos0TvpK6ONn42XE1n7cGGAuZUiLRdkHyDsuTb+/+VP4WmTuQVn/OsmlXw/swoHOEtqr8ljJk5OhLRqWc8eXWUM18ml8wuTFN9Ag5uJWns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648867; c=relaxed/simple;
	bh=jLYBpzH8lUGSGubNH52FT8LjBYTfqSKORsj6VdKG+/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqACdnHfTBXr2V8Hq2FIdm3A8cQl7kFRsY9TA3AOP6Y5T9/Q9UGCE/3u1bKsvtvDBlHdG3qGcGR4mhj2aaVmcEELWMZNtXIPN4ysFRBN6oXRR3s7Hdk7W6qiYYehtrT7eqrjJakwWcJMTyGGBQvZqycW6vSmYWJ0kjdjYai+zS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/LnbHXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/LnbHXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBA71F00A3A;
	Tue, 21 Jul 2026 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648865;
	bh=JuUopVLBO1jrx+JjMaBq1ZuMFnIFCSLe36EqRLp8eRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/LnbHXGNUo6iXi4e/kZGYWl+9/nOhqw97JZx47yn2vJzc4LCaz8R8KkFeubU/JLX
	 PTgCA5xLAGi+UzzOScWFBV+i9wjgXhkJN3MLzUCoyZQzGm582s547UeKtizLCgjf68
	 k/PA93/hry9V2Ouu6wt+YU2whjgGMrs2mMy3URpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <ynorov@nvidia.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Viktor Malik <vmalik@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0359/2077] rust: uaccess: use INLINE_COPY_TO_USER to guard copy_to_user()
Date: Tue, 21 Jul 2026 17:00:32 +0200
Message-ID: <20260721152601.157350404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov <ynorov@nvidia.com>

[ Upstream commit f829d4d911cc296b32d14436a8a517e907228475 ]

Patch series "uaccess: unify inline vs outline copy_{from,to}_user()
selection", v2.

The kernel allows arches to select between inline and outline
implementations of the copy_{from,to}_user() by defining individual
INLINE_COPY_FROM_USER and INLINE_COPY_TO_USER, correspondingly.  However,
all arches enable or disable them always together.

Without the real use-case for one helper being inlined while the other
outlined, having independent controls is excessive and error prone.

The first patch of the series fixes rust/uaccess coppy_to_user() wrapper
guarded with INLINE_COPY_FROM_USER.  The 2nd patch switches codebase to
the unified INLINE_COPY_USER.  And the last patch cleans up ifdefery in
the include/linux/uaccess.h

This patch (of 3):

The copy_to_user() rust helper is only needed when the main kernel inlines
the function.  It is controlled by INLINE_COPY_TO_USER, but the rust
helper is protected with INLINE_COPY_FROM_USER.

Fix that.

Link: https://lore.kernel.org/20260425020857.356850-1-ynorov@nvidia.com
Link: https://lore.kernel.org/20260425020857.356850-2-ynorov@nvidia.com
Fixes: d99dc586ca7c7 ("uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST")
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reported-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Closes: https://lore.kernel.org/all/746c9c50-20c4-4dc9-a539-bf1310ff9414@kernel.org/
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Viktor Malik <vmalik@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/helpers/uaccess.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/helpers/uaccess.c b/rust/helpers/uaccess.c
index d9625b9ee04669..aff22f16ab3884 100644
--- a/rust/helpers/uaccess.c
+++ b/rust/helpers/uaccess.c
@@ -20,7 +20,9 @@ unsigned long rust_helper__copy_from_user(void *to, const void __user *from, uns
 {
 	return _inline_copy_from_user(to, from, n);
 }
+#endif
 
+#ifdef INLINE_COPY_TO_USER
 __rust_helper
 unsigned long rust_helper__copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-- 
2.53.0



