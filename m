Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78FA22FE0A;
	Mon,  2 Jun 2025 14:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874549; cv=none; b=bKM72uoYzjDSJrJqeLVqMguN9AEL2fdlwjibChkZ5AFs8FD0EdMocCV3OfOOROu6Vb27Iz41NUE5k1bZI6gI+gOd9gKGOcOXoR7nAYJmmbsXzgguVsAtYPKLTCvzJe9Bn/Lolj8hliAJCM8nYvZZYSv31qK8YWVJFzgvP+LiRvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874549; c=relaxed/simple;
	bh=w4FCF4+ZvXz8e6/JCTdLXJiIU/xccmKRhot1MsSs1nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZls5ukT+R/sNf/gktZ1ubxYM98BJlw4qS45uJ8C4s38CtcZQZE1b763O29KpQXPd+nURkP6v840ee9/JdEVF8TSjrNISbgTAl3mfhji8xaLTGURhYNX/w4KN6oj6lpiUhGpCcgbYeGZ4fYeIGx/+gGBgbaboeBhywTi5GgDAiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Io4EicAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Io4EicAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CF1C4CEF0;
	Mon,  2 Jun 2025 14:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874549;
	bh=w4FCF4+ZvXz8e6/JCTdLXJiIU/xccmKRhot1MsSs1nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Io4EicAHLNC5JqyME1dnPP+iVxXdayEF9/Fm2yTyJi4pGUFIZhwiIitIdikbcUlwX
	 0TuYHXAmFmmMt60DJsZWR7WgastEcVgkHIux4C/X4VCec+qpxdXAc1HaFJhDWDgTAs
	 b7x0na4nufaHryQYKZdNm/9wg4zZotEreUmZGXKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/204] MIPS: Fix MAX_REG_OFFSET
Date: Mon,  2 Jun 2025 15:46:32 +0200
Message-ID: <20250602134258.001180415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



