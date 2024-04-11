Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F3D148314;
	Thu, 11 Apr 2024 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831516; cv=none; b=jufIuOumpI8IvSrLkttJJzmefwX9QgBcR/AFs0GWRSThKzPfm5v4wAkTHa5am3WhJtV5IJMZdUj83Ro/kXWLbesKfrHvZo7QeS7L9Ekk1UkfYE/L9WJX//cu/QnwPuHui46R/lD7mG4Veop4tlYYRCgex+TUnPsQW6JE4q742Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831516; c=relaxed/simple;
	bh=uKobV/hK5X/WGJjH+b99HKuqydtMKNXeXeizBZwyZEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJB+JCjJHJQnSlLY9+WVopoM4Fu2x5LW148FonJRDjuIB6zjyOS96g95gIa/fvUIYImbWQGTgQjaIjhFu+vM7jHUA76JZuStsr6+QvR3Nqt1imB5Kn8qURYXW20bQrniVWZZaAuz4vEmGGJBNkHT5yC0r3LPDHOEB91CpwRIzec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9utPP0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9utPP0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1862EC433C7;
	Thu, 11 Apr 2024 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831515;
	bh=uKobV/hK5X/WGJjH+b99HKuqydtMKNXeXeizBZwyZEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9utPP0Tr9fug5kf5sw1w+AwYdvRzTfKDH559WiX4dfqFOE7ivorpvwg+OaYiqobW
	 tYje8CYIIgHRIOOrEWaKjPpJTObZr6Uvf5gtWZhY+jvIotP0udiW9ZG2lz4cOr+9G6
	 TB4Eb4KpP3LGGG67WqOYZl5Q1ru1Efc3OqBaX0PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/294] parisc: Avoid clobbering the C/B bits in the PSW with tophys and tovirt macros
Date: Thu, 11 Apr 2024 11:53:18 +0200
Message-ID: <20240411095436.693627964@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a39250cb7dfcf..d3f23ed570c66 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -83,26 +83,28 @@
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



