Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C828EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01389C433EF;
	Mon, 30 Jan 2023 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086872;
	bh=5NJsybIQghShMJ80Aq4V6CkfKgvFew4w0zo6WL8aNZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxDbFH8ySW5Zx1/W2spDDa1hh3Fbo12MSBeb+Q+NzG5EMUM8x0mtowZPlQ2pIiUrL
	 IulrpH5R15Y2w548PI8AC3FibldNDMlNzSLkLbwSWdjA9cG85IsVMItQmBlCd8DTGS
	 xLAobGNHMpSNAVxPKHQxBtSwHqtV2nTTAQ/TDgbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Nishanth Menon <nm@ti.com>,
	Tero Kristo <kristo@kernel.org>,
	Santosh Shilimkar <ssantosh@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/313] reset: ti-sci: honor TI_SCI_PROTOCOL setting when not COMPILE_TEST
Date: Mon, 30 Jan 2023 14:47:39 +0100
Message-Id: <20230130134337.783252262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 13678f3feb3009b23aab424864fd0dac0765c83e ]

There is a build error when COMPILE_TEST=y, TI_SCI_PROTOCOL=m,
and RESET_TI_SCI=y:

drivers/reset/reset-ti-sci.o: in function `ti_sci_reset_probe':
reset-ti-sci.c:(.text+0x22c): undefined reference to `devm_ti_sci_get_handle'

Fix this by making RESET_TI_SCI honor the Kconfig setting of
TI_SCI_PROTOCOL when COMPILE_TEST is not set. When COMPILE_TEST is set,
TI_SCI_PROTOCOL must be disabled (=n).

Fixes: a6af504184c9 ("reset: ti-sci: Allow building under COMPILE_TEST")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
Cc: Santosh Shilimkar <ssantosh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221030055636.3139-1-rdunlap@infradead.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index de176c2fbad9..2a52c990d4fe 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -257,7 +257,7 @@ config RESET_SUNXI
 
 config RESET_TI_SCI
 	tristate "TI System Control Interface (TI-SCI) reset driver"
-	depends on TI_SCI_PROTOCOL || COMPILE_TEST
+	depends on TI_SCI_PROTOCOL || (COMPILE_TEST && TI_SCI_PROTOCOL=n)
 	help
 	  This enables the reset driver support over TI System Control Interface
 	  available on some new TI's SoCs. If you wish to use reset resources
-- 
2.39.0



