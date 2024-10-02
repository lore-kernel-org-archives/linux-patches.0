Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499231D0787;
	Wed,  2 Oct 2024 13:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875888; cv=none; b=NQIPx3aiLjvLIC7qut1NpJrzo6c6jwtTc6Sy4+Ji3aQPpC0qDSzcl7mvUlCB+qW6L41FNvYlj7NMagKe3V0TRZM4S8kdsiqs9XfKGo0IXQujKJobVSRMS6kpqxsTgKsYEo7ehonQaGWR7kwS4Qi43vIPG/XUgPs0zlBTipdhc08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875888; c=relaxed/simple;
	bh=41vfYWkhO820BL8+fok9GrjPW5qgsN5LcvUsVx9ScoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcpP/bfx1dNoYebX5Si1FjiqBSXI/XYlGEcxvyyq9bTTduePDbB83xKTirzZd9jMeWkCnuBiuFCBNp8o04ywqAu1UzWaf2PjXlL5dDYK+X1Q2Gdpr7ubTNnemOpAr1odQYaXqV4KakdS7X03is6mDD6YIrAIJTSd0GUdc5fbhQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYAov7+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYAov7+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C957EC4CEC5;
	Wed,  2 Oct 2024 13:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875888;
	bh=41vfYWkhO820BL8+fok9GrjPW5qgsN5LcvUsVx9ScoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYAov7+x8Benp6aQaouH7s6b5ROIwLvqjCF0E7KyaRo3QBOV0fy2erZqmJp3WQ+Mg
	 ribLWy/1/Yhaj1XKtiMJYnIAepB1DCrudeDZQg4tSG4tN40gSTcIRNPhIzdrmB+L72
	 BKH0LM+3QpqVO7zSkKujZ6D63fsYEQYhLv9l6UNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 224/695] powerpc/8xx: Fix kernel vs user address comparison
Date: Wed,  2 Oct 2024 14:53:42 +0200
Message-ID: <20241002125831.397814443@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 65a82e117ffeeab0baf6f871a1cab11a28ace183 ]

Since commit 9132a2e82adc ("powerpc/8xx: Define a MODULE area below
kernel text"), module exec space is below PAGE_OFFSET so not only
space above PAGE_OFFSET, but space above TASK_SIZE need to be seen
as kernel space.

Until now the problem went undetected because by default TASK_SIZE
is 0x8000000 which means address space is determined by just
checking upper address bit. But when TASK_SIZE is over 0x80000000,
PAGE_OFFSET is used for comparison, leading to thinking module
addresses are part of user space.

Fix it by using TASK_SIZE instead of PAGE_OFFSET for address
comparison.

Fixes: 9132a2e82adc ("powerpc/8xx: Define a MODULE area below kernel text")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/3f574c9845ff0a023b46cb4f38d2c45aecd769bd.1724173828.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_8xx.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index ac74321b11928..c955a8196d55e 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -41,12 +41,12 @@
 #include "head_32.h"
 
 .macro compare_to_kernel_boundary scratch, addr
-#if CONFIG_TASK_SIZE <= 0x80000000 && CONFIG_PAGE_OFFSET >= 0x80000000
+#if CONFIG_TASK_SIZE <= 0x80000000 && MODULES_VADDR >= 0x80000000
 /* By simply checking Address >= 0x80000000, we know if its a kernel address */
 	not.	\scratch, \addr
 #else
 	rlwinm	\scratch, \addr, 16, 0xfff8
-	cmpli	cr0, \scratch, PAGE_OFFSET@h
+	cmpli	cr0, \scratch, TASK_SIZE@h
 #endif
 .endm
 
@@ -404,7 +404,7 @@ FixupDAR:/* Entry point for dcbx workaround. */
 	mfspr	r10, SPRN_SRR0
 	mtspr	SPRN_MD_EPN, r10
 	rlwinm	r11, r10, 16, 0xfff8
-	cmpli	cr1, r11, PAGE_OFFSET@h
+	cmpli	cr1, r11, TASK_SIZE@h
 	mfspr	r11, SPRN_M_TWB	/* Get level 1 table */
 	blt+	cr1, 3f
 
-- 
2.43.0



