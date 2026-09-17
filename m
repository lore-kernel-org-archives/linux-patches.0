Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DCA52CCC3;
	Thu, 17 Sep 2026 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664442; cv=none; b=PONMXZ/ZAxu8EGHGMJ2A6mtMH7/qEYISM0cujWYg16yxRcQBmdtnomJB5EkRGvEGUKktTtk3V+tZOTwW1X2s3noEnuBLSNMgPq856pcJKb4OxOUnIHhLYpSqRM1V6MyUVXb1YSuLwggGQ4fo7P6SZC0HgRGrJlOEmqYNpIvdd4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664442; c=relaxed/simple;
	bh=DYBOnIL5nsohE9QkGfJzUfxqPIalv/YJY4NLnjITrXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyBrm/qumOVrY2rd8KXrj1ajuwvsOYjyt1sz4egcvmLQ1VxgYhe/xJp0AslnzT0xUZe7xWxT9S6wheI2eQp+w5nNgWy5K0y4KzJ8HsGssgyUmu5EXKNJ4073yfIhsS13VUVvyoEIRR2pSD/B2bElob9Ai01YPME19aiFwwlWVKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cP4XyY0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cP4XyY0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379071F00899;
	Thu, 17 Sep 2026 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664440;
	bh=FlkrbxsHr0VYjf1yeNchFU+cLWufn/1ZgACVxuf/Pl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cP4XyY0mvPDe719JGP81YbsJILQxASuJxMUD6jnTLMUXSICiNhUhCgLiT8tqidBtE
	 ukR6bpwNWepdRcWoYvJyCxYS/AzuV8VZAUNLkqWcPI5lQwRUkmxGzbBYi9KUEnaTMZ
	 ezP8txDDMQSijkZynVDYrd9FJX5urbL7ta/Pz98A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0373/1250] btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
Date: Thu, 17 Sep 2026 16:02:48 +0100
Message-ID: <20260917151602.164487313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Anand Jain <asj@kernel.org>

[ Upstream commit df84f6c773771fa7b78fe06931709df1aca5907f ]

When mounting a cloned filesystem with a temporary fsuuid (temp_fsid),
layered modules like overlayfs require a persistent identifier.

While internal in-memory fs_devices->fsid must remain unique to
the kernel module, let s_uuid carry the original on-disk UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 15b6a67d17ddc..8863479a19d3e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3430,7 +3430,16 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	/* Update the values for the current filesystem. */
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
-	memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
+	/*
+	 * When temp_fsid is active, fs_devices->fsid is assigned a random UUID
+	 * at mount. This inconsistent UUID causes issues for layered filesystems
+	 * like OverlayFS. Since metadata_uuid may or may not be set, provide the
+	 * on-disk UUID directly from the super_copy.
+	 */
+	if (fs_info->fs_devices->temp_fsid)
+		memcpy(&sb->s_uuid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+	else
+		memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(fs_info);
-- 
2.53.0



