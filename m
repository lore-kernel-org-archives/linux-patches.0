Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97B52E405;
	Mon,  8 Apr 2024 13:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581340; cv=none; b=LVYkEJjTAEVJcHZecHsnXOhFGIz95zKxAd/rVoCjSpBTPyj0Uhv4b7hUvGEE9Poaz/v93UOFsa3cX0maoqoh1NgWo2jfgVw5yiP7D3dFFguTCzLesvm8n80cbWfMYrDspnb6bjjNfi73EGaoVkAgmmIvEkFgz0IEE2A5l1AFAUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581340; c=relaxed/simple;
	bh=FhvtkwyQAxbTHVN7wSwVU/CZblCJyoDRnMgs7eN+M6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoWOglrWiuCAZTmKTeh8l1my9iw0KgNhGnLcEz7Eo+NRqw6Gqc8h2xZyAmBUjOGvecTztdPGCERfUgrjF1rPC6UQ8k8cRsmAwrizUIcj3mV3XtrJ/rgydWXDhjwz3dTM5GZ+L5VZHZwFUYmjuQ8PtXJqoWZLNjKb4sLnVFCm6Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNmROGmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNmROGmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E49EC433F1;
	Mon,  8 Apr 2024 13:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581340;
	bh=FhvtkwyQAxbTHVN7wSwVU/CZblCJyoDRnMgs7eN+M6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNmROGmFTTNdvuHQ7HvuwMZbPW7hKzREe3tJ5maDGD5MMogUFNultEKVn93VxOSe9
	 LH44DtETfW7u/bYdIDActAs7hGY8cJExJM/hfe1A3O34XrD9vqSMOCUzkPhGu0fuoq
	 0W7BV0bBYWYbWBlQDfE61U+VRxWfbgcVnH/OdWvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/690] parisc: Avoid clobbering the C/B bits in the PSW with tophys and tovirt macros
Date: Mon,  8 Apr 2024 14:48:21 +0200
Message-ID: <20240408125400.818205196@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fd8c1ebd27470..12b9236effbc4 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -79,26 +79,28 @@
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



