Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7021F326D44;
	Tue, 21 Jul 2026 17:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655753; cv=none; b=rQN/0eeGuiA1wjb+sDbXyWsCEBB3Kb2as3ni9S01JcK8W+xQlgUqpBT97ZLJq1mlhqZEYHcDrzxDytX3kGvtb01/dLvWsq1C7NYdYJ1RKQTj2PrIzhrpaUl8zS2Ktbgc9lcnqIOkqmjLkLJluTPxHbpDAyidVH07s8S1e/udhso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655753; c=relaxed/simple;
	bh=1d9GJ0sLRwduNn89sjRBva09RzIdQ+s3MTz9g+gyPcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JU9qH0MUVfTwRpuCZ3f2nBQF/edqUSK7PmU71X8MJ9eHzvdbLHwLPP8xqX8GS7jp+GEXLGOpXFGBYExDFV1kr4LWxWOwuZLBYJKNo4RruZZ8uqcY1AH9qcsewxqLXGA7CTRA0eg+GiqMeQJa89PoTauPHInQ3QYToB1MKMGrn0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPzWNrUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPzWNrUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F91F00A3D;
	Tue, 21 Jul 2026 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655752;
	bh=szgiXWoGfOFJqZu6vP//LmPoOOresYviQws8lUSRubc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPzWNrUhzE7KtubTUiTIF4VOmlkaDHiA1iHCUimV3K85uUGqtuegg2uT9+YHeTJTg
	 SUEthU3394VKZf12nQXio9qVwtiI7eZAIDPsm8F3hKhYa93Gi/h9KQtTd0gl8mFVF6
	 0icuxjMSwbuqby1anzvf248TqGzbozZsGnZTTyJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0127/1611] nilfs2: fix backing_dev_info reference leak
Date: Tue, 21 Jul 2026 17:04:03 +0200
Message-ID: <20260721152517.727710092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit 665f192a2a11384cb7dc1be5f87d16438522a4ed ]

setup_bdev_super() already initializes sb->s_bdev and takes a
reference on the block device backing_dev_info when assigning sb->s_bdi.

nilfs_fill_super() takes another reference to the same
backing_dev_info and stores it in sb->s_bdi again. The extra
reference is not paired with a matching bdi_put(), since
generic_shutdown_super() releases sb->s_bdi only once.

Drop the redundant bdi_get() in nilfs_fill_super(). The single
reference taken by setup_bdev_super() is enough and is released
during superblock shutdown.

Fixes: c1e012ea9e83 ("nilfs2: use setup_bdev_super to de-duplicate the mount code")
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index badc2cbc895e1b..8ca3cf2ecdd271 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1070,8 +1070,6 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_gran = 1;
 	sb->s_max_links = NILFS_LINK_MAX;
 
-	sb->s_bdi = bdi_get(sb->s_bdev->bd_disk->bdi);
-
 	err = load_nilfs(nilfs, sb);
 	if (err)
 		goto failed_nilfs;
-- 
2.53.0



