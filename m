Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAA933993;
	Tue,  6 Jan 2026 17:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720830; cv=none; b=b29+eC9y4YGzG4f91T5fBJUPpum/FrBGZSaOvdcFOktlzwtAodZKKY3VwGPQxM7KAlf1GobZw8vDysyPDgtsfdZ8e8cS+WRsfNKgAoNy+Z9q8wryxUfl5C7HpqqclLbpBcXPhX+MGCTLEeryLE37vcw8DKoMwbHnS7gPhIQBLaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720830; c=relaxed/simple;
	bh=jIXVaLoxF3lnlj3LLwJ8NFEbeezuWL2WZquky5s/YSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knsRziJs2ICudbr1yagB1QYR9Z9NcJjZPVYqwD0rdBNpohG6n8iOyQauo41X+T318MyGGco+JDKxVsHFk6DZi2mvWU8dTjHPmimpqmcxi3ZpweP/Dl0zIfqTZ5V9lyK3spX8PH7bOwEMZF/O0sdA/yOIg1R1MyizegpcIifXYLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxEAbJDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxEAbJDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08FDC116C6;
	Tue,  6 Jan 2026 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720830;
	bh=jIXVaLoxF3lnlj3LLwJ8NFEbeezuWL2WZquky5s/YSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxEAbJDJj6xuizfxqAsO1GQM2eXXdExwfahhriSJl9Zp1TsTb3TvIPrrTzq0lyW+r
	 hbSOuLYT0EWoj0pPgYTh+6tU43wMqMiPou+HnZe4P27VQ7aqo66veycj8X73ZcFDhR
	 I8iGj6zEotb6sxTgloZ1r6VsnLpPNjizo+GeOeYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/567] vfio/pds: Fix memory leak in pds_vfio_dirty_enable()
Date: Tue,  6 Jan 2026 18:01:44 +0100
Message-ID: <20260106170503.236756478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 665077d78dc7941ce6a330c02023a2b469cc8cc7 ]

pds_vfio_dirty_enable() allocates memory for region_info. If
interval_tree_iter_first() returns NULL, the function returns -EINVAL
immediately without freeing the allocated memory, causing a memory leak.

Fix this by jumping to the out_free_region_info label to ensure
region_info is freed.

Fixes: 2e7c6feb4ef52 ("vfio/pds: Add multi-region support")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://lore.kernel.org/r/20251225143150.1117366-1-zilin@seu.edu.cn
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/dirty.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 481992142f79..4915a7c1c491 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -292,8 +292,11 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 	len = num_ranges * sizeof(*region_info);
 
 	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
-	if (!node)
-		return -EINVAL;
+	if (!node) {
+		err = -EINVAL;
+		goto out_free_region_info;
+	}
+
 	for (int i = 0; i < num_ranges; i++) {
 		struct pds_lm_dirty_region_info *ri = &region_info[i];
 		u64 region_size = node->last - node->start + 1;
-- 
2.51.0



