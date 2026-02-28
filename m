Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A745333F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300926; cv=none; b=PEOxYZKz1Dj68vhaSbEB3xKVjL9F3X1hJUiKU6szxwZHIgDCe3yDUroocdcUbpajp52bOyRre8LnmfUYEm8xDgnUuzrJ0xz27duTtxCsZ1DedwOVgHDS8yHwo9EHj4Wz0ZHq1AsTgRMXP7zLYFX3NdAT9zLfIOe4IWaZArzfTHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300926; c=relaxed/simple;
	bh=q5+eTpJEtm/NtSIptrOsXsgToHQsgqbA2ZPIYQf9e64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccGUXkQdUeNxBNhz2o+GYGInQNPuqf1Wb4/jb1O7Z0szVQ701yBN0U4t2Pq5TcMuPHdnodNMJrRP/DCB12nhEA4yWv/bHQXQY2VHemBPv/h0bPadzfQQyUCGvn+GyTHGnGutKfHFvh9dJRB4qm6FB6rU8gHcWe6bcUEq3QMJOCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4dU9qsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4dU9qsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C017C19424;
	Sat, 28 Feb 2026 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300926;
	bh=q5+eTpJEtm/NtSIptrOsXsgToHQsgqbA2ZPIYQf9e64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4dU9qsgdI0FjyVQi5a7O+/QQlIQSthtHB/gf7tBCmHBhsAb0jhvyS3ky0IBKGvYU
	 OYil0Ks4cR86mfLWKKRF6hgkFnj5lsrf6pkXRsZCpnnZA+n4OjLv6bEHrmC5xaEGqZ
	 K0/AmeOOFBD9HsXOwlb0CG9VKXz4GNYGNhhQ9TatiBxlFsXoqxrIt5m+IAsdLnjl21
	 Hinj7p7Pt+xmsv1WTYs4PIa7oYISEmUbvw6NqxGp+S7HY3YcXk0IEIAxVasC/wGQ1p
	 srxgiAimJnhKTMisp0qUjwtbf0WQepk/+U2zJksCrLUPzk3pyeYjcHw4EavwhM9tNq
	 oJOqxtulBUmfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/752] s390/purgatory: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS
Date: Sat, 28 Feb 2026 12:35:56 -0500
Message-ID: <20260228174750.1542406-45-sashal@kernel.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b4780fe4ddf04b51127a33d705f4a2e224df00fa ]

Add -Wno-default-const-init-unsafe to purgatory KBUILD_CFLAGS, similar
to scripts/Makefile.extrawarn, since clang generates warnings for the
dummy variable in typecheck():

    CC      arch/s390/purgatory/purgatory.o
      arch/s390/include/asm/ptrace.h:221:9: warning: default initialization of an object of type 'typeof (regs->psw)' (aka 'const psw_t') leaves the object uninitialized [-Wdefault-const-init-var-unsafe]
        221 |         return psw_bits(regs->psw).pstate;
            |                ^
      arch/s390/include/asm/ptrace.h:98:2: note: expanded from macro 'psw_bits'
         98 |         typecheck(psw_t, __psw);                \
            |         ^
      include/linux/typecheck.h:11:12: note: expanded from macro 'typecheck'
         11 |         typeof(x) __dummy2; \
            |                   ^

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/purgatory/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/purgatory/Makefile b/arch/s390/purgatory/Makefile
index bd39b36e7bd68..cfb73bbcdfe85 100644
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -22,6 +22,7 @@ KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 KBUILD_CFLAGS += -D__DISABLE_EXPORTS
 KBUILD_CFLAGS += $(CLANG_FLAGS)
 KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
+KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
 KBUILD_AFLAGS := $(filter-out -DCC_USING_EXPOLINE,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS += -D__DISABLE_EXPORTS
 
-- 
2.51.0

