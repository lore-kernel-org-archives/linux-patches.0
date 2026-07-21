Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7484418F5;
	Tue, 21 Jul 2026 22:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671865; cv=none; b=HKRNm65w/pNSv76JNZd5DyTb1+TFFQngQb5fhZqOl/3TRzt74nXo0B/+do7T90LSmtO5cU9q/IuRQjtw/rBOgQzzDYugC1vYuf7sR7SsTd4zX6taLESYmXQcsLEaYcUTbQtQYpnrmR8Wew7g5nyDhKBHps3C1jsTb2Grbq+jCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671865; c=relaxed/simple;
	bh=tX7g2qLVw0MA6wRgrtydmvRpPNL2h7y7QO7GLqKYtnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8L+hOHAx12yU9s6VyiBrV9ttf0Ef6o0qrmcQzxv3YV+cLRWO7epcrpjAWfgE/VfLPnOxNa7+xdkvcmGUcPbP1UJZ5kIlc7Lr7pECmz5lGqHRRvWhl3vC0eoCLp5Hhs8fp7jM5drAk3pS7/oU3UDc45gWmMp/vP9RfPEPNrJlWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgoP0jjB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgoP0jjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9901F000E9;
	Tue, 21 Jul 2026 22:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671864;
	bh=7xdOkfr7Sj2BbrgG3XJ0DoG7XevLCNNXO2Y0RSCn08Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgoP0jjBQgsoHyP+XSPrU6kgzfLLzeZvAbLTjfzENSkzkXbWiS9fQF8X2Uk/iPKsc
	 5qSfXbz3o78oEQkEwZnmxZxDHm/jfZaLjpEGhTfj65vzZ5s1d0dSFjtCKuaBqqZkw5
	 6K39CFRz0uO5a6wHrRkGKx+8+N+gyDzJU2dJ9joc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/843] net: mana: initialize gdma queue id to INVALID_QUEUE_ID
Date: Tue, 21 Jul 2026 17:19:50 +0200
Message-ID: <20260721152414.019624960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f3e90313a4487d..5963c4ba0f2c53 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -776,6 +776,8 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 	if (!queue)
 		return -ENOMEM;
 
+	queue->id = INVALID_QUEUE_ID;
+
 	gmi = &queue->mem_info;
 	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi);
 	if (err)
-- 
2.53.0



