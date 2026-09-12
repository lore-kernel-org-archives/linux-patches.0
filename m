Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B3236A37E;
	Sat, 12 Sep 2026 10:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208040; cv=none; b=hpCpetmQf9fg2og+eyy0AFG155CQyGEjhG2v3dxINSUXxYonxfxxbTYrR9cx+cZulS65RyO73U0mUMvMVoyXX1Uk8659DMAlV9Ssrbf47IdnVCul/ZQiGkKJSBnwT6hc13Rgf61HY9fBKmzCvUJEHZYqjv1GGmOGHxbbr7yW1l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208040; c=relaxed/simple;
	bh=j14LNPwE+B4k1EqNZlHDOIJ9ZeVnOczYf9HA7ZtDxmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8bQuO7WMiG1VPlBCyjHakYQ9nPesmCnne3Q73V9EiERR5ogLmoHZMajT5NyoMsPtTVtWRKSYbniZbBs41qNbs35Chcy3ke7Kiq7wBrfnwGcEcGelKNVTGxUAsXLFiesnzk2oLfUIRmJJlQkWQD+WEArrh7kqmnnOArVyxzvkWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFHmmDhK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFHmmDhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EC01F000FF;
	Sat, 12 Sep 2026 10:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208039;
	bh=aNA84/2QjF5znfl6lthCWOluombjhxu/qd18/nhHTxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFHmmDhKKYyzmTuvni8QyjHV9D9Ji2SfJ2Y1qfRh8omNm2A4EbTOoEdU1mquXXNKp
	 KyA4zqHu8sJBY/mqK/oIlf8TebZmo6noc45F0PvIwPkTOV0B3gnx7aZkh7IWIu1Z2j
	 mC7UMrWkR9jGsLYhdmCF1iTdZx75Gdt6J0JXFGmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0535/1518] wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region
Date: Sat, 12 Sep 2026 08:45:04 +0200
Message-ID: <20260912065635.546700410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 42399be44b13eafb45c56b1c7d7c92107e50c289 ]

Currently, the Q6 region contains a read-only firmware region along with
the BDF_MEM_REGION_TYPE and HOST_DDR_REGION_TYPE memory areas. The firmware
expects these writable memory regions to be assigned after the Q6 read-only
section.

However, the ath12k driver currently allocates the HOST_DDR_REGION_TYPE
starting from the base of the Q6 region, which includes the read-only
firmware area. As a result, the allocated memory regions overlap with the
read-only section, causing the firmware to assert during QMI memory
allocation. The Q6 memory region layout is as follows:

		Q6 Reserved Memory
	+--------------------------------------+
	|                                      |
	|  Read-only Firmware Region           |
	|  (Q6 RO Region)                      |
	|                                      |
	+--------------------------------------+ <--- bdf_addr_offset
	|  Writable Memory Region              |
	|  (BDF + HOST_DDR allocations)        |
	|                                      |
	+--------------------------------------+

Fix this by allocating the required memory regions only after the end of
the read-only region in the Q6 address space. The bdf_addr_offset parameter
indicates where the writable region starts. Both HOST_DDR and BDF regions
are allocated sequentially after this offset, with each region placed
immediately after the previous one to avoid gaps and overlaps.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Fixes: 6757079c5890 ("wifi: ath12k: add support for fixed QMI firmware memory")
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Link: https://patch.msgid.link/20260630062048.1615178-4-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 36048dc721935..b66cff3c70e22 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2704,8 +2704,8 @@ static const char *ath12k_qmi_get_mem_reg_name(int mem_type)
 static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 {
 	struct device_node *np = ab->dev->of_node;
+	size_t avail_rmem_size, offset = 0;
 	struct target_mem_chunk *chunk;
-	size_t avail_rmem_size;
 	struct resource res;
 	const char *rname;
 	int i, idx, ret;
@@ -2739,9 +2739,20 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 			goto out;
 
 		avail_rmem_size = resource_size(&res);
-		if (chunk->type == BDF_MEM_REGION_TYPE) {
-			avail_rmem_size -= ab->hw_params->bdf_addr_offset;
-			res.start += ab->hw_params->bdf_addr_offset;
+		if (chunk->type == BDF_MEM_REGION_TYPE ||
+		    chunk->type == HOST_DDR_REGION_TYPE) {
+			if (ab->hw_params->bdf_addr_offset > avail_rmem_size ||
+			    offset > avail_rmem_size - ab->hw_params->bdf_addr_offset) {
+				ath12k_err(ab, "qmi mem offset overflow: bdf_offset=%u offset=%zu size=%zu\n",
+					   ab->hw_params->bdf_addr_offset, offset,
+					   avail_rmem_size);
+				ret = -EINVAL;
+				goto out;
+			}
+
+			avail_rmem_size -= ab->hw_params->bdf_addr_offset + offset;
+			res.start += ab->hw_params->bdf_addr_offset + offset;
+			offset += chunk->size;
 		}
 
 		if (avail_rmem_size < chunk->size) {
-- 
2.53.0



