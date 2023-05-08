Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39120168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9401C433D2;
	Mon,  8 May 2023 10:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540692;
	bh=SxUftKJw/GKVYCHQuGZfbtFRx+0YwclD867MgIK+Cfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wg6Wz6vOqowx05NyqOIBnbTEwv1hrZtoIEId2q+IBB4Z2sYz5oPmhYYbAPW8BTlnK
	 Ess2VZRm9BX8IrL3a/LBn0NTHPe1Y2xvXwabK9XNpE/Mwasd/cSDxR4iwVxD5pwXFJ
	 GP5cszR8VkqFzHAWZ0re0jd5F18nCZbIsXKIhuuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 462/611] powerpc/sysdev/tsi108: fix resource printk format warnings
Date: Mon,  8 May 2023 11:45:04 +0200
Message-Id: <20230508094437.160462944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 55d8bd02cc1b9f1063993b5c42c9cabf4af67dea ]

Use "%pa" format specifier for resource_size_t to avoid a compiler
printk format warning.

  arch/powerpc/sysdev/tsi108_pci.c: In function 'tsi108_setup_pci':
  include/linux/kern_levels.h:5:25: error: format '%x' expects argument of type 'unsigned int', but argument 2 has type 'resource_size_t'

Fixes: c4342ff92bed ("[POWERPC] Update mpc7448hpc2 board irq support using device tree")
Fixes: 2b9d7467a6db ("[POWERPC] Add tsi108 pci and platform device data register function")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
[mpe: Use pr_info() and unsplit string]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230223070116.660-5-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/tsi108_pci.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
index 5af4c35ff5842..0e42f7bad7db1 100644
--- a/arch/powerpc/sysdev/tsi108_pci.c
+++ b/arch/powerpc/sysdev/tsi108_pci.c
@@ -217,9 +217,8 @@ int __init tsi108_setup_pci(struct device_node *dev, u32 cfg_phys, int primary)
 
 	(hose)->ops = &tsi108_direct_pci_ops;
 
-	printk(KERN_INFO "Found tsi108 PCI host bridge at 0x%08x. "
-	       "Firmware bus number: %d->%d\n",
-	       rsrc.start, hose->first_busno, hose->last_busno);
+	pr_info("Found tsi108 PCI host bridge at 0x%pa. Firmware bus number: %d->%d\n",
+		&rsrc.start, hose->first_busno, hose->last_busno);
 
 	/* Interpret the "ranges" property */
 	/* This also maps the I/O region and sets isa_io/mem_base */
-- 
2.39.2



