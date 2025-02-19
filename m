Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06241C548C;
	Wed, 19 Feb 2025 09:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957425; cv=none; b=rwjbWuCxZ7Xdf4CDybKjXKIxxg4f0lZFk+yZZtGeNvxynoryCV48htL+Uwe0CoPQNkFUhUqH8rKI8buOkdb2QHa212gHT2QFAJ9uTFXhutabfrPPGpXdm2BVvGLZgS3HSxIajDC19CZANCROEQ8vbamI5HF2OYK6kVWfHR0ONI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957425; c=relaxed/simple;
	bh=DdxWS3VYOGWLpVULvy59j2UnZRZ34UUhqSM9NniIV0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQcKL63W8D09HtHddEvqh1qGaoLU55EXOqYTFLFKVgeLwiarkbuZd1pykQisq2Zju9ik5q3vVWcQlOr1AcJq58YhOyZ0aIZB9eL0BnJncRxR0guquxp0KvMSLpN6MZn9gfVUjI4Vg0cOGO2koGVev3y/HJT7+qWU0J8JHzhvj8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeTc5k81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeTc5k81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687AAC4CEE6;
	Wed, 19 Feb 2025 09:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957424;
	bh=DdxWS3VYOGWLpVULvy59j2UnZRZ34UUhqSM9NniIV0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeTc5k81tWpwH7JStIcR7CZAqTpbjUnK76TWvcWWzeMtpyjB4GL+tL1/oGEWwveoh
	 XU5xZVpI6yFNBilJpck2t3uF0Izf4qNl3SO41NAsYB8FTiH+YPBoF3/rAd4jsboWoS
	 IkdkZhty2PjgnJMFEVjXCPnvmfQSU/KAm/SQHVP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramesh Thomas <ramesh.thomas@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 490/578] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Wed, 19 Feb 2025 09:28:14 +0100
Message-ID: <20250219082712.271683570@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ramesh Thomas <ramesh.thomas@intel.com>

[ Upstream commit 2b938e3db335e3670475e31a722c2bee34748c5a ]

Definitions of ioread64 and iowrite64 macros in asm/io.h called by vfio
pci implementations are enclosed inside check for CONFIG_GENERIC_IOMAP.
They don't get defined if CONFIG_GENERIC_IOMAP is defined. Include
linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
generic implementation in lib/iomap.c. The generic implementation does
64 bit rw if readq/writeq is defined for the architecture, otherwise it
would do 32 bit back to back rw.

Note that there are two versions of the generic implementation that
differs in the order the 32 bit words are written if 64 bit support is
not present. This is not the little/big endian ordering, which is
handled separately. This patch uses the lo followed by hi word ordering
which is consistent with current back to back implementation in the
vfio/pci code.

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241210131938.303500-2-ramesh.thomas@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe7..8191c8fcfb256 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include "vfio_pci_priv.h"
 
-- 
2.39.5



