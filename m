Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DD15DF09;
	Tue, 23 Jan 2024 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974396; cv=none; b=oHWgIc+fGfCXN0u3KrqmJ8euc9YNRAkYFVrTOaEhEXTj89dYDgSjtrrFbVRonomHFXknCbHqt3A886tX4btlKKyNsQkhnJdmF3tQGR/7XTyWMUGzX5nA/ImYeSxIL8qk9WvCjPlibRnptCRMc3IPDW+36EBryCqDQwAp0uhpSiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974396; c=relaxed/simple;
	bh=24L1QaUqdXDPWpbJ6PECJlGD8nv/UQk0bUzZRTteIBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm+L6enPzd0fR2Cva33TpRd2b/HV9s5azsbBG3tQGq2X3MMS/LfHTEW3wP51ob3J/MxFQphLt6pRiiR5zp7stL1PIkDvQHuRy9SBRp+/6Vlorhzu7ixdCiY1US3qpZclpNWyoeLjONF31eCCQzCR76bQRf+V9ZY8rDFpwK7KbNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeRai7jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeRai7jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ACEC43390;
	Tue, 23 Jan 2024 01:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974396;
	bh=24L1QaUqdXDPWpbJ6PECJlGD8nv/UQk0bUzZRTteIBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeRai7jcPufdq0em+5DNE+SoMyVxVkym3e8+V+JxJTUEXE44iWSe0CpY7JbWJIeCh
	 YNZhkUjvUwiDRqMnvuKaB6EgNhyN2uJUjNXLcUJf2Siauqw5mq20TmStYrYqk3KvO/
	 X+hWHRJFd+6635qKCThvkBDegvnghc9BpA+DbrLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/583] csky: fix arch_jump_label_transform_static override
Date: Mon, 22 Jan 2024 15:52:06 -0800
Message-ID: <20240122235814.455536384@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ca8e45c8048a2c9503c74751d25414601f730580 ]

The arch_jump_label_transform_static() function in csky was originally meant to
override the generic __weak function, but that got changed to an #ifndef check.

This showed up as a missing-prototype warning:
arch/csky/kernel/jump_label.c:43:6: error: no previous prototype for 'arch_jump_label_transform_static' [-Werror=missing-prototypes]

Change the method to use the new method of having a #define and a prototype
for the global function.

Fixes: 7e6b9db27de9 ("jump_label: make initial NOP patching the special case")
Fixes: 4e8bb4ba5a55 ("csky: Add jump-label implementation")
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/include/asm/jump_label.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/csky/include/asm/jump_label.h b/arch/csky/include/asm/jump_label.h
index d488ba6084bc..98a3f4b168bd 100644
--- a/arch/csky/include/asm/jump_label.h
+++ b/arch/csky/include/asm/jump_label.h
@@ -43,5 +43,10 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key,
 	return true;
 }
 
+enum jump_label_type;
+void arch_jump_label_transform_static(struct jump_entry *entry,
+				      enum jump_label_type type);
+#define arch_jump_label_transform_static arch_jump_label_transform_static
+
 #endif  /* __ASSEMBLY__ */
 #endif	/* __ASM_CSKY_JUMP_LABEL_H */
-- 
2.43.0



