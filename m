Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C22472798;
	Tue, 16 Jun 2026 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636029; cv=none; b=GlYyMGPlhXkWBo0FIdi/g6PRS4rW5O4Jh+nD+hYyco/fnaFsNicf2VcXFP2VtnHS4yznwfm50rYw4XA3A2Ir9N4SaGC0CAOS/Eir0TwyatMaeZpCs6mIhJyRWv/QwZvReYiIddbWfcIS7CnJZ3mwmZwW3KNvkVXCCgac4eojwTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636029; c=relaxed/simple;
	bh=rb1p2pVMsgxD9W9Mh54IFankvZp6hY/tiXfi80pSA+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1+TUFT1w+u4vtg7ekiVRgHOR08IyPxkIxko1mQpYnR0dZSBIOemzROOMYU4plCqn5s8ahRLojsHtH7Fz9UaBOtYGqKdtut96CUjgxrm8hks/PbPmrHOQaaUJAKOY5KzS/TdgCbNiz3I+NriXLHWzN6rVxrJ+21j2jr9WePxzpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2/ZaMr0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2/ZaMr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B557E1F000E9;
	Tue, 16 Jun 2026 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636028;
	bh=F/T8c805nWnMAXA1aq4abNp2PX10DjMK2uBgnOWOxKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2/ZaMr0lN9+cKvRpweU6l0l19Nc0ATZNCOjtHFz3i6D+CyiDKUFe7yxG9GJZmQ6S
	 fe4515YneQ2U2fwdZ7g8nnTVFTjXYbIVjfePnPzgsvtWWmKQ8Il7DE5GMxMqi6wV/+
	 1PXvuZ+NFy4OKSxgjFZaG44c4pLhmRGxOhKsYbBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/342] compiler-clang.h: Add __diag infrastructure for clang
Date: Tue, 16 Jun 2026 20:27:04 +0530
Message-ID: <20260616145054.164143894@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit f014a00bbeb09cea16017b82448d32a468a6b96f upstream.

Add __diag macros similar to those in compiler-gcc.h, so that warnings
that need to be adjusted for specific cases but not globally can be
ignored when building with clang.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220304224645.3677453-6-memxor@gmail.com

[ Kartikeya: wrote commit message ]

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-clang.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index d9376e327d665f..fae3775d02b516 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -126,3 +126,25 @@
 #if __has_feature(shadow_call_stack)
 # define __noscs	__attribute__((__no_sanitize__("shadow-call-stack")))
 #endif
+
+/*
+ * Turn individual warnings and errors on and off locally, depending
+ * on version.
+ */
+#define __diag_clang(version, severity, s) \
+	__diag_clang_ ## version(__diag_clang_ ## severity s)
+
+/* Severity used in pragma directives */
+#define __diag_clang_ignore	ignored
+#define __diag_clang_warn	warning
+#define __diag_clang_error	error
+
+#define __diag_str1(s)		#s
+#define __diag_str(s)		__diag_str1(s)
+#define __diag(s)		_Pragma(__diag_str(clang diagnostic s))
+
+#if CONFIG_CLANG_VERSION >= 110000
+#define __diag_clang_11(s)	__diag(s)
+#else
+#define __diag_clang_11(s)
+#endif
-- 
2.53.0



