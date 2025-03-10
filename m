Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE918DB24;
	Mon, 10 Mar 2025 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628363; cv=none; b=EQHd0nh2E0x0IEMSj7ATIvhFyJhhgM6jNhCNKgz1xk+eauRTD3bp5+GPpj748AL9nVmjJgTRNsahzQFHbH/V65AiolZsIbl1U1RWMJJVNP7oxpGFg6faEcX9x4fSp3mYPuzGremBEeYK2z6vKSkpN85U/xoz5p522CC21N+dhYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628363; c=relaxed/simple;
	bh=Qc4azid2G2IUn/J4WtQUSTGsSUqe1N/8d6e6MWKyPaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgGETNJsG4Ggi6BenyJR73yEXiZWllDTYEyaSYFXhc6FeFMHCGDkzYndymv6KuGgtigU48fXYKnV0WRlZNq/D44KNc68Zv+XVO3wS4gvst/zjYqz59Q/pRm5Nh7AxT5aDQxKmRTEUizitd+16e7kjX3vvZgx2yDq2/3VFoBquPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEEv3lgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEEv3lgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA90DC4CEE5;
	Mon, 10 Mar 2025 17:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628363;
	bh=Qc4azid2G2IUn/J4WtQUSTGsSUqe1N/8d6e6MWKyPaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEEv3lgD7bDDVvzNEbhS33bAVAiaf9jeqmx2ryaHfy6RaKoygvQaCsAgXSPw1XQB8
	 Vppm0oEtq9+HLCVLHn9e8upQTp6ox9ELoSj9e+am8W3P6PYd7dneZMYzYTTvI2A+8N
	 GqojMhbZ78Qxot1Q1KSTXBLvC3o51S1VwRwYeBHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 033/109] s390/traps: Fix test_monitor_call() inline assembly
Date: Mon, 10 Mar 2025 18:06:17 +0100
Message-ID: <20250310170428.878702988@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 5623bc23a1cb9f9a9470fa73b3a20321dc4c4870 upstream.

The test_monitor_call() inline assembly uses the xgr instruction, which
also modifies the condition code, to clear a register. However the clobber
list of the inline assembly does not specify that the condition code is
modified, which may lead to incorrect code generation.

Use the lhi instruction instead to clear the register without that the
condition code is modified. Furthermore this limits clearing to the lower
32 bits of val, since its type is int.

Fixes: 17248ea03674 ("s390: fix __EMIT_BUG() macro")
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/traps.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -276,10 +276,10 @@ static void __init test_monitor_call(voi
 		return;
 	asm volatile(
 		"	mc	0,0\n"
-		"0:	xgr	%0,%0\n"
+		"0:	lhi	%[val],0\n"
 		"1:\n"
-		EX_TABLE(0b,1b)
-		: "+d" (val));
+		EX_TABLE(0b, 1b)
+		: [val] "+d" (val));
 	if (!val)
 		panic("Monitor call doesn't work!\n");
 }


