Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA467143873;
	Wed, 19 Jun 2024 13:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802155; cv=none; b=SjhLCb7bHBLQDbeaFSaf4yz30+0g2iwANmfQIeSfS5Sr4bj0Z2kqt1BcKhDZA5DfHbFqkENMTFiQdaMSlqB9zYz7+GMCDcTpz+iTz/JdpSKXHvfhCvyAJgN7Pm8tvCqDz/0SiF7SupHinkfiKegn98BrWTC2dLTqxp7aKDs12tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802155; c=relaxed/simple;
	bh=S+LHmC90XH92SBHBzncygCStmbbUUWZg/NmUMDnkNqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KYntVU5aVsEMwrJIhGat8dG2zxnFfpbdQGe/6fyn+m8MmXgHxTCK0eODN0AhycQCRubjvVb+KI2CwjYveEP4BWo+w80Tok03y1RPUUOw2AtYUuZYVKoDsUG1X9ApWMa4kofhSIjrk+v2f8wgQI6KEH3/qlJ+J5LwJhI6wVmJ77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvQoO0f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvQoO0f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAA4C2BBFC;
	Wed, 19 Jun 2024 13:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802154;
	bh=S+LHmC90XH92SBHBzncygCStmbbUUWZg/NmUMDnkNqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvQoO0f9/8HE6236mUd/smqoVNK8wv2HXBRtxNRbd9K3vlYyv1TetNJT06bl9CN79
	 XRNet4tgN6EZxCmmKYDiX00KrXYnmZ5Co2jAMALHQLMz0K8olsjxaBJGXLGH2FVV6S
	 7JJ0dd/uXa1g7qCDF7i2GhzwDPOlcBocLxZxmcWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/267] cxl/test: Add missing vmalloc.h for tools/testing/cxl/test/mem.c
Date: Wed, 19 Jun 2024 14:54:12 +0200
Message-ID: <20240619125610.230415112@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 68118c37f0b56..0ed100617d993 100644
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



