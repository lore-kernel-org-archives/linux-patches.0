Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A833A4AAE;
	Wed, 21 Jan 2026 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019955; cv=none; b=fmv66zXqm3HdwnX9+kECGTzHOloMch15m5HT+mYlS7oH9XEvtNMJDnO+PwL50/7PY0noPopeKd6bc9lMZ5xk0XijJk9c/dYYEyKPTxrQW/A1JzARYSKBXy1oJIYgaf93YZVA3NtzRGShf0dmYkPszHDbELixlgJr9TAgty1qXIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019955; c=relaxed/simple;
	bh=qkCyT6zitwUKBAEVeyJ4zbODQBeIc8habor22+Jt3tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaTtnOtQIL1KdoWFMsPvk5dU781AbWPz5iG89dVgTlmlIJR6DV+21OFTtWGjn9TPHECJ99kxIuY9J7Wi362D2AsNdAuikG1C1rIuUcZ+9xEHfAaomcXmxm6e9NQxd3v/A6Vm7dSxZVwreI3iC2l19xHtOAoyvwCDqOrebryBuRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmn0eoHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmn0eoHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC06C4CEF1;
	Wed, 21 Jan 2026 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019954;
	bh=qkCyT6zitwUKBAEVeyJ4zbODQBeIc8habor22+Jt3tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmn0eoHl/iqH8oF2gnHAbLoF33mYhMx1zpeZR1x2916TKVICRQKepDQBAnayNe2XA
	 W9yO4aib1LaUljz7dEsW7bmD616zxEtq62DLSkG+ID+iN21DWACmFgGyGkVAcow69D
	 Ed2/BtEr9P9tcO+S/2a7k39RJ0V1I8XCJ3QGD73s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/198] pnfs/blocklayout: Fix memory leak in bl_parse_scsi()
Date: Wed, 21 Jan 2026 19:14:05 +0100
Message-ID: <20260121181419.173520571@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 5a74af51c3a6f4cd22c128b0c1c019f68fa90011 ]

In bl_parse_scsi(), if the block device length is zero, the function
returns immediately without releasing the file reference obtained via
bl_open_path(), leading to a memory leak.

Fix this by jumping to the out_blkdev_put label to ensure the file
reference is properly released.

Fixes: d76c769c8db4c ("pnfs/blocklayout: Don't add zero-length pnfs_block_dev")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/dev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/dev.c b/fs/nfs/blocklayout/dev.c
index ab76120705e20..134d7f760a33a 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -417,8 +417,10 @@ bl_parse_scsi(struct nfs_server *server, struct pnfs_block_dev *d,
 	d->map = bl_map_simple;
 	d->pr_key = v->scsi.pr_key;
 
-	if (d->len == 0)
-		return -ENODEV;
+	if (d->len == 0) {
+		error = -ENODEV;
+		goto out_blkdev_put;
+	}
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (!ops) {
-- 
2.51.0



