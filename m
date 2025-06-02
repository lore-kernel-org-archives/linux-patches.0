Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC0222259F;
	Mon,  2 Jun 2025 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875260; cv=none; b=p+XoRy2vF9IZOL5iiS2UbC2DTmCmgSkF9wVlCowJkSvP7Qsiq4KQHnDU2m53LfJ+7NobQtrla/n0oLBiBL8bQbtRb7jpuT1lk9IX6VO8h2Y/Rv8qTo1DOu88Bsg4DvCGodR3tyBw2zwqCHh+rkIC6FXzP1UE+ACQYa0RXTMOKvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875260; c=relaxed/simple;
	bh=s7yQiLZ78+zl5x1aUy3WKzJWl3Hq37RkV8MIgAKvGV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asR/Pxrmh6LqXGvTajX/Jh+xQvAkM8YYbWylm+iOvHK9unNbrh3dvdSnPssITJYExDXVTpw8/RWrcGRTD11/fx6bZZ/9oEMc4MSE8wd3xc04wSrnysEBsJz/oJWXE9aN1iB1bKEhlLMfKWE9ZoC3SXyNNMFBg9LH5asIEOoyEDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGNSvUBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGNSvUBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6375FC4CEEE;
	Mon,  2 Jun 2025 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875259;
	bh=s7yQiLZ78+zl5x1aUy3WKzJWl3Hq37RkV8MIgAKvGV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGNSvUBcmru0T125qoaRsGG5f8OzCZnBJ4qKgOqRdH6RtQg4yUiJTIbRwCmY7gkza
	 Ef4iGY6E+5B2Rj7RO2J4EOb8P9wQ1O8lchUr+X+JmD+YCyFfpwj4rK+WpUsAhyVnFz
	 Lka9L7JR81aItXNitQu4e1sgDTshvSFK0SZb9U38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/270] MIPS: Fix MAX_REG_OFFSET
Date: Mon,  2 Jun 2025 15:46:04 +0200
Message-ID: <20250602134310.407524069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ae578860f7295..4ec9b306556f6 100644
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



