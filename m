Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A1C2AE94;
	Thu, 23 May 2024 13:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470486; cv=none; b=dSfuG83k+jbGjG2+OfIag40CkQsOnZbdN9NT3QQPpYYrvTRIITo9mYhI6ITa6ypUy9jOoCFdy9YczwerbkpPt58JdXTQaFnA/YUL4VwBCnC97x+JJga2iI2tqIVAhfiZgDT04Mu3J0ZVeYwuqsyZ6kbqBdRF16hcklu+MrDcWCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470486; c=relaxed/simple;
	bh=ABKL4sBtffIwA1Cqvu411S5I+TGxRauEVL8WvcZEeNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4jSdA1nASH/az1QK/Qxl71LDCs15C8Nds6K1wVX2iA7Ed586bOnPeBjJ3v7kHGG3Vvucug01rYp2v5V+Ufhotr+2R5OIALCBwgLAL20DK1yoMpQdy2zUq9Z2pOOKeLzoJho4BotG5rllh97H69D5OGZ3b+NzZkjqaJhDh5Zv/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oqy63DPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oqy63DPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6B3C32782;
	Thu, 23 May 2024 13:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470486;
	bh=ABKL4sBtffIwA1Cqvu411S5I+TGxRauEVL8WvcZEeNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oqy63DPRYAiyKXcL7vJM8ofRZ9TGMp2Fidf75aZoRt3y/0JlDdznT/6Mm5/qlZ8bR
	 orRP33SBN5QdWvUU3MLEveYoBpeAK5WiCCh0CJZmxOkdlyKWlSjC1Nmyef4jdRSq21
	 +pqJlKy/v8jGYumWufDH/Bk/LC5zneWgy2Ekeq7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oleksandr Tymoshenko <ovt@google.com>
Subject: [PATCH 6.1 34/45] arm64: atomics: lse: remove stale dependency on JUMP_LABEL
Date: Thu, 23 May 2024 15:13:25 +0200
Message-ID: <20240523130333.786843989@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 657eef0a5420a02c02945ed8c87f2ddcbd255772 upstream.

Currently CONFIG_ARM64_USE_LSE_ATOMICS depends upon CONFIG_JUMP_LABEL,
as the inline atomics were indirected with a static branch.

However, since commit:

  21fb26bfb01ffe0d ("arm64: alternatives: add alternative_has_feature_*()")

... we use an alternative_branch (which is always available) rather than
a static branch, and hence the dependency is unnecessary.

Remove the stale dependency, along with the stale include. This will
allow the use of LSE atomics in kernels built with CONFIG_JUMP_LABEL=n,
and reduces the risk of circular header dependencies via <asm/lse.h>.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221114125424.2998268-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig           |    1 -
 arch/arm64/include/asm/lse.h |    1 -
 2 files changed, 2 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1752,7 +1752,6 @@ config ARM64_LSE_ATOMICS
 
 config ARM64_USE_LSE_ATOMICS
 	bool "Atomic instructions"
-	depends on JUMP_LABEL
 	default y
 	help
 	  As part of the Large System Extensions, ARMv8.1 introduces new
--- a/arch/arm64/include/asm/lse.h
+++ b/arch/arm64/include/asm/lse.h
@@ -10,7 +10,6 @@
 
 #include <linux/compiler_types.h>
 #include <linux/export.h>
-#include <linux/jump_label.h>
 #include <linux/stringify.h>
 #include <asm/alternative.h>
 #include <asm/alternative-macros.h>


