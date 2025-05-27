Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115831D63EF;
	Tue, 27 May 2025 17:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367483; cv=none; b=en6sagSI0qiWKDZxo92xDcDsT+m1dFMPPSo9SUau6KagPWhw/g9VjVjUl5OTCa6rtIkBLqZZ+cPLINLlDm2ithTetd1fTcDyzkscFf37zMrUbiCaTIa4vUnYK9aKCj0dNeBq4pJlmgQgMg8h0PmmmfsULG+G8ooOVXoQ6TP2neA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367483; c=relaxed/simple;
	bh=iZici22X57r7OQvEelBV++wxlSMne3yuAQI2pelZ4Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWqDuPb3Mlnzi38NK3DCzoMtx8zu6ZfyxjDKKyCB389Id4/T23ylMVLD0E16wVljOAwInWXlf3IS1eeNFkoK5NV1Q6ZkR9l9GGCzvGg+hYXqiOVJptYaipl+eq7uqXKJdqYX1DMZfE1vEpemBhWTy4yBPsGM2dVEYIQ198p+DuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLV+gDSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLV+gDSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D56C4CEE9;
	Tue, 27 May 2025 17:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367482;
	bh=iZici22X57r7OQvEelBV++wxlSMne3yuAQI2pelZ4Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLV+gDSI3uljOwZqqShlgTlFdPXBQYyZEWKUy9KdQNDHQCbuig10mi8Tg2fhNNe0z
	 /8qSyHpHwCqjKRHeHENFTREVnVSLegBQWh63Ol9Z8Kuzf8RBS4Lz2cYSlhfk8MVsQ2
	 06L1TNgt70nuicf2XExOeLVJjPvS0P1WmDjtT11c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jason Baron <jbaron@akamai.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 402/783] EDAC/ie31200: work around false positive build warning
Date: Tue, 27 May 2025 18:23:19 +0200
Message-ID: <20250527162529.464827057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c29dfd661fe2f8d1b48c7f00590929c04b25bf40 ]

gcc-14 produces a bogus warning in some configurations:

drivers/edac/ie31200_edac.c: In function 'ie31200_probe1.isra':
drivers/edac/ie31200_edac.c:412:26: error: 'dimm_info' is used uninitialized [-Werror=uninitialized]
  412 |         struct dimm_data dimm_info[IE31200_CHANNELS][IE31200_DIMMS_PER_CHANNEL];
      |                          ^~~~~~~~~
drivers/edac/ie31200_edac.c:412:26: note: 'dimm_info' declared here
  412 |         struct dimm_data dimm_info[IE31200_CHANNELS][IE31200_DIMMS_PER_CHANNEL];
      |                          ^~~~~~~~~

I don't see any way the unintialized access could really happen here,
but I can see why the compiler gets confused by the two loops.

Instead, rework the two nested loops to only read the addr_decode
registers and then keep only one instance of the dimm info structure.

[Tony: Qiuxu pointed out that the "populate DIMM info" comment was left
behind in the refactor and suggested moving it. I deleted the comment
as unnecessry in front os a call to populate_dimm_info(). That seems
pretty self-describing.]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/20250122065031.1321015-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ie31200_edac.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index 9b02a6b43ab58..a8dd55ec52cea 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -408,10 +408,9 @@ static int ie31200_probe1(struct pci_dev *pdev, int dev_idx)
 	int i, j, ret;
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
-	struct dimm_data dimm_info[IE31200_CHANNELS][IE31200_DIMMS_PER_CHANNEL];
 	void __iomem *window;
 	struct ie31200_priv *priv;
-	u32 addr_decode, mad_offset;
+	u32 addr_decode[IE31200_CHANNELS], mad_offset;
 
 	/*
 	 * Kaby Lake, Coffee Lake seem to work like Skylake. Please re-visit
@@ -469,19 +468,10 @@ static int ie31200_probe1(struct pci_dev *pdev, int dev_idx)
 		mad_offset = IE31200_MAD_DIMM_0_OFFSET;
 	}
 
-	/* populate DIMM info */
 	for (i = 0; i < IE31200_CHANNELS; i++) {
-		addr_decode = readl(window + mad_offset +
+		addr_decode[i] = readl(window + mad_offset +
 					(i * 4));
-		edac_dbg(0, "addr_decode: 0x%x\n", addr_decode);
-		for (j = 0; j < IE31200_DIMMS_PER_CHANNEL; j++) {
-			populate_dimm_info(&dimm_info[i][j], addr_decode, j,
-					   skl);
-			edac_dbg(0, "size: 0x%x, rank: %d, width: %d\n",
-				 dimm_info[i][j].size,
-				 dimm_info[i][j].dual_rank,
-				 dimm_info[i][j].x16_width);
-		}
+		edac_dbg(0, "addr_decode: 0x%x\n", addr_decode[i]);
 	}
 
 	/*
@@ -492,14 +482,22 @@ static int ie31200_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	for (i = 0; i < IE31200_DIMMS_PER_CHANNEL; i++) {
 		for (j = 0; j < IE31200_CHANNELS; j++) {
+			struct dimm_data dimm_info;
 			struct dimm_info *dimm;
 			unsigned long nr_pages;
 
-			nr_pages = IE31200_PAGES(dimm_info[j][i].size, skl);
+			populate_dimm_info(&dimm_info, addr_decode[j], i,
+					   skl);
+			edac_dbg(0, "size: 0x%x, rank: %d, width: %d\n",
+				 dimm_info.size,
+				 dimm_info.dual_rank,
+				 dimm_info.x16_width);
+
+			nr_pages = IE31200_PAGES(dimm_info.size, skl);
 			if (nr_pages == 0)
 				continue;
 
-			if (dimm_info[j][i].dual_rank) {
+			if (dimm_info.dual_rank) {
 				nr_pages = nr_pages / 2;
 				dimm = edac_get_dimm(mci, (i * 2) + 1, j, 0);
 				dimm->nr_pages = nr_pages;
-- 
2.39.5



