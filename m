Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791AE82495;
	Wed, 19 Jun 2024 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803087; cv=none; b=c4ikPeu0kEQPWGgCbGDZUlUiT8eDEoCrgeij5x5d8UCLXVwJPjbx3MHysQm/xPNIk8gFiu/hkXGRAyviCng03cW4Ep7nM0v03nrGdjN7NgCU2ARK7MCIAH2IwhB/+DFjx4nVrvYhm+qMkJ8i9v1RY0+hxm7MP2hUNDj6Tc/EbNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803087; c=relaxed/simple;
	bh=eB03x//NAGjdUJPaKSXpT9ygldJCVFnxjIFBKID96SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uislZlFNkQQsw3zWuYxvEMHQyiMCO/ymCVw3Pfv7WKYZBfnARR1GfjbkKTDiWBT66/j2WE9eBZZh1fMxihtTGpJZ78LPtTaG903c7k2gPq1ONrcY1dK9XVl7Jz23vTEkNdc1LKNvgSYh+o9k1BHJairyynhCglqhpSOgj6rx3tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5nqa33h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5nqa33h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F11C2BBFC;
	Wed, 19 Jun 2024 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803087;
	bh=eB03x//NAGjdUJPaKSXpT9ygldJCVFnxjIFBKID96SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5nqa33hEKjCu/SJKZO0m0uLGqgnGUmD5bWhQYo3UgyepAQROMBFILi2R83YfB4AV
	 JHYjEQ4kSoH4ztf1uHkL9beS4Q0vpdGAQgQSNtK3Du6jtfc9alcxJXxDl2GoUr4kh+
	 Ju9CNrU25C6DSXhBNmcegV/W2AJwGXaQt00AnElU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 108/281] cxl/test: Add missing vmalloc.h for tools/testing/cxl/test/mem.c
Date: Wed, 19 Jun 2024 14:54:27 +0200
Message-ID: <20240619125614.005010510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit d55510527153d17a3af8cc2df69c04f95ae1350d ]

tools/testing/cxl/test/mem.c uses vmalloc() and vfree() but does not
include linux/vmalloc.h. Kernel v6.10 made changes that causes the
currently included headers not depend on vmalloc.h and therefore
mem.c can no longer compile. Add linux/vmalloc.h to fix compile
issue.

  CC [M]  tools/testing/cxl/test/mem.o
tools/testing/cxl/test/mem.c: In function ‘label_area_release’:
tools/testing/cxl/test/mem.c:1428:9: error: implicit declaration of function ‘vfree’; did you mean ‘kvfree’? [-Werror=implicit-function-declaration]
 1428 |         vfree(lsa);
      |         ^~~~~
      |         kvfree
tools/testing/cxl/test/mem.c: In function ‘cxl_mock_mem_probe’:
tools/testing/cxl/test/mem.c:1466:22: error: implicit declaration of function ‘vmalloc’; did you mean ‘kmalloc’? [-Werror=implicit-function-declaration]
 1466 |         mdata->lsa = vmalloc(LSA_SIZE);
      |                      ^~~~~~~
      |                      kmalloc

Fixes: 7d3eb23c4ccf ("tools/testing/cxl: Introduce a mock memory device + driver")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/r/20240528225551.1025977-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 35ee41e435ab3..0d0ca63de8629 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -3,6 +3,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/sizes.h>
-- 
2.43.0



