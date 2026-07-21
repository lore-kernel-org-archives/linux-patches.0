Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264113B4E8F;
	Tue, 21 Jul 2026 20:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666160; cv=none; b=CYTNH79sDh6uD8o4jCYKZzCrIEYuPiEJmiFBt1/EhIyUbg/02wFakom8YTFOxr1vJF0uoXyOjMcwygPHLwGIa6HeOfAwaSVnEJd63gn2/MKdLMm2x9qIILbrYYR6B0gPgtDlo/MEOz8lQFApHhtSO0/p5bdRjbmHAjo6p9hhU24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666160; c=relaxed/simple;
	bh=AUwJ5s5mC2/gundZIKxOal6czxw1ckWMloF7DyH/qh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEUzCOZ6RrnQPjRh5xhiD53RR1mb5ofWDjqapUHnbWTsHZlVvy3ECPFeameGskf01BkAUU6hDRR8NbZTxdzPrqninyg7YkLssWGy5k+XgQlffxCT6ct3n87u13TTdSwX8YBFTDeYfSCs33mM5pJNDRgmsCBu2dmsWe7ejXo2DYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saoWlXZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saoWlXZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC5C1F000E9;
	Tue, 21 Jul 2026 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666159;
	bh=KPmB78weoyGZvIl/OZ/3MXzupQTTnQyfDaOjF3DUIVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saoWlXZyyQilQMOTYe3lbvSoHoegkkW4x7tgkjWU+RpkPbSa418kpn9ath1gP9Xz8
	 L6bhepO+yeVNNeum0TnDLMpsLC1qPczxnBMAIeFFUGo6G9hxxcNmrjWg40S1cObIIL
	 6iS4/w+b5zlyXPXZWj6GKAqt2xYy6AGUcNgGMAI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0577/1266] net: mana: initialize gdma queue id to INVALID_QUEUE_ID
Date: Tue, 21 Jul 2026 17:16:54 +0200
Message-ID: <20260721152454.778547043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit 5985474e1cb4034680fac2145497a94b0860be50 ]

mana_gd_create_mana_wq_cq() leaves queue->id as 0 (from kzalloc_obj())
until mana_create_wq_obj() assigns the firmware-returned id. If creation
fails before that, cleanup calls mana_gd_destroy_cq() with id 0, NULLing
gc->cq_table[0] and silently breaking whichever real CQ owns that slot.

Initialize queue->id to INVALID_QUEUE_ID right after allocation, matching
mana_gd_create_eq(). The existing (id >= max_num_cqs) guard then
short-circuits cleanly.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/20260608101345.2267320-2-gargaditya@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index d3c9a3020fbf6e..8a91b056931fa9 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -840,6 +840,8 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 	if (!queue)
 		return -ENOMEM;
 
+	queue->id = INVALID_QUEUE_ID;
+
 	gmi = &queue->mem_info;
 	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi);
 	if (err)
-- 
2.53.0



