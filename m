Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1E024BBE1;
	Mon, 12 May 2025 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072513; cv=none; b=Wxx3e5Xs1xBZNAFjKQgy1VjhrKOQB0wNXagXMhmQFRg/ttBVuPiSgrLFBz18GCBX/gtcHzrO92lSWhdyFjno+5JxjdorPIPN+Jy5jXQoj9UrOHfSj3fpS1xInoF9lvR5Gg/bIdWEKje+b/1CWvEdDkRSTYsLAMrPfiT1IhfzBRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072513; c=relaxed/simple;
	bh=k76RyIXHctTnwEdS4KxAdBw7x9/YITno0JhQX2BCRig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFldwJwvha92fRmvvY5qlOaMhS6cyEMmCwOCvVg8n3vY1iYL5OquNH2A3cCTVIA5LHOXXu7DIHfsZxrLWmHlf+dz9b5zkahuJMwLoNVb2pkkQ3y0teKkFAANTnqklyflZPTsW0JGOQ9JzxEX1dJYw9lHWEuNInDf/GTAOvFmhcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9pLbLeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9pLbLeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CD1C4CEE7;
	Mon, 12 May 2025 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072513;
	bh=k76RyIXHctTnwEdS4KxAdBw7x9/YITno0JhQX2BCRig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9pLbLeb0aHra4iea2VR5KMpVFP1/Q8fS2NeJjm0xzOD8wT+q48KVwppIiSHKYgW2
	 m6bgmAzJ1ePdtfYHw8bEd5gEzDyyFhp9xPxdQFF9+fiD/XWcpd7d/gKThKHZpjtC+I
	 Pbe16jqpDn3GRdCwHKGuPPPNShg5Woc74W0ZNGEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 65/92] MIPS: Fix MAX_REG_OFFSET
Date: Mon, 12 May 2025 19:45:40 +0200
Message-ID: <20250512172025.771762208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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



