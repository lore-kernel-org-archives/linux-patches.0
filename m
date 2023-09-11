Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883DFF9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D060BC433C8;
	Mon, 11 Sep 2023 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444702;
	bh=MANyaW5yfqYbm3mmACfEe//Xs06xOCs7FU8tkfuhkJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pikci2Ii+lyzo6i27N6IUQbBA+C84M2CzO1gOLz2N4G09dgfrf8oQ59uk9WUlkUqw
	 QU6XZTinzQu+nABybEMyk+GS9BTgpmFfhm+MhGAyMNOKrQYv3vQ+F5O/IHALNaKhYP
	 BdlmPHkavD6l/xt4S12q2qZjXL1hm1rjcnmTgq34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/600] powerpc/powermac: Use early_* IO variants in via_calibrate_decr()
Date: Mon, 11 Sep 2023 15:41:28 +0200
Message-ID: <20230911134635.246232708@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit 86582e6189dd8f9f52c25d46c70fe5d111da6345 ]

On a powermac platform, via the call path:

  start_kernel()
    time_init()
      ppc_md.calibrate_decr() (pmac_calibrate_decr)
        via_calibrate_decr()

ioremap() and iounmap() are called. The unmap can enable interrupts
unexpectedly (cond_resched() in vunmap_pmd_range()), which causes a
warning later in the boot sequence in start_kernel().

Use the early_* variants of these IO functions to prevent this.

The issue is pre-existing, but is surfaced by commit 721255b9826b
("genirq: Use a maple tree for interrupt descriptor management").

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230706010816.72682-1-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powermac/time.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index 4c5790aff1b54..8633891b7aa58 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -26,8 +26,8 @@
 #include <linux/rtc.h>
 #include <linux/of_address.h>
 
+#include <asm/early_ioremap.h>
 #include <asm/sections.h>
-#include <asm/io.h>
 #include <asm/machdep.h>
 #include <asm/time.h>
 #include <asm/nvram.h>
@@ -182,7 +182,7 @@ static int __init via_calibrate_decr(void)
 		return 0;
 	}
 	of_node_put(vias);
-	via = ioremap(rsrc.start, resource_size(&rsrc));
+	via = early_ioremap(rsrc.start, resource_size(&rsrc));
 	if (via == NULL) {
 		printk(KERN_ERR "Failed to map VIA for timer calibration !\n");
 		return 0;
@@ -207,7 +207,7 @@ static int __init via_calibrate_decr(void)
 
 	ppc_tb_freq = (dstart - dend) * 100 / 6;
 
-	iounmap(via);
+	early_iounmap((void *)via, resource_size(&rsrc));
 
 	return 1;
 }
-- 
2.40.1



