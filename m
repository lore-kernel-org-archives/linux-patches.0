Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FAB318EC7;
	Thu, 17 Sep 2026 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664457; cv=none; b=AdG4TjfNyT+PlhbcYyPx90JpMQwAhFUX3ULLthZiKUmY8qbQrxTxJtR7KnR9yCdTcv4ZXk5Pc15UaMod2ASd4cPvzmHMdaHcK4fDPC+2m3B8QcyM0XgKtRvSKAgdCQQdrB5hE+ksYuSxTpaHSXbp8TALhvn8++BIacDsAVCpsHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664457; c=relaxed/simple;
	bh=oEgLQ3Z6+yfhPS9xWcDQwVsMhf0BByqeuN+syXSHdYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njMicxvMoal50UZs+suU1qOsS4uuc8BadDDv/lZdAh4PzsoUmSZkJgHcc2WHa8HewAFsDRN8VF+oDEH6KVnpMcEpsCro8JTVdChkwJ+2B9iAKYAevQyxudi0XNGZOB3CRErrJWa0g3Ln3225u+hjpsAlELTdlurxwi3+2yowsRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ9CuoHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ9CuoHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D02D1F00898;
	Thu, 17 Sep 2026 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664455;
	bh=nucfBEZj0icB9dfrIbEDlfQI0CQ4E/W4RCJbrG8czbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZ9CuoHsGoh4MA9XUMyZf5LKiLlkM8aOjGHBXqD1VYkAPS/hxUzZ+o3Zc9n+5pXPs
	 pYwBdc24sEf1EBQtjlSohZ9C3QAsG5D3Nf+sQLLSP7UkXsv8nbBhe8Lk7O+6MSBfrn
	 KGyxQKhho4Tm1FUGzlO80BEEzmO8NRzR6EnRDR8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamsi Attunuru <vattunuru@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0378/1250] vdpa/octeon_ep: Use 4 bytes for mailbox signature
Date: Thu, 17 Sep 2026 16:02:53 +0100
Message-ID: <20260917151602.294731952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index df8af6c1454cc..9aac6dbdaf3aa 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -582,10 +582,10 @@ static const struct vdpa_mgmtdev_ops octep_vdpa_mgmt_dev_ops = {
 
 static bool get_device_ready_status(u8 __iomem *addr)
 {
-	u64 signature = readq(addr + OCTEP_VF_MBOX_DATA(0));
+	u32 signature = readl(addr + OCTEP_VF_MBOX_DATA(0));
 
 	if (signature == OCTEP_DEV_READY_SIGNATURE) {
-		writeq(0, addr + OCTEP_VF_MBOX_DATA(0));
+		writel(0, addr + OCTEP_VF_MBOX_DATA(0));
 		return true;
 	}
 
@@ -757,7 +757,7 @@ static int octep_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	rpvf = FIELD_GET(GENMASK_ULL(35, 32), val);
 	if (done) {
 		for (i = 0; i < pf->enabled_vfs; i++)
-			writeq(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i * rpvf));
+			writel(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i * rpvf));
 	}
 
 	return num_vfs;
-- 
2.53.0



