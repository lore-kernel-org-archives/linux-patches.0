Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4713ACEFE;
	Mon, 17 Aug 2026 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978106; cv=none; b=eJZ3GBBJUFVc/cz9LR0RCNS/99wOlgEw244vZRpk5wYAN8DWa5t7IlcQFpwnDfJ/+juJIADYzM4wrc9HO7OKuHhwbi7P6dYuZHCcwO9idvVAf9jqAOxiMYQPqWvfXGoJet+bFbdoe36tI1RNgV7A2SBXLohvNECGY6OwvNq7xic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978106; c=relaxed/simple;
	bh=fKiLLKSBZqXTd5iAXQfS8HW2eHmkREULI8ElCbFS/Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn5bQm294DqLlTqC/XfCDA4J2Ptnql6xrM4F5PME9xo0y8r0NTXgL4bD+pOU/I8QoNmwEO/3006kZ68Xrl/m/OYz/DPaAnjMe+gM9d5brrAkQg47DV9m18WhYL5KL9RUMvKujssupMHmn/o83LS1qbScjapL75p5+8EL3HROMvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DATqdWNJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DATqdWNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9744B1F000E9;
	Mon, 17 Aug 2026 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978105;
	bh=F9zzQxTM5o2642fNAlqnX2SJLi8hU0IejG85u5yaYDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DATqdWNJ7eLZwT5Bm6/J0xk5ra02XxDWk950m7e3wDziOmIeiKAk2UYV4JPfx46w9
	 Q+0iiookNV+NC79gSzlagq6lHLII9xDcKWiA/u566/XoikUJ3bEfPotBJLePTScqWD
	 3IbKkiwAC0dR/rNnGcbTUwBD+z9GSk4Sf6JvYMs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/181] KVM: s390: pci: Fix missing error codes and memory unaccounting
Date: Mon, 17 Aug 2026 15:33:17 +0200
Message-ID: <20260817132539.527982609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farhan Ali <alifm@linux.ibm.com>

[ Upstream commit f86842e4d6c482300f4567f492d512c9ccf5bc4f ]

In kvm_s390_pci_aif_enable() two error paths failed to set an error code,
causing the function to return 0 on failure. It also failed to rollback
memory accounting on failure. Fix both by propagating an error code on
failure and calling unaccount_mem() in the cleanup path.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[alifm@linux.ibm.com: Resolve merge conflict]
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index f887e11b0f1ef..a20fa27fa0301 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -315,14 +315,17 @@ static int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
 	}
 
 	/* Account for pinned pages, roll back on failure */
-	if (account_mem(zdev->kzdev, pcount))
+	rc = account_mem(zdev->kzdev, pcount);
+	if (rc)
 		goto unpin2;
 
 	/* AISB must be allocated before we can fill in GAITE */
 	mutex_lock(&aift->aift_lock);
 	bit = airq_iv_alloc_bit(aift->sbv);
-	if (bit == -1UL)
+	if (bit == -1UL) {
+		rc = -ENOMEM;
 		goto unlock;
+	}
 	zdev->aisb = bit; /* store the summary bit number */
 	zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
 				    AIRQ_IV_BITLOCK |
@@ -374,6 +377,8 @@ static int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
 	airq_iv_free_bit(aift->sbv, zdev->aisb);
 	zdev->aisb = 0;
 unlock:
+	if (pcount > 0)
+		unaccount_mem(zdev->kzdev, pcount);
 	mutex_unlock(&aift->aift_lock);
 unpin2:
 	if (fib->fmt0.sum == 1)
-- 
2.53.0



