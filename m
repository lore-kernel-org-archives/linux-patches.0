Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC0C313E32;
	Tue, 10 Mar 2026 11:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141970; cv=none; b=AiBDzCEVHCBUC6S3myKA2qBHrVPUD+RU+VoT8vOse2a5ovLIj9/wbC3KSHGeTJbm6UjZnGCG5Kd9dVLlZw7iq9jGnXI/UvJ5UeNqteVzs8gJLnfIXOoYMHTPvQnFTyC9w/XCx3T7Dw4K4eJTPeSYsZN2yHtAlmldDZwAEzrcUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141970; c=relaxed/simple;
	bh=A10Gh4sIxtmQKcXmmcuWYhhS8h1bqOMUcwOCvkYGnvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpWHm200Ml+YZLvmkyywCpbuZTwPHKlf+R/366i96j0XynWLShRPcd3ij9wfBJkpTHjzgtIapzzCOScbmXXgmiDoZKxkxCyOvOgrvzyXdi2LnT+1IVz4CFwBqwqyOSIQ7cuQ/8lohfwI7MfbwVxMZ4C2aKJeKRKi5ozPNdjRGkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzVIUvPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzVIUvPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB08C19423;
	Tue, 10 Mar 2026 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141969;
	bh=A10Gh4sIxtmQKcXmmcuWYhhS8h1bqOMUcwOCvkYGnvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzVIUvPdqBosUO5Zr7hN7iI/yP/DeXVCCWmrK63OLk0Pb0obYCPDrD3nd+CnAV7n1
	 QlMUfm5mwJt1GqLvbCrqmLPJWJXRtq5xoRO6SZEc+9Q8WQjPscjBCPBuvxL3pmduti
	 g2O4QlQKcxlmG04ULjZmYhTT+gvrzyUxPndiEGQ+WEgfR0Ci0sWpMYoUrg/xsodgRi
	 NKz9UBx6JN31Rb0AEIxDMfQYvX5TxcN6oNVNgne4j2gj0AFltwWqxx8SBEtuAOPgXk
	 aEkrmOvcAnd11V2tBXfajfLmeN7Pg+WcyIoNdT5X5HRXUvYzEJedbSMIJ0pMouc4cs
	 THq1KyzCicdXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/314] unwind: Simplify unwind_user_next_fp() alignment check
Date: Tue, 10 Mar 2026 07:15:53 -0400
Message-ID: <f52978eb0859642bdb61717dd10b6a9a16a17dfb.1773141555.git.sashal@kernel.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 5578534e4b92350995a20068f2e6ea3186c62d7f ]

  2^log_2(n) == n

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://patch.msgid.link/20250924080119.497867836@infradead.org
Stable-dep-of: d55c571e4333 ("x86/uprobes: Fix XOL allocation failure for 32-bit tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/unwind/user.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 97a8415e3216f..9dcde797b5d93 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -19,7 +19,6 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 {
 	const struct unwind_user_frame *frame = &fp_frame;
 	unsigned long cfa, fp, ra;
-	unsigned int shift;
 
 	if (frame->use_fp) {
 		if (state->fp < state->sp)
@@ -37,8 +36,7 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 		return -EINVAL;
 
 	/* Make sure that the address is word aligned */
-	shift = sizeof(long) == 4 ? 2 : 3;
-	if (cfa & ((1 << shift) - 1))
+	if (cfa & (sizeof(long) - 1))
 		return -EINVAL;
 
 	/* Find the Return Address (RA) */
-- 
2.51.0

