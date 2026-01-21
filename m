Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA4F374173;
	Wed, 21 Jan 2026 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019452; cv=none; b=LGKllaZVlvrOGSi+iq8k9SogvnRt5EXOJaw+IqnZEYdlQZ9Mf6RNsqzRhgLsVSmcyyiCQyNi8h72KadIrkh3oBygmJ84wHwpFA4T+hr8CxeoqN4jPl8tGB4DWcVMufR0rZfvULjphu6PjIp2v0lA5C5aUL1GBSWSqjLbTfJ1XZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019452; c=relaxed/simple;
	bh=pPbH8+48HttqKPukQt3ndh3Q3aDoR37CyCn/oru9UIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+d5dyQRgrU9sg5D6u0tKWAnKl5u9U23HZZ2ynCqUrfkYizCh3nI0PxpuSRKClbaHmo+TJEiK/PbvPlRvEfzKfc1S4fBKlBrhR1Su/fuE1lpDwBs3+GQVGx1LFShdODelztlRkg52NghT0b1mdae0ROm8/QdVrbXYZy3kMI1RuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfDps+jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfDps+jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3511C4CEF1;
	Wed, 21 Jan 2026 18:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019452;
	bh=pPbH8+48HttqKPukQt3ndh3Q3aDoR37CyCn/oru9UIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfDps+jrx7yz1apT5p1OsQRba59tUI7ea263BiEqKpEzXUW+sg7lca3JrCY77chuI
	 /LohCRgifup4aUtrMIKOoHhND/cfHwKCq91pF7k0sJTdKhAkqeAXBam//1wGv4PZ65
	 OV/bc1W47iANB/TQlYY1l/CONxN+yrM07ok0J2C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/139] pnfs/blocklayout: Fix memory leak in bl_parse_scsi()
Date: Wed, 21 Jan 2026 19:14:19 +0100
Message-ID: <20260121181411.865404197@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
index 44306ac22353b..22d4529c61933 100644
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



