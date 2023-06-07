Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50C2171B9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F513C433D2;
	Wed,  7 Jun 2023 20:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169995;
	bh=lPkjKh3VSeD7zFOib0sRqqqhSihnZ3Mqhs4DaI2r1xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVBVyzCucoTKg6jQu3CDMwcs9ZIIuu1DiYwJdGnystRDTWg0ASiSxGYRBwVs4Looh
	 i5LUBL3rmUcKCsiHd9VAFi6asu/zz45h4P8blYitaAEaZCd4ahf033ALa6XM7Cv/iL
	 S+gNcS7ViOzoCiRTFCnLsffvD56duIhM8CClybHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	kernel test robot <lkp@intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.3 265/286] serial: cpm_uart: Fix a COMPILE_TEST dependency
Date: Wed,  7 Jun 2023 22:16:04 +0200
Message-ID: <20230607200931.965665292@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herve Codina <herve.codina@bootlin.com>

commit 7183c37fd53eee1e795206e625da12a5d7ec1e1a upstream.

In a COMPILE_TEST configuration, the cpm_uart driver uses symbols from
the cpm_uart_cpm2.c file. This file is compiled only when CONFIG_CPM2 is
set.

Without this dependency, the linker fails with some missing symbols for
COMPILE_TEST configuration that needs SERIAL_CPM without enabling CPM2.

This lead to:
  depends on CPM2 || CPM1 || (PPC32 && CPM2 && COMPILE_TEST)

This dependency does not make sense anymore and can be simplified
removing all the COMPILE_TEST part.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202305160221.9XgweObz-lkp@intel.com/
Fixes: e3e7b13bffae ("serial: allow COMPILE_TEST for some drivers")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230523085902.75837-3-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig             |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -769,7 +769,7 @@ config SERIAL_PMACZILOG_CONSOLE
 
 config SERIAL_CPM
 	tristate "CPM SCC/SMC serial port support"
-	depends on CPM2 || CPM1 || (PPC32 && COMPILE_TEST)
+	depends on CPM2 || CPM1
 	select SERIAL_CORE
 	help
 	  This driver supports the SCC and SMC serial ports on Motorola 
--- a/drivers/tty/serial/cpm_uart/cpm_uart.h
+++ b/drivers/tty/serial/cpm_uart/cpm_uart.h
@@ -19,8 +19,6 @@ struct gpio_desc;
 #include "cpm_uart_cpm2.h"
 #elif defined(CONFIG_CPM1)
 #include "cpm_uart_cpm1.h"
-#elif defined(CONFIG_COMPILE_TEST)
-#include "cpm_uart_cpm2.h"
 #endif
 
 #define SERIAL_CPM_MAJOR	204


