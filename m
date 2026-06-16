Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B0A3D45CB;
	Tue, 16 Jun 2026 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633787; cv=none; b=kWM2xKP6cxAomwI2rErD8FPUzdcdZnIfaxlinVn5OVheOVA93QU6TDisvNi2prS1CpRi/w2LXvAwCh7ZcvwdV8clQjyK+qhtfFdHm9fC2DAflxK2Hg3rEVDUzsgrYhK0yM7zJc0eSp8rBcYDhpQ4SoQ3dsOhHiiFh2HnpH2ksoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633787; c=relaxed/simple;
	bh=jyQkCn0QVkPSmbZ5QdOqqBZKB138Nt/xvFbW4aFxlmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs3eAuSriUlDE6IfGByc9t5veHhnQu8oTR4Dt2aGFLwhTVQg1GMlfCBrgSfrWoRZCc9X7f9LCxewpLUvpBOsTjTZFfeKFikuT0/WWamggYKsTk+/OibAuY8h3nXH7WFRkSh5Ugp7tqPBIAZy1DlmFCiEVP4n8P2aA7gRtbCZqpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgP538GU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgP538GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CA71F000E9;
	Tue, 16 Jun 2026 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633786;
	bh=2FIixMHxxvol7omVq714WTzXHTJnoPUv0Kxh3QVSE1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgP538GUE7gdwR11mtHcKaCyhfw6ksnYtrev93h6o6dBPiJ8XbWFYF/cqaf6wrvZg
	 Rh4vvbT/1HEzQYmt8J6J1Vdj6HqcOv/3Qj66J3/obm4M4BtglxWfP1P5R6VXEYxTvc
	 oIxleRZhX2nDZnUlcbeRRF2PDej4cenZoAL3R0rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/411] compiler-clang.h: Add __diag infrastructure for clang
Date: Tue, 16 Jun 2026 20:26:23 +0530
Message-ID: <20260616145108.102141390@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3397f6809c8694..7ae9fc072302d4 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -119,3 +119,25 @@
 
 #define __nocfi		__attribute__((__no_sanitize__("cfi")))
 #define __cficanonical	__attribute__((__cfi_canonical_jump_table__))
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



