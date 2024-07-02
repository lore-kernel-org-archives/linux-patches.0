Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999FD1514DC;
	Tue,  2 Jul 2024 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941276; cv=none; b=hPPvluUvcqUSAjPjhCDzKXILkzQQTJamIoLFqcQg3SzORC9gxoP/NKWyHPu1iLMCQFrGamUyQ53Yz4b9gbdY5qHOJBO2rK3NVJHPyx2Hmko1npIctrgv5mvlChJVgwxGGv/yzF1wE9pFiDelwmPFmTqrV4dYjSO3S/0JqUkSXRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941276; c=relaxed/simple;
	bh=jIiCtRmv8ic+3ZED3Se9WBYSU5ekVMRSLSxOKhgg7fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8k4Q49NC7df5MBAOutPTQXptD38tm+UvqkAXPsegsADUFbkb2R/rtSTJaen8wDgELZasPlXkDChtEiS0YzDpYp29sviMleIGugDICkz4Y9pZoy6shJhJpppsd4x5AezRZBzeFpqasytk9+/2QCgW1j70MP6EhwQCEZvL04c7AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7p0Z4zY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7p0Z4zY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097B3C116B1;
	Tue,  2 Jul 2024 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941276;
	bh=jIiCtRmv8ic+3ZED3Se9WBYSU5ekVMRSLSxOKhgg7fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7p0Z4zYppzE6rLvnAsPqR+cvqpLWJyhKw+vmrd3e+Y11iRvhpFhV0dDRoI8nQPVO
	 i2vUCCBp9wyi9pDxNeNsCMpDp31Iq2DtbMBvjCj9Qwcdw2A6HG6HHfKIhErRA6wGhZ
	 wFYkDG5i5W/BbyhCrU9F42Nnj4TZaL5nFXCRguK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/128] s390/pci: Add missing virt_to_phys() for directed DIBV
Date: Tue,  2 Jul 2024 19:03:38 +0200
Message-ID: <20240702170226.882936240@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 4181b51c38875de9f6f11248fa0bcf3246c19c82 ]

In commit 4e4dc65ab578 ("s390/pci: use phys_to_virt() for AIBVs/DIBVs")
the setting of dibv_addr was missed when adding virt_to_phys(). This
only affects systems with directed interrupt delivery enabled which are
not generally available.

Fixes: 4e4dc65ab578 ("s390/pci: use phys_to_virt() for AIBVs/DIBVs")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index a2b42a63a53ba..04c19ab93a329 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -410,7 +410,7 @@ static void __init cpu_enable_directed_irq(void *unused)
 	union zpci_sic_iib iib = {{0}};
 	union zpci_sic_iib ziib = {{0}};
 
-	iib.cdiib.dibv_addr = (u64) zpci_ibv[smp_processor_id()]->vector;
+	iib.cdiib.dibv_addr = virt_to_phys(zpci_ibv[smp_processor_id()]->vector);
 
 	zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
 	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC, &ziib);
-- 
2.43.0



