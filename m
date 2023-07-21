Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D55D1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C033EC433C7;
	Fri, 21 Jul 2023 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965511;
	bh=bGvb9m5hfSBfblqZwT2BLLZz59LqgK14tLdHU4nTY9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ke5PDp+uE6b+gEiBzqDzR9ks+2WGju2UkouWFuL9cdj22W+pYsf9cawCoEDeyGyX5
	 nCDOxejQxJ/Uc1UgxCjJs23kgc9S+dDWTsKsjBaeU55KjxxI02lN0IWFNyFVLyb2ct
	 3x6mvi+QIlJQXBQkSh83HIZPfVIzzHMFqPeaOTok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/532] powercap: RAPL: Fix CONFIG_IOSF_MBI dependency
Date: Fri, 21 Jul 2023 17:58:41 +0200
Message-ID: <20230721160615.606577025@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 4658fe81b3f8afe8adf37734ec5fe595d90415c6 ]

After commit 3382388d7148 ("intel_rapl: abstract RAPL common code"),
accessing to IOSF_MBI interface is done in the RAPL common code.

Thus it is the CONFIG_INTEL_RAPL_CORE that has dependency of
CONFIG_IOSF_MBI, while CONFIG_INTEL_RAPL_MSR does not.

This problem was not exposed previously because all the previous RAPL
common code users, aka, the RAPL MSR and MMIO I/F drivers, have
CONFIG_IOSF_MBI selected.

Fix the CONFIG_IOSF_MBI dependency in RAPL code. This also fixes a build
time failure when the RAPL TPMI I/F driver is introduced without
selecting CONFIG_IOSF_MBI.

x86_64-linux-ld: vmlinux.o: in function `set_floor_freq_atom':
intel_rapl_common.c:(.text+0x2dac9b8): undefined reference to `iosf_mbi_write'
x86_64-linux-ld: intel_rapl_common.c:(.text+0x2daca66): undefined reference to `iosf_mbi_read'

Reference to iosf_mbi.h is also removed from the RAPL MSR I/F driver.

Fixes: 3382388d7148 ("intel_rapl: abstract RAPL common code")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/all/20230601213246.3271412-1-arnd@kernel.org
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/Kconfig          | 4 +++-
 drivers/powercap/intel_rapl_msr.c | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/powercap/Kconfig b/drivers/powercap/Kconfig
index 8242e8c5ed77e..503797b2a1c69 100644
--- a/drivers/powercap/Kconfig
+++ b/drivers/powercap/Kconfig
@@ -18,10 +18,12 @@ if POWERCAP
 # Client driver configurations go here.
 config INTEL_RAPL_CORE
 	tristate
+	depends on PCI
+	select IOSF_MBI
 
 config INTEL_RAPL
 	tristate "Intel RAPL Support via MSR Interface"
-	depends on X86 && IOSF_MBI
+	depends on X86 && PCI
 	select INTEL_RAPL_CORE
 	help
 	  This enables support for the Intel Running Average Power Limit (RAPL)
diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index 1be45f36ab6cd..c19e69e77093b 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -22,7 +22,6 @@
 #include <linux/processor.h>
 #include <linux/platform_device.h>
 
-#include <asm/iosf_mbi.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 
-- 
2.39.2



