Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CF01FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D32FC433C8;
	Tue,  1 Aug 2023 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882812;
	bh=Qpi9eaFEdR3YnrjHpaQ/MiiUXs1K1/UsPbiMmLPstxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1b1I3wjyCpJXtYbUcilhMpzl2CeSshghxpA5x2l4SKocLAOQhOhZRiR2gTEHBh80V
	 NNVdkaOGkO3jeURP7ANxkie2sEQ8jKPtpPOu1rUKuwaG7/RQbdH5RkQaDec2d1BQ04
	 08FFhwXtjz3upePZyoZoeqoYwfZ/U+jptyUnnsKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 012/239] s390/mm: fix per vma lock fault handling
Date: Tue,  1 Aug 2023 11:17:56 +0200
Message-ID: <20230801091926.095017700@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 7686762d1ed092db4d120e29b565712c969dc075 ]

With per-vma locks, handle_mm_fault() may return non-fatal error
flags. In this case the code should reset the fault flags before
returning.

Fixes: e06f47a16573 ("s390/mm: try VMA lock-based page fault handling first")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index dbe8394234e2b..2f123429a291b 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -421,6 +421,8 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 	vma_end_read(vma);
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		if (likely(!(fault & VM_FAULT_ERROR)))
+			fault = 0;
 		goto out;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
-- 
2.39.2



