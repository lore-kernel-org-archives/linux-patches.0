Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DE61C3BEB;
	Tue, 11 Mar 2025 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705634; cv=none; b=GrY/cYkoCA0lanIKi0g7L+JSOioE+OVdRlP0JQDnVMuN6dvoyKp8PqGJ8dyRhwo9OOXSugzc0lBOSplMbaqB9tV70jpEOhrp8+GHzKLUC69ST5KD9yrCNmoStYmkMFMkQxr1AmS7ZLnHpbkkvaPDg8ICdGmMZu/NFlTuPlZlUGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705634; c=relaxed/simple;
	bh=bDbYitq8b1IKekQzWXAa+HhS/h0tOV+Mdd9RPuU5ZqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4MZBjRjbZPjfVSXONMbe2LjdToTYVUwoYKZIhLB9IMAKWzK6FTzDCP5KKS9c7xQy0JzApvPgy4R0hQlPgfUPAmIJzg22NU06SsPQ9s/rxnS3cGO1dGZB55m+dfhW5cGX2us9GDkvQQu7PLyAjLJ/mKfPY1I5+elpfjcHzG/y/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nc+rKnix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nc+rKnix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBDFC4CEE9;
	Tue, 11 Mar 2025 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705634;
	bh=bDbYitq8b1IKekQzWXAa+HhS/h0tOV+Mdd9RPuU5ZqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nc+rKnixbmmo73qqixZTAs6V0zlU9reJwEP1vx62yQRCt4e06DDGCiOnH+kuqBQh1
	 ilHiZrfSjEOGCFDRyjEvnoxbbPVJaeyhOA7HdLMOjvo7viW8lGZi6ETMoCCJXA0Vxq
	 8Uvr0Qwsn8RBSahDULpJPiDM0OaDKq+4RaXJGGkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/328] btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling
Date: Tue, 11 Mar 2025 15:57:34 +0100
Message-ID: <20250311145718.225783126@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6a4730b325aaa48f7a5d5ba97aff0a955e2d9cec ]

This BUG_ON is meant to catch backref cache problems, but these can
arise from either bugs in the backref cache or corruption in the extent
tree.  Fix it to be a proper error.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 89ad7e12c08bb..062154c6a65f6 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4789,8 +4789,18 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 		WARN_ON(!first_cow && level == 0);
 
 		node = rc->backref_cache.path[level];
-		BUG_ON(node->bytenr != buf->start &&
-		       node->new_bytenr != buf->start);
+
+		/*
+		 * If node->bytenr != buf->start and node->new_bytenr !=
+		 * buf->start then we've got the wrong backref node for what we
+		 * expected to see here and the cache is incorrect.
+		 */
+		if (unlikely(node->bytenr != buf->start && node->new_bytenr != buf->start)) {
+			btrfs_err(fs_info,
+"bytenr %llu was found but our backref cache was expecting %llu or %llu",
+				  buf->start, node->bytenr, node->new_bytenr);
+			return -EUCLEAN;
+		}
 
 		drop_node_buffer(node);
 		extent_buffer_get(cow);
-- 
2.39.5



