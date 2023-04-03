Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E096FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE9CC433EF;
	Mon,  3 Apr 2023 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533443;
	bh=4a3ztiUrQ+f6Igs57SLsrvIjOa9ukdXV8dRBXD7oQPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWeBXmFVnE0lVi8qlHZbJAmsruG6atOAnrjRmmBoRcBQ/19opvr0mmmKr88pfG+ag
	 YJ9meo/JiE93sCU222wkjlpKEU21IehcU+hgDou5sd7voqNhm/mRUJPmOO24mTaL3N
	 duZgzcya472vDfkmAdvA4RMiF3bNb6cqDSmiefso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Currey <ruscur@russell.cc>,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.2 156/187] powerpc/64s: Fix __pte_needs_flush() false positive warning
Date: Mon,  3 Apr 2023 16:10:01 +0200
Message-Id: <20230403140421.220397605@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Gray <bgray@linux.ibm.com>

commit 1abce0580b89464546ae06abd5891ebec43c9470 upstream.

Userspace PROT_NONE ptes set _PAGE_PRIVILEGED, triggering a false
positive debug assertion that __pte_flags_need_flush() is not called
on a kernel mapping.

Detect when it is a userspace PROT_NONE page by checking the required
bits of PAGE_NONE are set, and none of the RWX bits are set.
pte_protnone() is insufficient here because it always returns 0 when
CONFIG_NUMA_BALANCING=n.

Fixes: b11931e9adc1 ("powerpc/64s: add pte_needs_flush and huge_pmd_needs_flush")
Cc: stable@vger.kernel.org # v6.1+
Reported-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230302225947.81083-1-bgray@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/book3s/64/tlbflush.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/tlbflush.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush.h
@@ -148,6 +148,11 @@ static inline void flush_tlb_fix_spuriou
 	 */
 }
 
+static inline bool __pte_protnone(unsigned long pte)
+{
+	return (pte & (pgprot_val(PAGE_NONE) | _PAGE_RWX)) == pgprot_val(PAGE_NONE);
+}
+
 static inline bool __pte_flags_need_flush(unsigned long oldval,
 					  unsigned long newval)
 {
@@ -164,8 +169,8 @@ static inline bool __pte_flags_need_flus
 	/*
 	 * We do not expect kernel mappings or non-PTEs or not-present PTEs.
 	 */
-	VM_WARN_ON_ONCE(oldval & _PAGE_PRIVILEGED);
-	VM_WARN_ON_ONCE(newval & _PAGE_PRIVILEGED);
+	VM_WARN_ON_ONCE(!__pte_protnone(oldval) && oldval & _PAGE_PRIVILEGED);
+	VM_WARN_ON_ONCE(!__pte_protnone(newval) && newval & _PAGE_PRIVILEGED);
 	VM_WARN_ON_ONCE(!(oldval & _PAGE_PTE));
 	VM_WARN_ON_ONCE(!(newval & _PAGE_PTE));
 	VM_WARN_ON_ONCE(!(oldval & _PAGE_PRESENT));


