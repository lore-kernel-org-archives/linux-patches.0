Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B8F34CF6
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA79C433EF;
	Wed,  7 Jun 2023 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169211;
	bh=AGdFKM+aPJQvYlx2mK3yLpKN+vHrAjQ0ANWT2/LEmpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3xd0F4LldmezVNZ67+k+y5zh+TYZK+kzw8HK48qjigSRdyMUJ2NFoGIa4YiG9eD2
	 M7hgy4OW0lPrZGB4Vel/3SgQSuwNwgk+zp1VVi/7kbW7zLkA37EO0i1acbcqR5dFry
	 G4mMdDHsXNmTMgoTlEb928I3rZ+2TkDDGX+HPFaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 4.14 56/61] scsi: dpt_i2o: Do not process completions with invalid addresses
Date: Wed,  7 Jun 2023 22:16:10 +0200
Message-ID: <20230607200854.517010396@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Hutchings <benh@debian.org>

adpt_isr() reads reply addresses from a hardware register, which
should always be within the DMA address range of the device's pool of
reply address buffers.  In case the address is out of range, it tries
to muddle on, converting to a virtual address using bus_to_virt().

bus_to_virt() does not take DMA addresses, and it doesn't make sense
to try to handle the completion in this case.  Ignore it and continue
looping to service the interrupt.  If a completion has been lost then
the SCSI core should eventually time-out and trigger a reset.

There is no corresponding upstream commit, because this driver was
removed upstream.

Fixes: 67af2b060e02 ("[SCSI] dpt_i2o: move from virt_to_bus/bus_to_virt ...")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/Kconfig   |    2 +-
 drivers/scsi/dpt_i2o.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -480,7 +480,7 @@ config SCSI_MVUMI
 
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
-	depends on SCSI && PCI && VIRT_TO_BUS
+	depends on SCSI && PCI
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -59,7 +59,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 
 #include <asm/processor.h>	/* for boot_cpu_data */
 #include <asm/pgtable.h>
-#include <asm/io.h>		/* for virt_to_bus, etc. */
+#include <asm/io.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1912,7 +1912,7 @@ static irqreturn_t adpt_isr(int irq, voi
 		} else {
 			/* Ick, we should *never* be here */
 			printk(KERN_ERR "dpti: reply frame not from pool\n");
-			reply = (u8 *)bus_to_virt(m);
+			continue;
 		}
 
 		if (readl(reply) & MSG_FAIL) {


