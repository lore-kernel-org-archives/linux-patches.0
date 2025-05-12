Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979D5296FAD;
	Mon, 12 May 2025 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073043; cv=none; b=NtMutUURUCYKKa1kQV/29pP1VPqs0ZnY15zbeU8LxdWZ7y7mvZ3zF+xwsk1F6kYr5Nc5VvsBNtPxOTtakreKVnGroSDUgsm6KqBjJ11M4IOFr+k8Rp+PcJG8Jdo8a+B/2gfi9XNX8yIsK/NbEkzRtK1Gbn16JDxgIqcDR//kVMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073043; c=relaxed/simple;
	bh=ZlUZfdVo+qewTvhYqENLtuR/7WNkQL4N68j/qzv2oow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOxWksUMlM3G3DCOMRGpOMIxq+O/h7uXeqXwZnWUxj1rmA9Q4nSa0HjF10tQOAWT77CHKQECe29NE8md61FbgVEugkexQC9yh2mdEMZGxdRab/cWyVgRSCWTehZVdpfI4NpQQHjWCX/+YVLLPKmYm58dDsJVE0l/ZTzJF3DjXmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsux4j7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsux4j7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0759DC4CEE9;
	Mon, 12 May 2025 18:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073043;
	bh=ZlUZfdVo+qewTvhYqENLtuR/7WNkQL4N68j/qzv2oow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsux4j7wd8f7cckxEaaODucSMgSB+/UNNJoR1HDEViDIT3omevr7N2DdbMe29UYu/
	 icaZYcCav3yNom3V4emM0xiAzfKqp0tPQhRMg6XqS4hwR0vsHFVQ+7xYOrMhnscohC
	 fOoAIsYM2B31WhwpmqjhrQ0FsBMS0e0hrPPKpiig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/184] MIPS: Fix MAX_REG_OFFSET
Date: Mon, 12 May 2025 19:45:38 +0200
Message-ID: <20250512172047.394688649@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



