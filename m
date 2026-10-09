Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6D94E2F2F;
	Fri,  9 Oct 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556530; cv=none; b=o//N+ribjaczsW4W2DT8l33/3b5SGMbbk+zzb8iimGR5VtWkAaiLOSkPAIszXJrYa1obO5q6XZtb4ThXuwNrDZb083OyPatYCRRT3FseXRgbm7NrVXD/4xhS7BYyE5/8b2ZEqMxZ8LgxUMTHOYv1vpEqLjSO3vRNb3InOHQOioo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556530; c=relaxed/simple;
	bh=3Pna6cxRUjlHW7zQlV29cT1O/B4bheLgfEXV6PJ2yno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV7ktuCQsm7d7MXTpw5aP+HFBnBITYpDqc0OyCtk4frkN+QOuGOsUToxyG2kYjHDF2qPnTDv7GkHnNFPKK0BV4GWwVz0F1TSvw3NgxTtXA0JaJzQSLe6jV/1hfRNZ2SLnfsC4UXZH+R0rf7TayLuZ4wKIuW1THIYB2s+WXRLbKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lodaiypp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lodaiypp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817571F00899;
	Fri,  9 Oct 2026 14:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556528;
	bh=IXY09/EqOel7tDqLrbbL1NLadSZyxCE4tKLM6gsGTSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lodaiyppBATB57Yq3IFFNZktnYpP0Vsb91LATX0r6VxvJcbuTZlWthfo8BErXfspc
	 /JbPLboRTdAokkUcNVtIt7WTpKeTsmmSGR5YSeRlG5cPUNtXWl5X8iycy36G7MyIbx
	 0k8pXabg6H+AGD07UYkvmu2SVanxHs/gNtS2uIh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menachem Adin <menachem.adin@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 250/403] mtd: mtd_intel_dg: reset poll counter for each erase
Date: Fri,  9 Oct 2026 16:10:11 +0200
Message-ID: <20261009140958.017138057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Menachem Adin <menachem.adin@intel.com>

commit 200c32e3cd53132fbf99f1e2a5751f556755cf6d upstream.

The non-posted erase polling counter is initialized only once per MTD
erase request. Large requests therefore share the polling budget across
all 4K erase commands and can fail with -ETIME even though no individual
command timed out.

Reset the counter for each 4K erase command so every operation gets the
intended completion timeout.

Cc: stable@vger.kernel.org
Fixes: a1c940cbf505 ("drm/xe/nvm: add support for non-posted erase")
Signed-off-by: Menachem Adin <menachem.adin@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/mtd_intel_dg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/mtd_intel_dg.c b/drivers/mtd/devices/mtd_intel_dg.c
index a566e86eb5e3..55a945c1a67a 100644
--- a/drivers/mtd/devices/mtd_intel_dg.c
+++ b/drivers/mtd/devices/mtd_intel_dg.c
@@ -387,7 +387,7 @@ idg_erase(struct intel_dg_nvm *nvm, u8 region, loff_t from, u64 len, u64 *fail_a
 	void __iomem *base2 = nvm->base2;
 	void __iomem *base = nvm->base;
 	const u32 block = 0x10;
-	u32 iter = 0;
+	u32 iter;
 	u32 reg;
 	u64 i;
 
@@ -396,6 +396,7 @@ idg_erase(struct intel_dg_nvm *nvm, u8 region, loff_t from, u64 len, u64 *fail_a
 		iowrite32(region << 24 | block, base + NVM_ERASE_REG);
 		if (nvm->non_posted_erase) {
 			/* Wait for Erase Done */
+			iter = 0;
 			reg = ioread32(base2 + NVM_DEBUG_REG);
 			while (!(reg & NVM_NON_POSTED_ERASE_DONE) &&
 			       ++iter < NVM_NON_POSTED_ERASE_DONE_ITER) {
-- 
2.56.0



