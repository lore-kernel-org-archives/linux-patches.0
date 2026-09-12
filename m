Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F13630A5;
	Sat, 12 Sep 2026 08:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201241; cv=none; b=TWH+ZFa1L2uhPcN1BfrcsIyR+FyHulaOTCYt21GAnySsfTrICc9i1QyPUpt1SNHd+4M8j6vIaG/q3cSMKJjHtbb4iXE0Eytu8KrcxQYWUuzhlhvfQO2nX3I35HkgOgAqr7CfXeHNmXPPscWBXXx/GIhtfHT8iXID9GjSA8rPdu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201241; c=relaxed/simple;
	bh=4/GXZODyLVQ7KfvFICfhDB+h77PBB25rw1ovHnrPh/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOKPu4r/J46teSj4FUzD432AiGp9ZPjoDO+q/aoBef19LklThBYqIGDZogIXc5wOSwjsNG3OHa/UIwEpWY6lG2xsyul0xGRyUPqRdJc2srhJiVt7Rwd7y2m6O42vzEytan8RsedcexarwA4r8sg9Piv+4717JQbeVW2HOwBkf0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmcrQDwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmcrQDwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49271F000FF;
	Sat, 12 Sep 2026 08:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201239;
	bh=ibm59/+lZx8YYkRDcyh5ZoKp+ZTSuDNPYxQb2a/b5Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmcrQDwodtnr6JxJu3elHC2WNconBXotK1jLRnlZLTkgepYDwa9m7junwklaBMr8q
	 DdRKky1tDjQLOlQSTKMwlYixlzsl9h91wepOteHpb2QCqD7tIDqD/cg6VY2newDKcR
	 RJhGNAi6eyyl7w6fxOzkn64PPSweyDG0u8F6ZJPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linghui Wu <linghui.wu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0954/1815] wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump
Date: Sat, 12 Sep 2026 08:45:04 +0200
Message-ID: <20260912065711.365333860@linuxfoundation.org>
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

From: Linghui Wu <linghui.wu@oss.qualcomm.com>

[ Upstream commit 4f25071afe9218aaae1c63fbf75e229aa6405319 ]

On WCN3990/SNOC the MSA region is mapped with devm_memremap(MEMREMAP_WT).
On arm64 such a mapping is not Normal-cacheable, so unaligned accesses to
it are not permitted. ath10k_msa_dump_memory() copies the region with a
plain memcpy(), whose optimized __pi_memcpy_generic implementation issues
wide/unaligned loads. This triggers an alignment fault (FSC=0x21) Oops in
ath10k_snoc_fw_crashed_dump() while collecting the devcoredump:

  Unable to handle kernel paging request ... FSC=0x21: alignment fault
  pc : __pi_memcpy_generic
  lr : ath10k_snoc_fw_crashed_dump [ath10k_snoc]

The Oops both leaves the firmware RAM dump buffer zeroed (no dump is
captured) and crashes the kernel, which in turn breaks modem SSR
recovery.

Use memcpy_fromio(), which only performs accesses that are valid for such
a device-memory mapping. The generic memcpy_fromio() implementation aligns
the source before issuing word-sized reads and stores the destination with
put_unaligned(), so it is also safe for the coherent DMA allocation used on
the non-reserved-memory path. ath11k and ath12k use the same pattern
when copying target memory into crash dumps, so call it unconditionally
here too.
The MEMREMAP_WT pointer is a plain void *, so an explicit __iomem cast is
needed; use __force to keep sparse happy.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.3.7.c5-00107-QCAHLSWMTPL-1

Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
Signed-off-by: Linghui Wu <linghui.wu@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727072629.2297208-1-linghui.wu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 3106502275781..33c98927e8feb 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -6,6 +6,7 @@
 
 #include <linux/bits.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -1475,11 +1476,15 @@ static void ath10k_msa_dump_memory(struct ath10k *ar,
 	hdr->length = cpu_to_le32(ar->msa.mem_size);
 
 	if (current_region->len < ar->msa.mem_size) {
-		memcpy(buf, ar->msa.vaddr, current_region->len);
+		memcpy_fromio(buf,
+			      (const void __iomem __force *)ar->msa.vaddr,
+			      current_region->len);
 		ath10k_warn(ar, "msa dump length is less than msa size %x, %x\n",
 			    current_region->len, ar->msa.mem_size);
 	} else {
-		memcpy(buf, ar->msa.vaddr, ar->msa.mem_size);
+		memcpy_fromio(buf,
+			      (const void __iomem __force *)ar->msa.vaddr,
+			      ar->msa.mem_size);
 	}
 }
 
-- 
2.53.0



