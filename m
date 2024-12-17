Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422A1F869D;
	Tue, 17 Dec 2024 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456692; cv=none; b=YWOC1YSsnnvERtRC0/CeSylJGQkJTX2GVL0GuHeWTJkF+KvbaR9btIOatG2R5+xoqX5iSPw1iz5wjaJ1z4aQCPed2BgsGGdxcjudIIUg35Y79oPl0uy2KtBqpcsuOJNhjIReY3/XWz75uYy6kQOO8u29U0RDOIt1m1xzjeZjwLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456692; c=relaxed/simple;
	bh=0CmiT/4ANLNPsjtC2UnrfqXUVNBVg99L2BzS0s8a1EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSDb4d+3gT/kna7zvaUmXBCTzTsmf5lwulOkNyOEq6vVbVRzt7fsZeJTEwOuVtAIpm9QuH7BqlkUeDtoB8cOr4yLzMx79Lp+5WLS1C31LU7/UG3ToR3YtrsRyvO/DUY5nn1mTDGDGLeWKZgDkZrYEW2uIi4HJcD9+md7rN94OxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikrNzrAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikrNzrAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A09C4CED3;
	Tue, 17 Dec 2024 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456692;
	bh=0CmiT/4ANLNPsjtC2UnrfqXUVNBVg99L2BzS0s8a1EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikrNzrAdSbl9TL/bIMcjihsysL/KjCwYto5cPEHnbHcDSd+X+d7dEHD4YdDWHLLke
	 7Dl+4GP+QODXIxR35XcAkwcvIBG2QUusSOeH2fMDg2NLPEDW1DFSF9lzLJOkhxkH6k
	 cu0WhjyjrHS4BYrBuOtqYvcocMB+cuv4LQefr3gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Yury Norov <yury.norov@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/172] net: mana: Fix irq_contexts memory leak in mana_gd_setup_irqs
Date: Tue, 17 Dec 2024 18:08:13 +0100
Message-ID: <20241217170552.020009869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 9a5beb6ca6305de5c5210efab0702ea79b62eb39 ]

gc->irq_contexts is not freeded if one of the later operations
fail.

Suggested-by: Michael Kelley <mhklinux@outlook.com>
Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Link: https://patch.msgid.link/20241209175751.287738-3-mlevitsk@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 42076c90ce87..0c2ba2fa88c4 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1315,7 +1315,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 				   GFP_KERNEL);
 	if (!gc->irq_contexts) {
 		err = -ENOMEM;
-		goto free_irq_vector;
+		goto free_irq_array;
 	}
 
 	for (i = 0; i < nvec; i++) {
@@ -1385,8 +1385,9 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	}
 
 	kfree(gc->irq_contexts);
-	kfree(irqs);
 	gc->irq_contexts = NULL;
+free_irq_array:
+	kfree(irqs);
 free_irq_vector:
 	cpus_read_unlock();
 	pci_free_irq_vectors(pdev);
-- 
2.39.5



