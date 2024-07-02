Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE5F178381;
	Tue,  2 Jul 2024 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940000; cv=none; b=ucio9V/lup8KiA25BfBsVJZZk/f59DqpPVkOvqom5yqraVQGHQPMxU9Z+dBx67VUBkXoIdIHfKVRUS2CovaJk4DWwOH6h9j7sB2p/QoAQcbFY1YZ9Ct71wPh8T3IxK94j++XIjAMEH9fhwm1WVs+/MwsVi9w+I3pqmIFI0KV7BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940000; c=relaxed/simple;
	bh=YaPn7TODEsyVPuOLrTbyRa0NFj0pv0ThxeO2soIb/zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJypFHSP5bDueilLqQmIfQsR9VHW/nfFskS1eBmwA3msbXue+Knbd5qWcuzCYVGVWH+xGgFitz0Kk27q3mhA1pExVKa066B47e6mRqky/PUWWOMpsCVKUNVjHkNtyKE6CyeIOuEeAvSEkMur+rzdJRgaRgU+FgRDEsBNB39HvUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Fb/BeSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Fb/BeSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD273C116B1;
	Tue,  2 Jul 2024 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940000;
	bh=YaPn7TODEsyVPuOLrTbyRa0NFj0pv0ThxeO2soIb/zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Fb/BeSiMJ8JcD/rbOhCywQsZR4U5Xy/sb0sbXn6njjKsHHbaOTfqq2eQedwN1SEz
	 ZnVioYez2lR7+TUgMmnB2R8I/Am056jUVBf9T5puxW0JvUQtfKsa8eRFtQ9zQbThV5
	 OT4jpsd1MsQs/1fLULNO+GqbtXvmcc7yqn1RoJ54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 023/222] s390/pci: Add missing virt_to_phys() for directed DIBV
Date: Tue,  2 Jul 2024 19:01:01 +0200
Message-ID: <20240702170244.864730821@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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
index ff8f24854c646..0ef83b6ac0db7 100644
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



