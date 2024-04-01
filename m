Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F2B1E86C;
	Mon,  1 Apr 2024 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989585; cv=none; b=KEDoIwCMz4OswdJCS4D34qHsVNIXgc+P47qeYqK1E99z4N3oJji/VNgDSOgXwUQAqJIMDNKPrTjPoW+At1bHaYju2W8GQNDaJMdw95/Lvlvh2H92ABx64y/N5GAgQIuDxc8sfLG6Ha5ATCRNM2mFict3oDToGTY8fYiLEq+1OSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989585; c=relaxed/simple;
	bh=gZ4e5xHhCRCmM+5Zs+ug6p3R62j/5YMUgXzEBy/rijg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCuXn8WA3BXwxBmKj8lEDUn8jmRDIXOLom6643RbA1cUnCWokJrpnn23jfhX9qgJVJw90NqVWngFjt3IC3cu/JZYv0vkdvrl7eTntDHBP9BDIaHku/JqfOGdGfiE1BJ3xTlc3KaQ6l1ZXo5gBLf4z3ojnnyERbPJmmSOOVtLadQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wn/RGMjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wn/RGMjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E7CC433C7;
	Mon,  1 Apr 2024 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989584;
	bh=gZ4e5xHhCRCmM+5Zs+ug6p3R62j/5YMUgXzEBy/rijg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wn/RGMjkrNk2+fmKjs7OsK/BBgc13qgNkNeJTAjU7a32HVVjvwN4zdgQVwAeK/ocY
	 SReXsGP8hcpOYgxr6583MQU+zgvVeR1lh5KkknKxLK0X3eb/UIz39LN59gyJL9Ajns
	 0akKUPfjidrSnL5QhezJNeXzb6p8TwOFl2Ei3u14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/396] parisc: Avoid clobbering the C/B bits in the PSW with tophys and tovirt macros
Date: Mon,  1 Apr 2024 17:41:43 +0200
Message-ID: <20240401152549.536148810@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



