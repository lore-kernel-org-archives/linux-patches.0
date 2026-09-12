Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63884221F26;
	Sat, 12 Sep 2026 11:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211030; cv=none; b=d+c6Ev5hE4xz9e3dbRVKdB4vFO8ao9GML0yVfpILM/IrTKVZOGsG2VMz8ZwZ4CalHrLGN7unPopIvIC/fZMAjYshhJ9iU6bFJWxUpvfbupM3dKIDnNjwwvrHleg6bvt6kvu1giH/n10KEyOTSbrm2qvD2S1/xAw+Le/46vYSzX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211030; c=relaxed/simple;
	bh=GGepD6d5W3zztBMRWc6QQOon+JsU86ApNBFEuFWWi4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxi+jzMVfC3TGlqTPYwvP10sT7iegd6A4dui7cWwUwMCktAyy5X9HBJLvVsFNKL7N5LEazG2DTD+hJkYyo+z1/DQUJ/yawUK+g8c2pDzpuaPuO0XJwH5YXIXLKquNgYpRoaCRJkF3YDMaC2EOxxo/O1B6yy6vEo8NcDqm49khXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5l2M/UD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5l2M/UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023E21F000FF;
	Sat, 12 Sep 2026 11:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211029;
	bh=3t4nSoN1HlzSTjjx9OeT2av2L4Vp5vgZTqTZgwecmIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5l2M/UDWpF5xi0ScDKCbtVy6IQtQbeH0BPLNA5rRj4lYxf6W2qxfW8VAohhZWdxJ
	 Gwup7f+V+bWFYfFu/OD/l2hfFrkX+YxRhOQK975qcrnDVr4X1s1MfTsw2XBzuR4ylP
	 gcna0HYhFqnBVovnNU3iLRuGcLqQmX+s4Wl5wfP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1145/1518] ubi: Fix rollback for explicit UBI device numbers
Date: Sat, 12 Sep 2026 08:55:14 +0200
Message-ID: <20260912065649.359446737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 5b0a6b554e12a97f9771a9a9f4ea1f5457373c73 ]

ubi_init_attach() rolls back module initialization failures by scanning
ubi_devices[0..i-1], where i is the mtd= parameter index. That assumes
the parameter index matches the UBI device number.

That assumption is not true when mtd= specifies an explicit ubi_num. A
successfully attached device can be stored at a higher ubi_devices[]
slot, and a later failure can miss it during rollback.

Scan the full ubi_devices[] array and detach by the actual array index,
matching the way UBI devices are stored.

Fixes: 83ff59a06663 ("UBI: support ubi_num on mtd.ubi command line")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index ef6a22f372f95..d8d3317f9763a 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1317,10 +1317,10 @@ static int __init ubi_init_attach(void)
 	return 0;
 
 out_detach:
-	for (k = 0; k < i; k++)
+	for (k = 0; k < UBI_MAX_DEVICES; k++)
 		if (ubi_devices[k]) {
 			mutex_lock(&ubi_devices_mutex);
-			ubi_detach_mtd_dev(ubi_devices[k]->ubi_num, 1);
+			ubi_detach_mtd_dev(k, 1);
 			mutex_unlock(&ubi_devices_mutex);
 		}
 	return err;
-- 
2.53.0



