Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0595746AA62;
	Tue, 21 Jul 2026 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648051; cv=none; b=UKG0kfjYB48V8RwTl4a5H29olACvgTfMXbAYCWTpgxxrOfF7Qj2cpTkQ48Gb1tkWZ7dj4nSYT/ix76L+DKs9JtWU/9aPdlDilTSsw8utSShOWUgr4J0xG8goN5Hce55S238OJTpbMUEbpPgZVsB8CTcX8zBB6HmFFsvzjl/qCng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648051; c=relaxed/simple;
	bh=RgtY+I59kHmtnKRgafbmvh0ilz4JPXSOg8JwOPMuwOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgJNGCgD64RfjU9UCuXmM8ts/Wzjc47Q/PjzISQuAsnXmzFeIEqnO3DWR/TvDSVc69dx1Z3CXlU57t2zY9AodN/LfEyr2VLDOreJcBYUfUPHVsPKj4c8ZDz/cO2XhhW9CKVZx+VcY1ndVw88igYMUAxxjWETZAc348yWSAoHn1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpp8JZQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpp8JZQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660CC1F000E9;
	Tue, 21 Jul 2026 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648049;
	bh=VrMRBy0hxZPuSYtszIlKHmE6ip/RAOcEJWQvawiO1mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpp8JZQUCyK4BRYkPQVuTSGt9vhqM00kMPpwyLxQrRKvlGhoVWH7gpC9FXycDvBy+
	 RuqkUXKxew1n979NE5kJM7oL6OpMmiMPPAJszJimVz8gDgCxckdEOml6mjgK7cvkT4
	 XI46Z5oQGmMxuPkoSjCjOZs8KZKO56yTOslb4Kno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Wendy Liang <wendy.liang@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0054/2077] accel/amdxdna: Fix iommu_map_sgtable() return value handling
Date: Tue, 21 Jul 2026 16:55:27 +0200
Message-ID: <20260721152553.967362326@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 1bcfa4c4e88a554d1b6f98f4e3f886288581cbb4 ]

iommu_map_sgtable() returns negative error codes on failure, but the
result is stored in an unsigned variable. This prevents proper error
detection.

Change the variable type to ssize_t so negative error values can be
handled correctly.

Fixes: ece3e8980907 ("accel/amdxdna: Allow forcing IOVA-based DMA via module parameter")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/adk7kOUBwIyYnX1M@stanley.mountain/
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Wendy Liang <wendy.liang@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260413180238.668441-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_iommu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_iommu.c b/drivers/accel/amdxdna/amdxdna_iommu.c
index 4626434d4180cf..2676cfcfabee0d 100644
--- a/drivers/accel/amdxdna/amdxdna_iommu.c
+++ b/drivers/accel/amdxdna/amdxdna_iommu.c
@@ -40,7 +40,7 @@ int amdxdna_iommu_map_bo(struct amdxdna_dev *xdna, struct amdxdna_gem_obj *abo)
 	struct sg_table *sgt;
 	dma_addr_t dma_addr;
 	struct iova *iova;
-	size_t size;
+	ssize_t size;
 
 	if (abo->type != AMDXDNA_BO_DEV_HEAP && abo->type != AMDXDNA_BO_SHMEM)
 		return 0;
@@ -65,7 +65,14 @@ int amdxdna_iommu_map_bo(struct amdxdna_dev *xdna, struct amdxdna_gem_obj *abo)
 
 	size = iommu_map_sgtable(xdna->domain, dma_addr, sgt,
 				 IOMMU_READ | IOMMU_WRITE);
+	if (size < 0) {
+		XDNA_ERR(xdna, "iommu_map_sgtable failed: %zd", size);
+		__free_iova(&xdna->iovad, iova);
+		return size;
+	}
+
 	if (size < abo->mem.size) {
+		iommu_unmap(xdna->domain, dma_addr, size);
 		__free_iova(&xdna->iovad, iova);
 		return -ENXIO;
 	}
-- 
2.53.0



