Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DA124B34;
	Tue, 25 Jun 2024 09:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309154; cv=none; b=tP5BxA7Fdt2XUvJMOM+2wWXDD9BoOIPx7XY5apSeWpEZCNOt5Qx/8tWHMVug5oPlGD78u7ukTrfeEhk/NY+jvVL1i//aiqRr8bMgNXa86srTHbfiIPeGsOuN7dqdj9jymJlWj4LgvNU8zIzvzNPr6JehkvO6ufNoC/ZFNAJ/BAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309154; c=relaxed/simple;
	bh=jMAWnpMbik+hYKwmKwbJIG4VspeBM967bSnHJZPq9b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcEx7sHVM+tuzgOriE4tiBrGsTgTh77+Ol6YSCJ9MaVEKjN4stVL1ij7MI50YUxXwIvQ4KNaEnUN6B7y4hYc4SLHiL+hOAhbDGdeqPnJybSS9IQlNEBqW3wiG46q7xMU5qf+cApL57/CQRlLgyadXKrAWhwPgwpW7yUhj/CTEds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/8mD4Gx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/8mD4Gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4B4C32789;
	Tue, 25 Jun 2024 09:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309154;
	bh=jMAWnpMbik+hYKwmKwbJIG4VspeBM967bSnHJZPq9b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/8mD4Gx0B20hboS6fhDKdHQhhcpoAG2PwvOUxBus2vBAOX3igQY++2jr9KLRAnYk
	 /QQhI12untH2Hbbm42qJ0tcwrmEUd3r8aVgG+rsOOr86TY7gKrlo/e4D942RI2QGU+
	 pfDX+w6F0j7ylH6aU5Kg9+XnXnS8bbgr56QdIleo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Peng Fan <peng.fan@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/192] dmaengine: fsl-edma: avoid linking both modules
Date: Tue, 25 Jun 2024 11:33:04 +0200
Message-ID: <20240625085541.470480632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fa555b5026d0bf1ba7c9e645ff75e2725a982631 ]

Kbuild does not support having a source file compiled multiple times
and linked into distinct modules, or built-in and modular at the
same time. For fs-edma, there are two common components that are
linked into the fsl-edma.ko for Arm and PowerPC, plus the mcf-edma.ko
module on Coldfire. This violates the rule for compile-testing:

scripts/Makefile.build:236: drivers/dma/Makefile: fsl-edma-common.o is added to multiple modules: fsl-edma mcf-edma
scripts/Makefile.build:236: drivers/dma/Makefile: fsl-edma-trace.o is added to multiple modules: fsl-edma mcf-edma

I tried splitting out the common parts into a separate modules, but
that adds back the complexity that a cleanup patch removed, and it
gets harder with the addition of the tracepoints.

As a minimal workaround, address it at the Kconfig level, by disallowing
the broken configurations.

Link: https://lore.kernel.org/lkml/20240110232255.1099757-1-arnd@kernel.org/
Fixes: 66aac8ea0a6c ("dmaengine: fsl-edma: clean up EXPORT_SYMBOL_GPL in fsl-edma-common.c")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20240528115440.2965975-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 7a618f629e86b..e36506471a4f6 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -380,7 +380,7 @@ config LPC18XX_DMAMUX
 
 config MCF_EDMA
 	tristate "Freescale eDMA engine support, ColdFire mcf5441x SoCs"
-	depends on M5441x || COMPILE_TEST
+	depends on M5441x || (COMPILE_TEST && FSL_EDMA=n)
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.43.0



