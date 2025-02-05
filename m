Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D1216EB42;
	Wed,  5 Feb 2025 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767561; cv=none; b=L+rNbf1P2LHvn89FC+E057miD0SpFXkhADRgH4xeeAGe3OAPEWDudek+OVEP6BL5CYqjDKJfGqS8CPwAypufbjrE+H/v9rakuunyRGgB5CrKo3FCFfmSV7QTacnJSUWwdIfY43frwXO1i+zS/M9Pt09WlMYT4WpwSTfiwECzl1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767561; c=relaxed/simple;
	bh=AxwwmeZl8qnHv+IxZwGjKwq5aDVvOKKxaleUa/PZ9T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQJ4QPSGUFOww9HnMRWYF598L+LPedBB4ghjXLO5UxUHql/A4lRrWW4o/fyWSYtbSBMElL/Cc9fEdnNZOb6N22/+8QHadaRlvAHAKcdhWIjFrrpTMU66Kjp3bsijTCGYm0Pmm1BVxfVJZOGazMiFiZYyyl0W5Z4S7ylg+BP60l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugdYaCw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugdYaCw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51271C4CEEA;
	Wed,  5 Feb 2025 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767560;
	bh=AxwwmeZl8qnHv+IxZwGjKwq5aDVvOKKxaleUa/PZ9T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugdYaCw0YteBLYDk4PuUXOVBj/XBx8/imrvTwB+i9LoljmbiFkUvKB8VLBSyhOgeS
	 MoAGVwxXvLy8BzmlH0dntTUL6Z4lmpgic6kHFFn5vqcJJqrzBgat24d2PeFCWFjGoY
	 e6KuY3d9l2r/6rOBdvAkETChlqc+1rtrMLGlD06w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pangliyuan <pangliyuan1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 471/590] ubifs: skip dumping tnc tree when zroot is null
Date: Wed,  5 Feb 2025 14:43:46 +0100
Message-ID: <20250205134513.280558355@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5cc69beaa62ec..10a86c02a8b32 100644
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



