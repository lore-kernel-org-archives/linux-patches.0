Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DCB364038;
	Sat, 12 Sep 2026 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203494; cv=none; b=AtvDnBkKUYTYKdTICzybJwFrojYcJHzce+57loxC8osT4ca4hugD70pleS6oJySlJGaeSto4BFN6B+nwqqRYt5jeLmvciffX5W0OBXG4MDGf5EiGPvzvWwght7lN/sbFIlPTYqfFk7LAggwSjIHM2niJ/FKE84cnHyPUzyRSlFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203494; c=relaxed/simple;
	bh=FJ2J6liEVTU3yOgD8DXzTrMM4xeF4zNGqSm9yTJ7OtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOF7qRo9wC7/uIGMmoxwhJicRgPFMxdwexv6eKsw0F6h82W9Yrb1GqajCRdJkFVJCHzZ0xv2lDx+/MFbsz2SVlHNINGch3ZAjf85i9cXPQHpwL9Xe8xsPie7frK+9+9E6Nki9SPTfWC+JZMtJUIp/iM8daukEBZvahiRm9Wx6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCnZC64v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCnZC64v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2F41F00893;
	Sat, 12 Sep 2026 08:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203492;
	bh=aSXqKNlCZgN2OWxzh1cNjz2HcH/Fj/xAsRdqjgCCyI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCnZC64vts7fM5Q9Bxqdr2rHK4lmf0XsvvyBVuY0QDDbtmFAKntDBR6DFMknR6//R
	 rHbG4oXRU5xN/TdXaQbXmh06X3djZzynjRtKCfX9sfIEYNwGqQEPtviQEbJADRKzJe
	 YmWalfwu13DMHj3zP9Mk0YAemMJEXbcXcbdR2/CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1377/1815] ubi: Fix rollback for explicit UBI device numbers
Date: Sat, 12 Sep 2026 08:52:07 +0200
Message-ID: <20260912065721.353411410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 674ad87809df0..90c5c83d90e3b 100644
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



