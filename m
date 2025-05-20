Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53DE244196;
	Tue, 20 May 2025 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749425; cv=none; b=DUTeJjnYNq6vvuhPhOCmc9yXdD/4d5Tg71K9lYMEZuxoNThf0DBUeB3nV1D9RzxRByD2AXjOczVKUk08NAtG5Avsz9yb6FrT2h18VyXaJTMvfa0xUXvbDjBzNLfNQVE2crSjjZax0HP11fPlj+1rjZA6lOvzWLF8hCHNW9N0dB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749425; c=relaxed/simple;
	bh=/XxP9NvPsXi3TyG3PZPVHdSGhf/2cY2bKB/6xgN54ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCp5eQCZjoiK182cbV2zli/2v/B40fOCopcgze+VWCy/v7KC+QTgr4k8ebHSwhxj0YLajormVkdRxZwVQq5mwzDHGdF/4QUxFAmbtiCtMdCmxbfst8gsnNyefWr8AVpyMKNHyzb3ID6hfUZ8/ckw5ZPpLWJwpIJ+CzrJlvTzchA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jnskb7kl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jnskb7kl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17F5C4CEE9;
	Tue, 20 May 2025 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749425;
	bh=/XxP9NvPsXi3TyG3PZPVHdSGhf/2cY2bKB/6xgN54ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jnskb7klH0Xt1NyU4SwVFFNYk9bkcNLaCeIat5z8INYEsf9ha+K1PjMOnmjE7kUoE
	 Toys0+GJCpTzzvx6oJXfz2pMWcNNvdAsSoYnsi/fAAAj69chUdptMjiSUQQSiusYCH
	 qn6iVFE3SdHWLblK7XzpAAFtYtwvyGpZTq53MANk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 41/97] LoongArch: Fix MAX_REG_OFFSET calculation
Date: Tue, 20 May 2025 15:50:06 +0200
Message-ID: <20250520125802.269276363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 90436d234230e9a950ccd87831108b688b27a234 upstream.

Fix MAX_REG_OFFSET calculation, make it point to the last register
in 'struct pt_regs' and not to the marker itself, which could allow
regs_get_register() to return an invalid offset.

Cc: stable@vger.kernel.org
Fixes: 803b0fc5c3f2baa6e5 ("LoongArch: Add process management")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/ptrace.h
+++ b/arch/loongarch/include/asm/ptrace.h
@@ -54,7 +54,7 @@ static inline void instruction_pointer_s
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
-#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last))
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last) - sizeof(unsigned long))
 
 /**
  * regs_get_register() - get register value from its offset


