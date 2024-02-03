Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA1E13AE8;
	Sat,  3 Feb 2024 04:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933484; cv=none; b=Ni0/pp1bWMtN/3N/PZAz3Mq/t5/u3Rz5/6No/sbuoma8O5eFKwLs0atyZ66k/wXxFhTdGDtNk3g3T7rbFkp15baI5ygBsA8JmogZ4Tm7fRQVcZbmQpHCxrpqXVoec6KniVZn8PSLreLmBhGigkP789F/np2ngRKtRzHwLQhrk5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933484; c=relaxed/simple;
	bh=pIwvqUUAFkNR5FxwVZNPi0K4aVlASyWMPWwuFGStKNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7mLEfrWATpGRz7SUwJzGO+TKge7uwNdGHTLH5Kjrc/4BRn8fbDJXPpVLruXjPsrsd2cg+7RbLr22VpGHrI93Un8YYY14BtTteSsh5RpmPxFag02yEPFczTg/h2S9z3YsdGzMVKBp+FV3yDlVFNuEh8JNMqJ/06T5P7ypFePc2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glMBCYic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glMBCYic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFD1C433C7;
	Sat,  3 Feb 2024 04:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933484;
	bh=pIwvqUUAFkNR5FxwVZNPi0K4aVlASyWMPWwuFGStKNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glMBCYicH5vrKOmxxWUjrZS74ojAO/Iug1jYYnm1e4uk6MbWBeoFaykL1Wfuem2Nr
	 zCaRdLJeL2qee9YsX2Y3+goe09IjwN9XVe9uK+foUGNXlG/R35anFN3VtCdmhxkkoi
	 ozUos9apotPskTz9440C+l0ScTUfv1WWOsGWjMQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/322] powerpc: pmd_move_must_withdraw() is only needed for CONFIG_TRANSPARENT_HUGEPAGE
Date: Fri,  2 Feb 2024 20:01:47 -0800
Message-ID: <20240203035359.387356357@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index 8f8a62d3ff4d..926bec775f41 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -542,6 +542,7 @@ void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
 	set_pte_at(vma->vm_mm, addr, ptep, pte);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * For hash translation mode, we use the deposited table to store hash slot
  * information and they are stored at PTRS_PER_PMD offset from related pmd
@@ -563,6 +564,7 @@ int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
 
 	return true;
 }
+#endif
 
 /*
  * Does the CPU support tlbie?
-- 
2.43.0



