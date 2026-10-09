Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061664E4C2D;
	Fri,  9 Oct 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557149; cv=none; b=G8wAgtFabft8tHsaCQctSx9kEUFnHL1QYLDv1hZKxcTcoaI8Za+qK2HmvgapQIsskazcWtGnauB++DaKHFS+efk/wEaeV+N9TfoOUrpxyREYZCM3hFPSYwXw6bO89ZSIV+qTD4NesMGoPqwKrUS1dXkQofFLSQv77hBxJwWfVhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557149; c=relaxed/simple;
	bh=AeKGtNk81hPND2oh+uOpKr/3hL7N7nRoHF1u836PN/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXN5LsAUpyAc+5D9rgGEzSn/MPGCuBsR7hZXJfu1G4JePdYnnBtFBKadB/14c/2O8Zx5+zdzrTBugIAasiX2BYuXLe3unY0/SdHsT5QoiTLgnIJ/uTA3Pq+3hQkC3gVsAvXoY7tN35xo71Pckyyk3sr1GOAsJSarO0GPIQ0CRUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3uhU9kP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3uhU9kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056701F00893;
	Fri,  9 Oct 2026 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557147;
	bh=2PC9oillSgiguh3gt5T4XDiwWi/VQ0HFqL3TAojC+Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3uhU9kP7uTGuPpJ3u1OETdoq7x0BnxmSWQd1mu1muHh7NntE5MqB5yi7yIx7CA2A
	 83M5N8Ud05Ro81Nn0KSoQ9THVzGuoTWNAbQrB8uC3EGKyl/NbBzDVnAx3oTCx7Mu9B
	 Hxa2MY5zokc8caVzspT97ymN0xctOQJ8nnsOyjWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menachem Adin <menachem.adin@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 303/428] mtd: mtd_intel_dg: reset poll counter for each erase
Date: Fri,  9 Oct 2026 16:10:40 +0200
Message-ID: <20261009140952.772098053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
 drivers/mtd/devices/mtd_intel_dg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/devices/mtd_intel_dg.c
+++ b/drivers/mtd/devices/mtd_intel_dg.c
@@ -387,7 +387,7 @@ idg_erase(struct intel_dg_nvm *nvm, u8 r
 	void __iomem *base2 = nvm->base2;
 	void __iomem *base = nvm->base;
 	const u32 block = 0x10;
-	u32 iter = 0;
+	u32 iter;
 	u32 reg;
 	u64 i;
 
@@ -396,6 +396,7 @@ idg_erase(struct intel_dg_nvm *nvm, u8 r
 		iowrite32(region << 24 | block, base + NVM_ERASE_REG);
 		if (nvm->non_posted_erase) {
 			/* Wait for Erase Done */
+			iter = 0;
 			reg = ioread32(base2 + NVM_DEBUG_REG);
 			while (!(reg & NVM_NON_POSTED_ERASE_DONE) &&
 			       ++iter < NVM_NON_POSTED_ERASE_DONE_ITER) {


