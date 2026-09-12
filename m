Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B583749F5;
	Sat, 12 Sep 2026 07:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199533; cv=none; b=HFJa0/RBaGVMnA4rPh0Q7HaHF9e1t07Pg3mwSRV1p1Y95RoyekiHVGA7L6DAT5kDsEKVVhHY2JLrv+ueekXW7iiabL/h5PU2XrGfuInJP+ScW9KTFau21ECwyODz0oYVGC+im40kuqMcW4Y6dx+b6FT59gGp4Tky48iQXhUFoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199533; c=relaxed/simple;
	bh=YVLNKJ/pji13P5JCye+tz24c3EiUDBS9yHJSLByAAxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V23DQNcKsBNaOwrcMZXdNVhVCi5y29B7t9bq2PlT1zvrPA6vh6lDBitrd5FVe4akSeO9ffHUV+9UsaIWbqlLA/8Ry3pfgsJG7fYGlrXS/7OhyHjOE3qswhjM2G28qRQMgZbiMqkftkFSWVFTuUfAi3/L9CZDYODO7+tevLX3ti4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iczi+2A6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iczi+2A6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF25F1F000FF;
	Sat, 12 Sep 2026 07:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199531;
	bh=PNbnyRW5WdYOy+bygCVarSv5B4ekohG1i0vAo9HyBaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iczi+2A6fNLK5mFk20iWPFwG4cE6ZP+mGcPDHFz5bWW72uwDziUtQMRGni9DFCVtu
	 o3gIZOj3yZXnHbmHuUsjqwwWSDzxIS0GcXesqAlexs4ha9yWi4kYd02hfb/ifCZlNu
	 SvTPLu1l/vTWrMXvANXEnJpRP5TqzeR/Rn5DeKTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0605/1815] wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region
Date: Sat, 12 Sep 2026 08:39:15 +0200
Message-ID: <20260912065703.083710522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5bf045971c944..6d50632292214 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2746,8 +2746,8 @@ static const char *ath12k_qmi_get_mem_reg_name(int mem_type)
 static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 {
 	struct device_node *np = ab->dev->of_node;
+	size_t avail_rmem_size, offset = 0;
 	struct target_mem_chunk *chunk;
-	size_t avail_rmem_size;
 	struct resource res;
 	const char *rname;
 	int i, idx, ret;
@@ -2781,9 +2781,20 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
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



