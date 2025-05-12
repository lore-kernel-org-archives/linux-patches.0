Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14531297134;
	Mon, 12 May 2025 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073562; cv=none; b=t/Tx7MU0cVnpZgln8wYmsjj4GNNWQTEJcO5MYyOp4XEHpcUD6DA5buUL4meYEmR0RZumYAwVcb73Ufa5/z5KZ+/UneVzxGF+JFHYjQZ5qKMO9NkjBOo0Ye27IPgti4pT3/IeXCLSpy1/Enn92vZ6LRmjeR//GbRSp5fzF1sf8xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073562; c=relaxed/simple;
	bh=ckVZvRquWpr0Y6iTfDq8Zg2eNItuXunFEx6/JQKQK+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2KesvfxQYLZxLpCh/CZ6joR/DODH/h2dkuVvYBFvJkvpk7v7/36cDuZbBj391nGCyeVzdnyJe2aYP2iYMMmdqxjFjmzGUBV1QKyV+JG3xVqqlsMAYb3aUREISawwTc1op9PMdpghcz7EGlV/msLF408uudaDmxrphhPPPlygzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZQ4TZn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZQ4TZn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E713C4CEE7;
	Mon, 12 May 2025 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073561;
	bh=ckVZvRquWpr0Y6iTfDq8Zg2eNItuXunFEx6/JQKQK+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZQ4TZn1IHfwE7zLWo6VDnVe6iYe56KVaZDJfqLzSEmYYHffr3ev4Li6ihnm6pEXf
	 hyNlnPzXBP1lMIfr4cEmB/uQiu+QgksDWeberaFPowwrJ/7KMza5xfvRwffTEDHUFm
	 wKSXqHgVdeDghVV9ioCjApIcUwxA9i8Nsqzd4JbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/113] MIPS: Fix MAX_REG_OFFSET
Date: Mon, 12 May 2025 19:46:15 +0200
Message-ID: <20250512172031.183836745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c44572e0cc13c9afff83fd333135a0aa9b27ba26 ]

Fix MAX_REG_OFFSET to point to the last register in 'pt_regs' and not to
the marker itself, which could allow regs_get_register() to return an
invalid offset.

Fixes: 40e084a506eb ("MIPS: Add uprobes support.")
Suggested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/ptrace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index 4a2b40ce39e09..841612913f0d1 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -65,7 +65,8 @@ static inline void instruction_pointer_set(struct pt_regs *regs,
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
-#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last))
+#define MAX_REG_OFFSET \
+	(offsetof(struct pt_regs, __last) - sizeof(unsigned long))
 
 /**
  * regs_get_register() - get register value from its offset
-- 
2.39.5



