Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EF346EC9E;
	Tue, 21 Jul 2026 19:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662072; cv=none; b=tV5Kld3YrSP2XdnKBz+lJXwafh+8+QljtTG0CAG9FXCA/w42JxjgAT7F/GW7LleCrJwvsGmEZbZjNrEQEQack0+zShuJ+VzuyXpu+AeGM+o11enn/S77PfjEotgV6DPQ0xjnmks5yjJGQx1paJjYKFEX0vjBPU7zcs3rVnV/fsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662072; c=relaxed/simple;
	bh=TuQNti8KHv6f6A+zYr1cuA977DEtUUnhsWfxLszTOSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDaCm1wZi2EM2mMaLyEhJuZu7TqIt3Jgl4HETXUYBxGsst7Y/XbEsOoN3T4unUNpg9jOIDZYRRZ0lx3T7WrAMFdf6tkm887Zl0qeA0MDyyZHAo8XBxvhbYs8GZBRkKRCsDhV1l5ap9FRdP+3jGkOjl6yTU7lpmExps1U+Fcmk2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auS7T7vT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auS7T7vT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C60F1F00A3A;
	Tue, 21 Jul 2026 19:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662069;
	bh=By/U7eRsowswSHP9TU31qETzf5Ct33prV181/JXMw6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auS7T7vTyIY776Tx1lO9O5DjO7X7duzBQZmKpmTa9rzGhTb+fdH4JLVYI5DkveWGg
	 jsrSco5aJ6NWsSM1DJToOMrXI+qFO6YiLygJ7kmVwqIvVmuw3gV8XjLba4/S3ORF/f
	 7junjKCmGix35hC1qTTNVFTa4M54t6OGUCxWddvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0304/1276] vdpa/octeon_ep: Fix PF->VF mailbox data address calculation
Date: Tue, 21 Jul 2026 17:12:27 +0200
Message-ID: <20260721152452.896270587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 74dc530f4c505d61f0f3620e59fe56c325ae3437 ]

The mailbox address was computed assuming 1 ring per VF. Read the
actual rings-per-VF from OCTEP_EPF_RINFO and use it when calculating
OCTEP_PF_MBOX_DATA offsets, fixing VF initialization when rings
per VF > 1.

Fixes: 8b6c724cdab8 ("virtio: vdpa: vDPA driver for Marvell OCTEON DPU devices")
Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260224095226.1001151-2-schalla@marvell.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/octeon_ep/octep_vdpa_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/octeon_ep/octep_vdpa_main.c b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
index 70c932df42fab1..e65565ea5b836d 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (C) 2024 Marvell. */
 
+#include <linux/bitfield.h>
 #include <linux/interrupt.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
@@ -678,6 +679,8 @@ static int octep_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	bool done = false;
 	int index = 0;
 	int ret, i;
+	u8 rpvf;
+	u64 val;
 
 	ret = pci_enable_sriov(pdev, num_vfs);
 	if (ret)
@@ -697,9 +700,11 @@ static int octep_sriov_enable(struct pci_dev *pdev, int num_vfs)
 		}
 	}
 
+	val = readq(addr + OCTEP_EPF_RINFO(0));
+	rpvf = FIELD_GET(GENMASK_ULL(35, 32), val);
 	if (done) {
 		for (i = 0; i < pf->enabled_vfs; i++)
-			writeq(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i));
+			writeq(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i * rpvf));
 	}
 
 	return num_vfs;
-- 
2.53.0



