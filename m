Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC707E799;
	Wed, 21 Feb 2024 13:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522381; cv=none; b=LWTbLBWbI7SxMRC+CBfUYXMnWB/muGK2ChHJs4IfXkGs+FqE4ZIa7dky7z4YthTpPgNENJGh8Gzhs+MLM7sZNL4G2HI1E10SUpT/JCUo5+84Btu8Cs8gSlK8rPP/s+VAxl7lzpKpIHUONtjYpwYxIpAn1+Cz5RmknhMJQ2XIY58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522381; c=relaxed/simple;
	bh=4n2idOcEn0satVynBztMGD9stNJeY/BP+oTgLlvPTrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGNpq68lF7ie98qQ/5SRFSkWeyjx1oORQqnhT9SZkIm4pTXyHAPYH7Qe25fVdQraVpCFZUhkcgeY5xnXyPeXWmo1YdWtR4l26caPUywAe+b9SyR+CyXCgAUn7DTbzEvkEe0AUoViQ6QHCoxMzLeC405B1MO/mD0PgtaIeY7Sqdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeZyHwIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeZyHwIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14EFC433C7;
	Wed, 21 Feb 2024 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522381;
	bh=4n2idOcEn0satVynBztMGD9stNJeY/BP+oTgLlvPTrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeZyHwIqVJimkVlD7Byc+lyKS23XXF6LX3wmOMYsHYwLe6DI8mZw3z3jzZMcwAoCw
	 zjQL8m7GHesVrO2Q0qsIn17FrBR4D1k0O3+GlTHgj1frjrOpea8FpC7kD8lqR0Dsls
	 fyNfWSGFg1e4gKm/6XNrMo9+C++Hrsh3MxKW6cfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/476] spi: bcm-qspi: fix SFDP BFPT read by usig mspi read
Date: Wed, 21 Feb 2024 14:02:52 +0100
Message-ID: <20240221130012.449743614@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kamal.dasu@broadcom.com>

[ Upstream commit 574bf7bbe83794a902679846770f75a9b7f28176 ]

SFDP read shall use the mspi reads when using the bcm_qspi_exec_mem_op()
call. This fixes SFDP parameter page read failures seen with parts that
now use SFDP protocol to read the basic flash parameter table.

Fixes: 5f195ee7d830 ("spi: bcm-qspi: Implement the spi_mem interface")
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://msgid.link/r/20240109210033.43249-1-kamal.dasu@broadcom.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index c79797c06cda..bca7ac570b94 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -19,7 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/spi-mem.h>
+#include <linux/mtd/spi-nor.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 #include "spi-bcm-qspi.h"
@@ -1049,7 +1049,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 
 	/* non-aligned and very short transfers are handled by MSPI */
 	if (!IS_ALIGNED((uintptr_t)addr, 4) || !IS_ALIGNED((uintptr_t)buf, 4) ||
-	    len < 4)
+	    len < 4 || op->cmd.opcode == SPINOR_OP_RDSFDP)
 		mspi_read = true;
 
 	if (!has_bspi(qspi) || mspi_read)
-- 
2.43.0



