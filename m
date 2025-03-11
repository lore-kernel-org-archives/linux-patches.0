Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AB133EA;
	Tue, 11 Mar 2025 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706669; cv=none; b=RL4/Rr8ImiIVZG0HzkxgZuMUSZGJnZcPfwzcf5UH+6rqN/0mkJeakr3pZMZmsThfpY6cOKtLP6Y6mS4lGo4F3gF/sZ3stMH7Y5wHH8uUeazhQsssjRoTg6aewa0KvnPS2Zj5IUVQ1OSIpjbIcJB40+MiSqzyfNIhcczMK4C9HvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706669; c=relaxed/simple;
	bh=ENh4KDfIQQ1faQrJSmYevCKh4UxYK39jjoIVOXRTPBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmnYLx9YPYbISFveFtOMiWPLDTGGUT62BhdGrJrM0qHxCJTVl+cjkZFp1yELs0QoROOZ4N4Wc+pboHhM0fNdjvtDJ+g91NUbsv+kIpGOM7dzBVBQiXk+2gFQW2Qk0bv45ToDSnHyCIxLD6yqaNN41sv8Fncnf3dEZlyiRnqqevQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUufj4PA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUufj4PA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA1AC4CEEA;
	Tue, 11 Mar 2025 15:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706669;
	bh=ENh4KDfIQQ1faQrJSmYevCKh4UxYK39jjoIVOXRTPBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUufj4PAhoHvDy23PP+77v0LlhwoxrLTOTdRclYvmo3e5OEbuu0KWGKmw+lrQcKX7
	 TAs2zLfVFvplewLZIfcJCXvgfTqMd1Qm/cyXHRtOn/vwlstikz2d5zkWFtjJIOFefc
	 zWwdo9neFnh7YYInhqZWVsZBTemFXN0UI7ZH+v7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/462] btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling
Date: Tue, 11 Mar 2025 15:56:33 +0100
Message-ID: <20250311145803.376658995@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 98e3b3749ec12..5b921e6ed94e2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3976,8 +3976,18 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
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
 
 		btrfs_backref_drop_node_buffer(node);
 		atomic_inc(&cow->refs);
-- 
2.39.5



