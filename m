Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C3917CA12;
	Mon, 10 Mar 2025 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629049; cv=none; b=sKgDZsMvZOpTzuTrgC9YmZNE0B9zyunipkeeyyuc0QkNJZRRJjhqjtYjSYtLDmunN00npALi6y0dw7ptrjFoLOqkg60MWPybsjsmMrBLNJyd1LoN7fah07ODLSG5K1Fxx722UeSjh34kIHjP9Cl68lS0nBoJhIDYYo6pgt81dCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629049; c=relaxed/simple;
	bh=+iqRORjzSsPoSTDoXHM5lyn7OOfPK8dJ87BGu8/dPfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktHyEj1C2LJFesKjC43vZKFZfB4ksB9oCz9B8/OgqSfQmRkuYu1nEQhCe9m8pe/1gPL3DvGc7OOOfZ1bFCePA2u7i9JYj1lkZLFeKU92ZVTjrGM98OWzXVB4YA4G3OySGGjam7wpIAeQmKqFI1hfLVgZ9vAz4TgkdVLpVNmDMFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lH8Rea6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lH8Rea6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6DAC4CEE5;
	Mon, 10 Mar 2025 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629049;
	bh=+iqRORjzSsPoSTDoXHM5lyn7OOfPK8dJ87BGu8/dPfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lH8Rea6B03QBDpAt0M8Jlm+GlaTbf/W1wgcyaBM7ZlVC92ugQQel6mxTsg07AxP/S
	 IunD3BnaQL35HKMbXyY7oFOIX7mThJHIQ/iCruSzXgoQfn/tchQKUrlrxAJ0B/j4cz
	 ouVckT4TH92zbFSNgMdiZqpcc8EUFgZuiyQ/tQcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pangliyuan <pangliyuan1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/620] ubifs: skip dumping tnc tree when zroot is null
Date: Mon, 10 Mar 2025 18:00:06 +0100
Message-ID: <20250310170551.932503198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fc718f6178f25..8386228131a29 100644
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



