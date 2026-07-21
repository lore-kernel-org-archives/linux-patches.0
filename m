Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE1F449B0B;
	Tue, 21 Jul 2026 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649597; cv=none; b=IkjSS/ja+CXI7KXTjqYmAta4i6FGxuWKk2IIgiObrWiLMGjNpPFxgtT8P7DGjdbu3/egwyKKOdAsGklJVwBAiSJfraKYBE0GAN3aA9crR9NzyFhgxaMpaPiAGPPb1qWjwzLOKs2zEovU/PuQYp2LTdYFCXddYUGCNcdKPbU0Ib8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649597; c=relaxed/simple;
	bh=Ps3c1xvzggozK6sF2g+Qv+noOwqQGIx6imMSW7Iqxqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS3gdpYawcrXEG0ubl6hXhwbAMKBTNXBJl/0bjG8cGyonQnRRhYj9/0bvOiw+P7nK0I1BcZQA96MFJM8EO0BUm+a/kkPNmgYEfGa987ZjKmLG+dgqSXIjIL5L22v29z5iMgbOlZWJB4qIJL/Prz86lXuHrDNsDuYBtpSwZesrt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/lfXYyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/lfXYyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64051F000E9;
	Tue, 21 Jul 2026 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649596;
	bh=VewxYTrAcZx2meaUmFzSXTzArlceLxRke3rlNoZILsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/lfXYyzcp4FHLooWl39J+LpUCTCEWfA/BqiL9FqtaikZ26jwsM2b3M34Xez2liCi
	 uBZeIEEYJjJJ3UJ6rvB9ZiZACvNKewWp/WL25LSZRWaJTE/S5RFjQXfF2kw5qi19oj
	 JT1GCfDbhVx3mIO+d59wmkR7xHvwNc0okdYOooT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0636/2077] vdpa/octeon_ep: Fix PF->VF mailbox data address calculation
Date: Tue, 21 Jul 2026 17:05:09 +0200
Message-ID: <20260721152607.809244646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31a02e7fd7f279..9946480ee70460 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (C) 2024 Marvell. */
 
+#include <linux/bitfield.h>
 #include <linux/interrupt.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
@@ -722,6 +723,8 @@ static int octep_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	bool done = false;
 	int index = 0;
 	int ret, i;
+	u8 rpvf;
+	u64 val;
 
 	ret = pci_enable_sriov(pdev, num_vfs);
 	if (ret)
@@ -741,9 +744,11 @@ static int octep_sriov_enable(struct pci_dev *pdev, int num_vfs)
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



