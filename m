Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA713385A5;
	Sat, 12 Sep 2026 12:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216975; cv=none; b=dAFg9U2qYvTLEzvEvsxg7Mc2zg0oByYg46P18msCNuOeqLsuSZ2aCcbTdENAg5ZAXyGQ59UurwZVWD5glJAKgLTcf8Ss/0mTRADvOn3nHkExI7RcvBI6sOgCft+jLJ9ctbm1BoHtoDd49T+1MOzYFn8ntJOXLujVDl2ppp5A7UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216975; c=relaxed/simple;
	bh=uqghL1+anKAB9ImNr925HEZ3YFq5vsSltJEj+o8/eQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5IRs/0jW6r+pBuYIAJjuHoEIQ0hDQ+r7SyJffaD023DowflJgFSPYR8Un1V/nfyQ7cPVLFj7UcS1jjZvVlFNltNX0QyXCjS215BtLErwVbvVW/SDHcOcmcsX3WPm4sJWhL9A+ccWvyJqle2/u1ZWy9kSBkBSXRlRl3w7LQElUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFv84G2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFv84G2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD151F000FF;
	Sat, 12 Sep 2026 12:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216973;
	bh=C1om+bHrckxCCHfQpJ1DFymWf+9BAPlr3QB2DkhQGz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFv84G2KbpZtk6RO0TPrzqpChp05Ko7gsu3Mu7SNhGFYouU7oQyDZvH/XCZaTgYLH
	 FF2BlByEIkCD3eU7XRt1E8roP1oq3h0QjhhO6nfFOZ4LkuHL2+Es3/zLpjXmljx4T1
	 yHB2ooMPxVIuICbyIT+JdNn5pmrSd4bMwJC0bvl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linghui Wu <linghui.wu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0847/1376] wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump
Date: Sat, 12 Sep 2026 08:54:33 +0200
Message-ID: <20260912065626.429790647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 59f7ccb33fde3..ad215de068e1c 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -5,6 +5,7 @@
 
 #include <linux/bits.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -1455,11 +1456,15 @@ static void ath10k_msa_dump_memory(struct ath10k *ar,
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



