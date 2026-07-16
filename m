Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA33D953E;
	Thu, 16 Jul 2026 13:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210058; cv=none; b=QdVt8dVEs884+47QLvo53+CQBfcmDaDVXtf2JCCjsojaPEz+oTPvE3tjNTmvAUbA25vZszQRhOAmocUOMhFHzFXfUWPHUC3SSW5j/KMsXlaNKy8nYkw5KEROqdjVeM6/z0qg0JpNr/I8uxJGobEvKmGa4JJzuPxa8R4GgHpQz1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210058; c=relaxed/simple;
	bh=wlFY+4ne1eAHL/nUHCLO+UuZ3OJe3kawyHaeZAYbmL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQwpCGxgE2UQP0dBD1HPMFPyq7xespg0IgtGnp7vZ6ELRFXXTBvp+rqcmBJ45CJin6pcxC3VVYbM56w2IwiFWx7b0hadElrDBNusnh0rQgqRVzG7AMNQVnRwK2Qw6BiidF9YMxQ/lD1MP7sJJSFLaPTEUgPNqy5RBn5FQKr1Zsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCB9yVWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCB9yVWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522041F000E9;
	Thu, 16 Jul 2026 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210056;
	bh=F9MgFb2udIgEZNMVxlbROK5CPdmF9XQxZCGvAO2RkmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCB9yVWredMMRgXb9zJEutbrTLnqSVdyV//IxCPcKntsrOfYs/zK8NfCFA+pCkY/A
	 XVrbYr28GCLhxHSBCa8XiD2JzY430k5YvNCItYAMXl8eXLmxfj/Ps9YLLGiC6l6upd
	 yxhK9S6dha7Rubu0alhTr5WUuySxVjvSngP6clc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 421/518] riscv: mm: Unconditionally sfence.vma for spurious fault
Date: Thu, 16 Jul 2026 15:31:29 +0200
Message-ID: <20260716133057.050880311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 1b2c6b56a9fa0dcbef461039937de22b1cbecc7d upstream.

Svvptc does not guarantee that it's safe to just return here. Since we
have already cleared our bit, if, theoretically, the bounded timeframe
for the accessed page to become valid still hasn't happened after sret,
we could fault again and actually crash.

Hopefully, these spurious faults should be rare enough that this is an
acceptable slowdown.

Cc: stable@vger.kernel.org
Fixes: 503638e0babf ("riscv: Stop emitting preventive sfence.vma for new vmalloc mappings")
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Link: https://patch.msgid.link/20260303-handle-kfence-protect-spurious-fault-v2-5-f80d8354d79d@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/entry.S |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -75,8 +75,11 @@
 	/* Atomically reset the current cpu bit in new_vmalloc */
 	amoxor.d	a0, a1, (a0)
 
-	/* Only emit a sfence.vma if the uarch caches invalid entries */
-	ALTERNATIVE("sfence.vma", "nop", 0, RISCV_ISA_EXT_SVVPTC, 1)
+	/*
+	 * A sfence.vma is required here. Even if we had Svvptc, there's no
+	 * guarantee that after returning we wouldn't just fault again.
+	 */
+	sfence.vma
 
 	REG_L	a0, TASK_TI_A0(tp)
 	REG_L	a1, TASK_TI_A1(tp)


