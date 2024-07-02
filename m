Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4542E1BE251;
	Tue,  2 Jul 2024 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940748; cv=none; b=d3zz1Vc9sTurjyLs37+6psQRPOWZC9SEpZbZcpDll+LbbPW2RzAlAladZ/1rofJn3ud1/PurSRZ6aOQbvAUMAX5mbBrU6l1glgO7WTsi6RT9MpRoo+TQhttCK1YiRK7KRoeosn56oZaRCj0gUgAVdl4zHoqYnkDryUAxQGFjRN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940748; c=relaxed/simple;
	bh=AdVD32OE+hepq/QCA+91GMCrcRqzNZTENsq2x+4p9EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Artt9AKEVWBKpDMwAbrTW68kdTJ9aknx+FKoR3+cczh2YGk+Re6yHU7x0V44ZfS5SZcQ7rB4LcO7VsLFggZ52xnDBTRdLlp9UoeFyONgk/wjSgI7S0rUkpcseYR3qDKoYUk2nFIvDDkuYNqeCfBnNIWBEx6hqTqBIhZQhvxN3R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFOXRO4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFOXRO4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAFAC116B1;
	Tue,  2 Jul 2024 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940748;
	bh=AdVD32OE+hepq/QCA+91GMCrcRqzNZTENsq2x+4p9EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFOXRO4Px1H4HHhZhL6+zZIXPzQplIiGqt5lnCl4fy0R4Pxh4s2JHAfOhC+DAVDNl
	 oFPdNZwe9+JhQxhaeomjmcKoqJFdviwcjjHTmrokrL6uuepED4NtJSms6VV7YIi5n8
	 Kt7sozoX2lK4k26z/LrUU4WMjnWh8onAqyAsKObw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/163] s390/pci: Add missing virt_to_phys() for directed DIBV
Date: Tue,  2 Jul 2024 19:02:18 +0200
Message-ID: <20240702170233.974268823@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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



