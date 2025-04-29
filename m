Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3C25394B;
	Tue, 29 Apr 2025 18:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950762; cv=none; b=iPAkfd/izUhswnsXTKZqQJiJEPqUFOI79I5qDK7lEqWJthfnGp34PZ32rYQvA8wmPcdSfUHEcS6+dQsJ+B91yWslYpy6wxq72+EXbQrRgtI8NKNcStili/uqMvthLKwrzn5VsNnyOiyFXYRGkWQ4HY4Q5zsZfuxJObqBnGbEImc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950762; c=relaxed/simple;
	bh=pY0VQDanUa82g+WbI/mmCElk6cq2+0dNjJYZyxzbr+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm5IqoIVRe2PUwKCpd6axWfF79eYVYYK9CYHZ2qy7FqyMBhjP9nhQ1jW3ZUQ5GajgEJJlZcG5pBoPrayTD7rPoBRSoza4gLLrmWTG1eDmwiDa8kKoJnIhJaKTDtGtORzKv+kNbJiQClvrH3uwjtxW0BO14IjA7iRXBx/tRYy6Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Laq5ZDsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Laq5ZDsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D4C4CEE3;
	Tue, 29 Apr 2025 18:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950762;
	bh=pY0VQDanUa82g+WbI/mmCElk6cq2+0dNjJYZyxzbr+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Laq5ZDsJ1htbwFw8mzK3wxhGOCjpqR2jmdfJsbLl+G2c9ispMsOIGM/tgqmk8/B+c
	 /55NTRkGRK6nZM6I5QEk2PSFgfciStSpopL/fKQrfun4LMcNrai6hr/9I3jjJhUgkK
	 Zs9x3SQjaEbB48MzK1NS6YDC/thOfCDERAk1pJH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/204] x86/bugs: Use SBPB in write_ibpb() if applicable
Date: Tue, 29 Apr 2025 18:44:15 +0200
Message-ID: <20250429161106.237347697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit fc9fd3f98423367c79e0bd85a9515df26dc1b3cc ]

write_ibpb() does IBPB, which (among other things) flushes branch type
predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
has been disabled, branch type flushing isn't needed, in which case the
lighter-weight SBPB can be used.

The 'x86_pred_cmd' variable already keeps track of whether IBPB or SBPB
should be used.  Use that instead of hardcoding IBPB.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/17c5dcd14b29199b75199d67ff7758de9d9a4928.1744148254.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 2143358d0c4c7..78fd2442b49dc 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -16,7 +16,7 @@
 
 SYM_FUNC_START(entry_ibpb)
 	movl	$MSR_IA32_PRED_CMD, %ecx
-	movl	$PRED_CMD_IBPB, %eax
+	movl	_ASM_RIP(x86_pred_cmd), %eax
 	xorl	%edx, %edx
 	wrmsr
 
-- 
2.39.5



