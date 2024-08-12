Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29292C1A5;
	Mon, 12 Aug 2024 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479397; cv=none; b=pYiqG9w1TODeRIO49g/Lbest+F6WT+gk97UztXctPIwV//nH9ZbAwHaE5t7RjA3h95ISk91QPY1Tsq7B80PUr5+UtZrzEFt7nj6ctMORhZTbqiWUjCQlmv57oH/UjbOaTam8xiYxkXmfLtyjkMC+3QBgDQxgYlOTPiyUh/R1Twc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479397; c=relaxed/simple;
	bh=FSoGIVz9GpZSyNftuho6qufpIUb1EjA8fZRAjd9Z5HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHPdzmDa56IwRfzZXrdD8v0F1yOJV4sjrydIAGplMrrkGuTH/3TCbPBf4vriu/QL21tICbUggHVgK3yPJ5SX3Dj4+6c9cVfaJ+yfyQG4/kLHILbOTTYv/drD8nhyKyhWLHZl6KWN0zvZKyfSpwp7T/QVuVGpQwb4nywe1c/Mu9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yox48pEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yox48pEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C157C32782;
	Mon, 12 Aug 2024 16:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479397;
	bh=FSoGIVz9GpZSyNftuho6qufpIUb1EjA8fZRAjd9Z5HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yox48pEdYet6ojSfRsXDS+w9p4ZWBsv6LzMW0GCMkAhgKuj5g8khkCPZzwNKW3j/C
	 iaBFlegU57VxVPoXHWhBCZlPcyPU0GbnsQvBUfMprsL5hpDPylXvQHsWAmj7H+z2az
	 NUym0+SkltGA5JA6xgXgE67vjjpncQnPz+zaRJtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/189] arm64: barrier: Restore spec_bar() macro
Date: Mon, 12 Aug 2024 18:02:11 +0200
Message-ID: <20240812160135.028839965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit ebfc726eae3f31bdb5fae1bbd74ef235d71046ca ]

Upcoming errata workarounds will need to use SB from C code. Restore the
spec_bar() macro so that we can use SB.

This is effectively a revert of commit:

  4f30ba1cce36d413 ("arm64: barrier: Remove spec_bar() macro")

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240508081400.235362-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/barrier.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index cf2987464c186..1ca947d5c9396 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -40,6 +40,10 @@
  */
 #define dgh()		asm volatile("hint #6" : : : "memory")
 
+#define spec_bar()	asm volatile(ALTERNATIVE("dsb nsh\nisb\n",		\
+						 SB_BARRIER_INSN"nop\n",	\
+						 ARM64_HAS_SB))
+
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 #define pmr_sync()						\
 	do {							\
-- 
2.43.0



