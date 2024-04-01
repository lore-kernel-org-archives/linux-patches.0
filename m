Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEECBA3F;
	Mon,  1 Apr 2024 16:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990720; cv=none; b=EH0zRTt2a5BDenf4KWPcKNhajqxO4ipzl7Aujz3uZ0R/X2ov8M/8i0SauWlqPcI1oL8MUY3yVwlO+2gsaG4v9uDkHNf5At9uZZ/IFGkR4Oq28Y49Y/9j5sM34NCDYeHMSow0CMZZhRmJcm1k/Z+UpXXSpwdF+lo/BK5DmvP8MS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990720; c=relaxed/simple;
	bh=bxYXKjnxz7Yy4IDXk28odB2bi2HeySaAP93qLMw5yX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLXQqyzcEWFiDJyiBl4P1caBdg5o1orSuwqNjV4Vh6C/i/FgCmORzVGLGs6DVcXzAOpIoDxBRk90RH9ZK8f6Lag1LfAmqX6Iu2sNm1p5DldpFfSGI8aeQxNSsYbFb0ZmSWZz28pn2OsSOAv68+EGFx2PCB9mtGYb9bd3HnqEDbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRgn6qiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRgn6qiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BABC433F1;
	Mon,  1 Apr 2024 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990720;
	bh=bxYXKjnxz7Yy4IDXk28odB2bi2HeySaAP93qLMw5yX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRgn6qiVAiizQ/ThoKQXC/KylZGQiQJ7YEjUkR/Y3Ms8vjIQ8oitzr+nv57+byV8K
	 9UgtIpQEGo8E+0xX5CpTT2uBO27x03HIEQNlsMlAmX1DP/Rls+X17zBLB+ToVjR0Hb
	 55U+/8RkN1N7mH49OG099L0FAgiSFSPc2Bbql9EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/272] parisc: Avoid clobbering the C/B bits in the PSW with tophys and tovirt macros
Date: Mon,  1 Apr 2024 17:43:55 +0200
Message-ID: <20240401152531.808059480@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit 4603fbaa76b5e703b38ac8cc718102834eb6e330 ]

Use add,l to avoid clobbering the C/B bits in the PSW.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/assembly.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/parisc/include/asm/assembly.h b/arch/parisc/include/asm/assembly.h
index 5937d5edaba1e..000a28e1c5e8d 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -97,26 +97,28 @@
 	 * version takes two arguments: a src and destination register.
 	 * However, the source and destination registers can not be
 	 * the same register.
+	 *
+	 * We use add,l to avoid clobbering the C/B bits in the PSW.
 	 */
 
 	.macro  tophys  grvirt, grphys
-	ldil    L%(__PAGE_OFFSET), \grphys
-	sub     \grvirt, \grphys, \grphys
+	ldil    L%(-__PAGE_OFFSET), \grphys
+	addl    \grvirt, \grphys, \grphys
 	.endm
-	
+
 	.macro  tovirt  grphys, grvirt
 	ldil    L%(__PAGE_OFFSET), \grvirt
-	add     \grphys, \grvirt, \grvirt
+	addl    \grphys, \grvirt, \grvirt
 	.endm
 
 	.macro  tophys_r1  gr
-	ldil    L%(__PAGE_OFFSET), %r1
-	sub     \gr, %r1, \gr
+	ldil    L%(-__PAGE_OFFSET), %r1
+	addl    \gr, %r1, \gr
 	.endm
-	
+
 	.macro  tovirt_r1  gr
 	ldil    L%(__PAGE_OFFSET), %r1
-	add     \gr, %r1, \gr
+	addl    \gr, %r1, \gr
 	.endm
 
 	.macro delay value
-- 
2.43.0



