Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA4B6110;
	Tue,  5 Dec 2023 03:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOwI+29K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D36C433C8;
	Tue,  5 Dec 2023 03:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746622;
	bh=fBSRQ26nnJQZIFAmMuwYQ271X8520Wv15Wzx1tskz+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOwI+29K4PUnLMRmzo1mjbdh07/cPHL3XmvMNwGSzVz+uLW0K+35HwWmdGWlc1OH8
	 c9o724w4J7Tmi5RTC7UmwO83nJbVT+dK2znBO99SWa6Y45A4UCl8IC8YV4yaV/5mTI
	 7jT8jMrcOI/PEOZ/B8Zw6ZR+A2CPIUjYGom2pGQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Salomatkina <elena.salomatkina.cmc@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/134] octeontx2-af: Fix possible buffer overflow
Date: Tue,  5 Dec 2023 12:16:07 +0900
Message-ID: <20231205031541.483240435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Elena Salomatkina <elena.salomatkina.cmc@gmail.com>

[ Upstream commit ad31c629ca3c87f6d557488c1f9faaebfbcd203c ]

A loop in rvu_mbox_handler_nix_bandprof_free() contains
a break if (idx == MAX_BANDPROF_PER_PFFUNC),
but if idx may reach MAX_BANDPROF_PER_PFFUNC
buffer '(*req->prof_idx)[layer]' overflow happens before that check.

The patch moves the break to the
beginning of the loop.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e8e095b3b370 ("octeontx2-af: cn10k: Bandwidth profiles config support").
Signed-off-by: Elena Salomatkina <elena.salomatkina.cmc@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/20231124210802.109763-1-elena.salomatkina.cmc@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 23c2f2ed2fb83..c112c71ff576f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -5505,6 +5505,8 @@ int rvu_mbox_handler_nix_bandprof_free(struct rvu *rvu,
 
 		ipolicer = &nix_hw->ipolicer[layer];
 		for (idx = 0; idx < req->prof_count[layer]; idx++) {
+			if (idx == MAX_BANDPROF_PER_PFFUNC)
+				break;
 			prof_idx = req->prof_idx[layer][idx];
 			if (prof_idx >= ipolicer->band_prof.max ||
 			    ipolicer->pfvf_map[prof_idx] != pcifunc)
@@ -5518,8 +5520,6 @@ int rvu_mbox_handler_nix_bandprof_free(struct rvu *rvu,
 			ipolicer->pfvf_map[prof_idx] = 0x00;
 			ipolicer->match_id[prof_idx] = 0;
 			rvu_free_rsrc(&ipolicer->band_prof, prof_idx);
-			if (idx == MAX_BANDPROF_PER_PFFUNC)
-				break;
 		}
 	}
 	mutex_unlock(&rvu->rsrc_lock);
-- 
2.42.0



