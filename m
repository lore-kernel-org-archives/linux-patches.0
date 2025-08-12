Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960F72E285E;
	Tue, 12 Aug 2025 18:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022456; cv=none; b=VieOuX8t5RufGEqXvQuPAKhVuYrRK5Irde5Y3SDpqm1ddYFtvA+hBsH1V65kV1HwBgjvZpowm5ObVlDDHUYB+fawMhgdZcLc/omTWbMdbk8eNSV0q+A51tUuIG2D3nwQ09qbDjMmV/y7wQr51P4MY+x+Z12jK6lfNAOV+rjA+AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022456; c=relaxed/simple;
	bh=GtPFwe4eOKfi3a0OwBd3S7XCmV4XG3K3iWGjuRJ2UJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFtB7gjT+3jM2meKPzyfdDcwXYdjaBSZ2jgDneNCpG+o1CsyPsivUUqxTTWrT7Fx34NSrhiZ/5xKtxIdUFIuroYzKBDL3mwLhEC4uihtTGbuzSefsM1q03JNQlxeAUo/nDiSlkgTOvaXBdKGqgLjrZPP8RiogBSSxQOTaaeaMFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFF3shw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFF3shw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA3DC4CEF1;
	Tue, 12 Aug 2025 18:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022456;
	bh=GtPFwe4eOKfi3a0OwBd3S7XCmV4XG3K3iWGjuRJ2UJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFF3shw8wCxcytFPlZRZcavC3VC7M++NI9Rz6qgShny+rgNGwcn94uFFGr1EgBJ1z
	 A6GgYpb/LDIVcq/9bjszH4LmbuqS/11eLvO2r0leWsxhODL5iXhJHnSrPq9t6AA5/9
	 NP4Z5tfSmf0e5PLYcUXuYzH5ZVD1sW9IOpyhSYGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/369] mtd: fix possible integer overflow in erase_xfer()
Date: Tue, 12 Aug 2025 19:27:37 +0200
Message-ID: <20250812173020.784399170@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ivan Stepchenko <sid@itb.spb.ru>

[ Upstream commit 9358bdb9f9f54d94ceafc650deffefd737d19fdd ]

The expression '1 << EraseUnitSize' is evaluated in int, which causes
a negative result when shifting by 31 - the upper bound of the valid
range [10, 31], enforced by scan_header(). This leads to incorrect
extension when storing the result in 'erase->len' (uint64_t), producing
a large unexpected value.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ftl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 8c22064ead38..f2bd1984609c 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -344,7 +344,7 @@ static int erase_xfer(partition_t *part,
             return -ENOMEM;
 
     erase->addr = xfer->Offset;
-    erase->len = 1 << part->header.EraseUnitSize;
+    erase->len = 1ULL << part->header.EraseUnitSize;
 
     ret = mtd_erase(part->mbd.mtd, erase);
     if (!ret) {
-- 
2.39.5



