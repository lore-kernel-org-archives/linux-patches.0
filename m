Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9F610795;
	Sat,  3 Feb 2024 04:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933324; cv=none; b=XsD1T36JsOJqdP4FFrujQsRbbAxkblRikHLjGLtA+WP9OYHWE3DLB7zVuQanAshEu5QXCNyObgxWlZwmT9OfFVU/WW5QHJqdswEC8o64uSsom+UCt1lDQyueIyeyt7C3vTrTq9gLm5O1kgvA32vhqBkb0eNWwFAO9Ss3jVC4c70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933324; c=relaxed/simple;
	bh=WLsa5LJFKK63KFV8uHL1/7H0KwbJpgTFJgv/te90Egs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtojUDGg21AgjpK2RtvEtyQ4hmZuUyv73i6iSBw6hcu0LT60QNcxsB8O9rzM0wh2KnTEgY0bPr8BZ3T3lVcaLwRLSux84YxNH4aLCOtTYwUsh+cvFm/nqkq6lKT9XF9ZLI4y7nsAX+Jx/eWM8Gc32Vqn7XY6JZ0I8wd3BjAy1Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmpAi6VC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmpAi6VC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08599C43390;
	Sat,  3 Feb 2024 04:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933324;
	bh=WLsa5LJFKK63KFV8uHL1/7H0KwbJpgTFJgv/te90Egs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmpAi6VCJrzg/7Wyd24+LQkrXWSzR1hbYfjY5HcJbXnopjboXA67rnV/s1cAqW6L3
	 7kHag8sYucOBn9QYOkecGW9jGJvumDCSsxh+/EYhVULJBC2QXBr7BA4nZBLr7lKYkg
	 s3w9sn/Qn6Une/rRKGX4AnflB7T/xH0bWH4BEHWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/219] powerpc: pmd_move_must_withdraw() is only needed for CONFIG_TRANSPARENT_HUGEPAGE
Date: Fri,  2 Feb 2024 20:03:02 -0800
Message-ID: <20240203035318.178049201@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Stephen Rothwell <sfr@canb.auug.org.au>

[ Upstream commit 0d555b57ee660d8a871781c0eebf006e855e918d ]

The linux-next build of powerpc64 allnoconfig fails with:

  arch/powerpc/mm/book3s64/pgtable.c:557:5: error: no previous prototype for 'pmd_move_must_withdraw'
    557 | int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
        |     ^~~~~~~~~~~~~~~~~~~~~~

Caused by commit:

  c6345dfa6e3e ("Makefile.extrawarn: turn on missing-prototypes globally")

Fix it by moving the function definition under
CONFIG_TRANSPARENT_HUGEPAGE like the prototype. The function is only
called when CONFIG_TRANSPARENT_HUGEPAGE=y.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
[mpe: Flesh out change log from linux-next patch]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231127132809.45c2b398@canb.auug.org.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index f6151a589298..87aa76c73799 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -463,6 +463,7 @@ void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
 	set_pte_at(vma->vm_mm, addr, ptep, pte);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * For hash translation mode, we use the deposited table to store hash slot
  * information and they are stored at PTRS_PER_PMD offset from related pmd
@@ -484,6 +485,7 @@ int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
 
 	return true;
 }
+#endif
 
 /*
  * Does the CPU support tlbie?
-- 
2.43.0



