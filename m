Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC74C46F4AF;
	Tue, 21 Jul 2026 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656765; cv=none; b=qVSKrzcOtV0oeU5wRDKrs/OeDfW8sTQNwUTIAZVdYZVPtI2vrSIO2Ms/c/aGhENXghCgTuz1TZvNdXEP8Q6J9UOfPG9MYSgyVHTZOC83YJtiUaWY4AKUEU0bVgL574xBhZxxGla6+aQ5yoVN+vs9LlxxR6Mqwfh5w9zGv7NGq8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656765; c=relaxed/simple;
	bh=J30idJVK+Ez/wtz4UwQP4Jwcfy0/Wexc7KQ3VenWFng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGU71kkV2UVTCL7M2RgVFQx5KgEBhVEClDOU0fdRQ5iA2HoKpb/YmPw26OpZwJb1198EZDoJDe2JgkECxRrKUT4XGyTTZfokIVj78d4ApwG1Y4XrSkBWTWi3zQo0uDO1w36Bo+Vn9SPHcndccYYtbhjH0l64ZhHt8VxTgEo2WVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yh9LM6u/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yh9LM6u/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4731F000E9;
	Tue, 21 Jul 2026 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656763;
	bh=vLkZnEhflMZk30716zLTKoIi/YEqp0qiDIftB0PKqWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yh9LM6u/eY7eqESIzGewFNo18Zx6zW7DmLIvTARkklndrdA6MGrBB4n9AXuR0IZ0j
	 bCK08sBky9FPlwmO4BROnfQpW/gUE30Q6wug/VuKtXoYF/TDERn/5fNgKhSVjqVZrS
	 47JzMCCbq+b+So+RypHSTNJsyXy6XMG9+sMizYXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0508/1611] net: mana: initialize gdma queue id to INVALID_QUEUE_ID
Date: Tue, 21 Jul 2026 17:10:24 +0200
Message-ID: <20260721152526.775321859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 45ee0774522a10..243f8d11be6848 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1119,6 +1119,8 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 	if (!queue)
 		return -ENOMEM;
 
+	queue->id = INVALID_QUEUE_ID;
+
 	gmi = &queue->mem_info;
 	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi);
 	if (err) {
-- 
2.53.0



