Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484A27713;
	Tue,  9 Jul 2024 11:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524365; cv=none; b=ZFIcWTE1ouHM9fPNT7/bE0TIPoQzK0VEHvXId1T3Yeqft/sTRr6uJTv7f02wcKAAMDm+QDW8wOO3GCcSEhbfJ9clGL7nDbdtHQKu5Tn3p/bDH203aOHOf1J+wQULWN8KNq39jHjLQ8xdt87KZr2OluVZqFQ74pDu/P5WiZiYixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524365; c=relaxed/simple;
	bh=8JNg55OD6DQHQJx5lk0hdpvKqZbR1+Mz2lQBPHybNO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAc3U8MVR04Sg2kVmiUJeDwBVeg48uYN7JfYr8uiTIa6lpdH7hfePtsKn2KjzPBLeVJEvEcnDnlfF2xI6zl+yZxoIasF+RQv+UJR5HJTRIAMid0+BCBI8V1RVmdm/F7c+CbdQHMl9j3kzEkjPfGGxDatvrYiQCsZ7bj3ms5+JDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJ2NFIHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJ2NFIHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC0DC3277B;
	Tue,  9 Jul 2024 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524365;
	bh=8JNg55OD6DQHQJx5lk0hdpvKqZbR1+Mz2lQBPHybNO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJ2NFIHH8d/duIgJOqQoeVuhCJaL/NOrmSYt2N2vEAQtMflh9A9cQuROXtFgrmam9
	 y/l8b9gtKSjF0laTQRy19+lq7uFE0JGqTEUhsR+wCiHwLWwetawAhmrRm0UFnNOlhd
	 UqOVHa6L+sVxGDwFnOvIj7se/tdgPX1NsOp7CJiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinglin Wen <jinglin.wen@shingroup.cn>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.9 157/197] powerpc/64s: Fix unnecessary copy to 0 when kernel is booted at address 0
Date: Tue,  9 Jul 2024 13:10:11 +0200
Message-ID: <20240709110715.029539964@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinglin Wen <jinglin.wen@shingroup.cn>

commit 13fc6c175924eaa953cf597ce28ffa4edc4554a6 upstream.

According to the code logic, when the kernel is loaded at address 0, no
copying operation should be performed, but it is currently being done.

This patch fixes the issue where the kernel code was incorrectly
duplicated to address 0 when booting from address 0.

Fixes: b270bebd34e3 ("powerpc/64s: Run at the kernel virtual address earlier in boot")
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Jinglin Wen <jinglin.wen@shingroup.cn>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240620024150.14857-1-jinglin.wen@shingroup.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_64.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -647,8 +647,9 @@ __after_prom_start:
  * Note: This process overwrites the OF exception vectors.
  */
 	LOAD_REG_IMMEDIATE(r3, PAGE_OFFSET)
-	mr.	r4,r26			/* In some cases the loader may  */
-	beq	9f			/* have already put us at zero */
+	mr	r4,r26			/* Load the virtual source address into r4 */
+	cmpld	r3,r4			/* Check if source == dest */
+	beq	9f			/* If so skip the copy  */
 	li	r6,0x100		/* Start offset, the first 0x100 */
 					/* bytes were copied earlier.	 */
 


