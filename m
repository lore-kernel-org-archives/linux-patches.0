Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58712399354;
	Sat, 12 Sep 2026 20:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243266; cv=none; b=jD52YJ3cwLnzob0k85aNoMINJo0MJY1qnXPwD7sFLs97sOnDcy1rmC0xfA+wGL/AY+P1qzwe0JH3SCqu5Mc6cUDk6+fbRYKzVdQYQ3yQ2k6QG7co/OB6pw+Ivlrh8Qt11wI6tmfRHNRxa3hjt/BsXrD0Cq6Mljblpcz06yCMtaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243266; c=relaxed/simple;
	bh=7Wd68GvbE8/Kly8D/It/9/jdt+Zx/1upssubColMhXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uumv8g1JNqUbqeapKHpAbySCcow3tkKRzVZMh9gNyEGUg0kItlBlDMJrnBVlZt+fSKW6F3QUaDFLzDaRbnZNHDK01UOLp2OOHc43Xk+7bBlMe+qkb//M4AsMRAuaFX6AtGGzMZLHR0QgsDTt4ouvAVq6z0Bu/59ZPKS0OHY3mwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lx1VYvGu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lx1VYvGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E6C1F000FF;
	Sat, 12 Sep 2026 20:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243265;
	bh=EUOz1hEG02UpAPk6c7PPNo3DUdVqlSCH1AcI5pLyGRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lx1VYvGu+L9L2fhEKr7elx4USEOz1iqkMEBNA087R8fZ23ipnlmrGdvC6UPjtackj
	 XrDw1v1qSpJeGcmoM5ahdefP9x4wYeQSNfXJqgZA5qyd4QrdSJuK50ySrjyDG48j3E
	 wFz2v3Rn0czImLd1fM8ioWug8Fm0PXpNMLJ3+bw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 693/798] ubi: Fix rollback for explicit UBI device numbers
Date: Sat, 12 Sep 2026 09:05:21 +0200
Message-ID: <20260912065532.980411911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 23aec732b08c8..c59b04d8a39e5 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1317,10 +1317,10 @@ static int __init ubi_init(void)
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



