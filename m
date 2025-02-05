Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B27151988;
	Wed,  5 Feb 2025 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766168; cv=none; b=UXUWuy0ChvcSL07lABktLEdzHmxEvTdk7fkAASy6zUsd9KYryYHsYS1Ew9vFxAdxdN9JaNzawUt1eqDAKl6QFapZQGOS72OBF7Xy7t66OJyw6XZZVs7/1eXJKkozBxPQtMv0laY5kMV5v+4/K+AjdhyMJE/6n3aWCQ3Iwjuxfwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766168; c=relaxed/simple;
	bh=pjtqb7pFt+bPzvsBHSPZu8tVuaxmiNlVJ0Vj28mfmL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku++2uPe+iPV0wEi2UdkFlnvAnnsEk3k1JJQuZlTdXtn1UTaGtDpa8tDQeTSdlq3ZSAlMgN9AovRb3awCfkH4Lu3QUHtZy/1Dwl4/s/2+DqSlClVzo35NozoJphN2UJc1G03yipxHrg8spRvGEB8k9F9djL67NGtsDY0LkLRfac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tbs2ZTpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tbs2ZTpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C30C4CED1;
	Wed,  5 Feb 2025 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766168;
	bh=pjtqb7pFt+bPzvsBHSPZu8tVuaxmiNlVJ0Vj28mfmL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tbs2ZTpGjLRGvb6YNQwTPcgD+vsj+5S9zUyuT0B3C7D3r/alwG+CBzwgVQ6NMwqLG
	 dxNAdzbBy8iHLRg5DnaAtmxuatt/qfEGvg622TTJNRd9S+2nDyb47ccRexvrU87+6o
	 wlkp+q+Ph9TVy/gI1ZDUshizFDQM/ybjXourAj2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pangliyuan <pangliyuan1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/393] ubifs: skip dumping tnc tree when zroot is null
Date: Wed,  5 Feb 2025 14:44:00 +0100
Message-ID: <20250205134432.596687884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: pangliyuan <pangliyuan1@huawei.com>

[ Upstream commit bdb0ca39e0acccf6771db49c3f94ed787d05f2d7 ]

Clearing slab cache will free all znode in memory and make
c->zroot.znode = NULL, then dumping tnc tree will access
c->zroot.znode which cause null pointer dereference.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219624#c0
Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Signed-off-by: pangliyuan <pangliyuan1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/debug.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index eef9e527d9ff9..ff9e574c07a87 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -946,16 +946,20 @@ void ubifs_dump_tnc(struct ubifs_info *c)
 
 	pr_err("\n");
 	pr_err("(pid %d) start dumping TNC tree\n", current->pid);
-	znode = ubifs_tnc_levelorder_next(c, c->zroot.znode, NULL);
-	level = znode->level;
-	pr_err("== Level %d ==\n", level);
-	while (znode) {
-		if (level != znode->level) {
-			level = znode->level;
-			pr_err("== Level %d ==\n", level);
+	if (c->zroot.znode) {
+		znode = ubifs_tnc_levelorder_next(c, c->zroot.znode, NULL);
+		level = znode->level;
+		pr_err("== Level %d ==\n", level);
+		while (znode) {
+			if (level != znode->level) {
+				level = znode->level;
+				pr_err("== Level %d ==\n", level);
+			}
+			ubifs_dump_znode(c, znode);
+			znode = ubifs_tnc_levelorder_next(c, c->zroot.znode, znode);
 		}
-		ubifs_dump_znode(c, znode);
-		znode = ubifs_tnc_levelorder_next(c, c->zroot.znode, znode);
+	} else {
+		pr_err("empty TNC tree in memory\n");
 	}
 	pr_err("(pid %d) finish dumping TNC tree\n", current->pid);
 }
-- 
2.39.5



