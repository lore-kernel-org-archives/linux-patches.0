Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6037373128;
	Sat, 28 Feb 2026 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301504; cv=none; b=tpFdPehQ17fe0Wzwgwk1CH7IUtB1f2Icta4GfpE7rtxLthEWiuNkWseONNtCS5zDzd4dKv3KtZuSP5c/43hVO3aZptSksIytR7V2B89JSSaZfrWTDbzokf9HWpveVL5niM0tl7bDt6TtntWVPlV5AW4YKL7kfF85C/Drs18TOVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301504; c=relaxed/simple;
	bh=z3wvK4vevx+RiBApNVeXD9smSPqYInnjaivREynm7TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixiD54aBO/uLS9W2eW8u/j+5fRN+HOVUXCjffEPAkkPGzBVpuGv/ijkrTG17OFasXiqghSP1kFSSmRDDHFvFoL1XjNvXd263GJv6xGm1V/MbCagXaiXdUJSfidVcPJOld8mJZN3SB/hs4qaI9KfB2Kb0o38TSwkwmzMYBQ+40Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekRDqtxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekRDqtxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EE7C19423;
	Sat, 28 Feb 2026 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301504;
	bh=z3wvK4vevx+RiBApNVeXD9smSPqYInnjaivREynm7TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekRDqtxMbvEKvcTTXg0qCYQQLx8BCjKI9xt/YGBRe0bmasPd4ttQCGsBe9cAskXwi
	 96mEcFgNuMFqNGBZb+UOmTCYl4tgConw7NV9/JSpC+yXO4k2jAGgiGYrt6A4ey5chZ
	 pldG68xxy3ayzn91g9JC1repnuNOPQtPz1ZRNojseB2Tt8Py7S0PNTWelGLkxuBzIc
	 vHdPV0HwUPlE3tDlhe1++QIrvg9Io1fEVAdGeBeGBpRXLV8FBoEH8ZbyWQ68sLHUHJ
	 yonrwJesf9OJ7l4uWkxtwG516fJ4+DF3GSBSd0skptnJBXxqS3aSNFipNtcgcSb4II
	 sk3y1rcNbRjjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	stable@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 689/752] LoongArch: Use %px to print unmodified unwinding address
Date: Sat, 28 Feb 2026 12:46:40 -0500
Message-ID: <20260228174750.1542406-689-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 77403a06d845db1caf9a6b0867b43e9dd8de8e4a ]

Currently, use %p to prevent leaking information about the kernel memory
layout when printing the PC address, but the kernel log messages are not
useful to debug problem if bt_address() returns 0. Given that the type of
"pc" variable is unsigned long, it should use %px to print the unmodified
unwinding address.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_orc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index 0d5fa64a22252..e410048489c66 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -508,7 +508,7 @@ bool unwind_next_frame(struct unwind_state *state)
 
 	state->pc = bt_address(pc);
 	if (!state->pc) {
-		pr_err("cannot find unwind pc at %p\n", (void *)pc);
+		pr_err("cannot find unwind pc at %px\n", (void *)pc);
 		goto err;
 	}
 
-- 
2.51.0

