Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C991C6BE;
	Wed,  5 Feb 2025 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768130; cv=none; b=dIXcqIX/wdTeRcHqA6jX/lwh3gUw9a3LmXX+X4/NDd7vuTigcXbJpRfxXDd+6L0mROSThHRCq3D/N7MPhZFrgQXim4Pj9PeQtCB7cddYYZXtnkJ4TIveP8tkEvu9NRhPw5vn2eMUBtN8PwXUGgIisFTBavwhLpldNhGsN4HqhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768130; c=relaxed/simple;
	bh=zcdP1xKJTSLUrKfS8hZ2Ab9WVidYhW7zzvvl2VARslM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWv49fTSMCjQ32CemqHN4/2+EoasAWwIwJM0F5M22Oq2HZb5/Y+P15NMToKgj82mWBf/CHuBCG36QLGWUslvQsW/lfZUOM2Y2riKeBcMvu+IpANUn5ozisP2/rTljBBkYxJk24ESgZEY8Dcc+81OYGXxvR1EJ/U6YgdZErN+ri8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMLiftAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMLiftAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167E8C4CED1;
	Wed,  5 Feb 2025 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768130;
	bh=zcdP1xKJTSLUrKfS8hZ2Ab9WVidYhW7zzvvl2VARslM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMLiftAtRB02UlqqlBZXmXx67todZYfjXzyqMHg+YDqDixfmmpG7e60zEQQk7H6lQ
	 jddzrpV4VQQpQjxQLO2fNPrT+W1UnooTMK5fyTwYlIS0TcooF3CX6B4BoqGY0u4Fbw
	 fAeKcyRtfJ2Wvda62Bd5qEbOBbxdNDrCgWR2bZ+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pangliyuan <pangliyuan1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 502/623] ubifs: skip dumping tnc tree when zroot is null
Date: Wed,  5 Feb 2025 14:44:04 +0100
Message-ID: <20250205134515.424834658@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



