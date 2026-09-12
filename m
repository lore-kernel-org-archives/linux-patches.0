Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4CC288B9;
	Sat, 12 Sep 2026 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231361; cv=none; b=NDDfifM/BEhvz6TXBV+gM9oqlJgZ+vgezhNly/BNocLUxtQ56HRMr3jFgcpprt5C7TNQj9GmM00YrDtX/CQph80uas7UJB/D3ViWPURgPrfK6lRWmcdVFnlZT9+kG04+/S5tiUGYWLzfMOmO0pfurYJSCFdW8GJUsDNVLJHa1W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231361; c=relaxed/simple;
	bh=R3eondfBmVIVIqinA05WbOK7NP0YCpxd+V4v51niVz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPB/XHRfCwl6W9Iqc0i6caZIlAmjiX1pzZTeoFHaXX6P8HM/MFwGrqItCtuNLmT/KkPKgZRvhXX+gUXhWfp6LhzZOHSR0OeVz8ZqNQtdyULw6gYXbwMtUY4Bkdz9txIuhnOYGKtkxVpIsoLs6UdWDacUVk/LEztO9KiJkjQ0QJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5KBs5Bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5KBs5Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557001F000FF;
	Sat, 12 Sep 2026 16:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231360;
	bh=ZpHcHlKoFqpcd8o8zNAMcGigs4rpruWKbhAz71A8MMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5KBs5BgGD/KIix2id6hpkWPX2H2YPiB23u1EYz76yk20n4sYfOqlo0FFr1nGP7Zv
	 8gEx3rvqj0Q1i4qh1PztiA23tGU9zKaZ/xMHdwTg2mTLj3L6aPvigooQP43DptxzP4
	 50G/PTuz2+fdP2seUfZG20K8ywiOVbSIiw/VdEu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0984/1191] ubi: Fix rollback for explicit UBI device numbers
Date: Sat, 12 Sep 2026 09:01:52 +0200
Message-ID: <20260912065610.307409940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a0f4f4be17c0a..184a68dca2439 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1316,10 +1316,10 @@ static int __init ubi_init(void)
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
 	ubi_debugfs_exit();
-- 
2.53.0



