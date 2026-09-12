Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684FC2D739C;
	Sat, 12 Sep 2026 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224693; cv=none; b=m/YiQVBWVVwRej1aKO+zonjy8H7d3JJseJ9P6AgtOuAs5pyR9GYjyHsfuRl2qxwnd2ui+KYL8PR3iVT3GvpNXbPYsuemDARCtgani6NffJsKxO6dqi3m9Nf+Z40W00arv8E4oJL9VcYJVjZMg3LvFp7Yt5sYYXEISlMFHGGhecI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224693; c=relaxed/simple;
	bh=+6t+7XKF49dSXIBVAL0inMpJGfhxVghsImluLGx/IjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk73iOEYxnRdhHv4vIUJu3nYzbkTMIrWLLoLPkgrkq1/56Q+XQbTRyVTOE6iy8DKXkK1xTc+n4o1qB4q2gAOe80444spX0ipLPfcYSzQUD86tIPXlMRuQGfgd1FsHs5jjJ8YGOMNXCAQM6CPNfpsFgADh+llBvCrZBiJdEY12uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCO/j/lV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCO/j/lV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391351F000FF;
	Sat, 12 Sep 2026 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224692;
	bh=BG/zbxCDDrkj5mHhU67U1DrSLUX9otMl9A2qZjTSLJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCO/j/lVYAyO15ZbbWu2vRW+Mj56YXJn/7arsXosk6MyyXZbO4WXNVSR4qKvFQ8gs
	 gLRoXkmDHU7gj0Zw5Tym7dY4aBhFScft24qNftZgNaMzFHLFXqV5AJaaHx1tuGn6nf
	 vuuHj3e0lLqSBPWS0o/8ocSdiVsCfdQfiWNXBK3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linghui Wu <linghui.wu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1002/1424] wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump
Date: Sat, 12 Sep 2026 08:57:14 +0200
Message-ID: <20260912065629.752567032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1d06d4125992d..17cf939a019f3 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -5,6 +5,7 @@
 
 #include <linux/bits.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -1452,11 +1453,15 @@ static void ath10k_msa_dump_memory(struct ath10k *ar,
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



