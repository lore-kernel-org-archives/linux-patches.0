Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE344D178F;
	Thu, 17 Sep 2026 17:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667977; cv=none; b=S0i5SwhnMNVZyAGPI4ygnYp3T5rqSsgSeBsLwmkZweuMcHIT2pasDNe1g/px++USGyq1mbV/a0rUFZtPkaknFfarlfr+biL85k3kBTKY+zHiPIynM3OaddIBMwisvGT/Gh0QMEMzYkq0LGPIEhwuwmLf0+NSpWpx9BKvWE7zOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667977; c=relaxed/simple;
	bh=/sTxqpwcK7dFCRfozVpKSl66j/q684UjM2LZ8nSBJFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9aj8fbhbNYvsK3Fr5zcuf6xrxdG+VbHRR62kV0vq6NE5eZ+54PcKD3ie8EmSypysk0jvqLTwUqRrPL7+ujI5gG7OuSg+pIJval+2lukPxDSd+YYFtD0ph5u9FK/nWm6eHUNRQFY4TTIeVPZWe4Pw+QegKOI6QI6PQyU8BiehuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNYJ0jvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNYJ0jvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A091F000FF;
	Thu, 17 Sep 2026 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667976;
	bh=yDlaMN7fBe1L2J6eAFXja1gdvrdUe/cJPSVQzv6kYTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNYJ0jvX1q4Mbwk2i52qrQg8FkH5l6RSIcpmE1HiVplb+Pb+DWiVOLtK5qpy7kM5d
	 XlchL0+1km/luodstgru0JbLcn75aBl9ePMiM4CnvF0wGIzc9rWinOgQexf7W0grhr
	 LjaPlM7gpzvYFWJZF/MXKpAKqQUjln15J77EtcH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamsi Attunuru <vattunuru@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0272/1102] vdpa/octeon_ep: Use 4 bytes for mailbox signature
Date: Thu, 17 Sep 2026 16:03:35 +0100
Message-ID: <20260917151546.436924139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Vamsi Attunuru <vattunuru@marvell.com>

[ Upstream commit d42eadf7969e2217fceb84317d3fd28a7bdbd96e ]

The upper 4 bytes are reserved by the firmware for
storing meta data. Use only lower 4 bytes to update
the signature details.

Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260224095226.1001151-3-schalla@marvell.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/octeon_ep/octep_vdpa_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/octeon_ep/octep_vdpa_main.c b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
index e65565ea5b836..6be2227596fc7 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -537,10 +537,10 @@ static const struct vdpa_mgmtdev_ops octep_vdpa_mgmt_dev_ops = {
 
 static bool get_device_ready_status(u8 __iomem *addr)
 {
-	u64 signature = readq(addr + OCTEP_VF_MBOX_DATA(0));
+	u32 signature = readl(addr + OCTEP_VF_MBOX_DATA(0));
 
 	if (signature == OCTEP_DEV_READY_SIGNATURE) {
-		writeq(0, addr + OCTEP_VF_MBOX_DATA(0));
+		writel(0, addr + OCTEP_VF_MBOX_DATA(0));
 		return true;
 	}
 
@@ -704,7 +704,7 @@ static int octep_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	rpvf = FIELD_GET(GENMASK_ULL(35, 32), val);
 	if (done) {
 		for (i = 0; i < pf->enabled_vfs; i++)
-			writeq(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i * rpvf));
+			writel(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i * rpvf));
 	}
 
 	return num_vfs;
-- 
2.53.0



