Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2E519FA90;
	Thu, 15 Aug 2024 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730397; cv=none; b=c5bzL2ZM34Nym0WToKQ/SWhkjsSVz7Nw9ercZieFeouWNR5V9+7+sovdN7fBRe1IFK0ho3mdm2AKahZUKEykTkDROmkdhm8eDun79umWHuAB13AqQ7+v28RnbZ4XBgAB56IdhsaTch/ilp1yAP9zt+3wHdF61NVVbCBVpBro+wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730397; c=relaxed/simple;
	bh=X5ekKbbxR574IWJkbeQ+oEy6tST9SEmBTUxuPyO/eOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APIW6zeouer/KowAl4iLfLLYSWkQDToIWrbt1W9AgooaRTnujXgicYp8DuZyaIhZPonyUvLwyvtZH0niPfRcDAPafiO8mvWltH5+Ekl7MWMcLDZsdB8N1pQtNFpyH01BGniMkXYuRftMc/SSZ8CeaWoZj9gfBj3ZKl4lXGBTj+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhAhENHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhAhENHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B218C32786;
	Thu, 15 Aug 2024 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730397;
	bh=X5ekKbbxR574IWJkbeQ+oEy6tST9SEmBTUxuPyO/eOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhAhENHvVv6qL5neG6KvD40Ujgp0g2LFE7CXR9WODOShBqxIG0jQoYeMLv2qjySLx
	 8TmUHM5aBbDgbunYFZVvEGAko3sjBOEwivl0p/FXP3GIfJoBqq+xCefBZI+tS4PbH1
	 I6X37ABEr3KDmAf50+VLBIajcYJ4aW6vyJyV0gNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/484] arm64: barrier: Restore spec_bar() macro
Date: Thu, 15 Aug 2024 15:24:12 +0200
Message-ID: <20240815131956.664193898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Mark: fix conflict ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/barrier.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 1c5a005984582..6e3f4eea1f34d 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -26,6 +26,10 @@
 #define __tsb_csync()	asm volatile("hint #18" : : : "memory")
 #define csdb()		asm volatile("hint #20" : : : "memory")
 
+#define spec_bar()	asm volatile(ALTERNATIVE("dsb nsh\nisb\n",		\
+						 SB_BARRIER_INSN"nop\n",	\
+						 ARM64_HAS_SB))
+
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 #define pmr_sync()						\
 	do {							\
-- 
2.43.0



