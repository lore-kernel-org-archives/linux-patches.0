Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CBA3E9F9E;
	Thu, 17 Sep 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667962; cv=none; b=lSDkew3J5//jOZYNZ25fEV0K+ytv1FZwkpGAOdXHPExb2q9qTht2c0RNRUQGZZLX6Vbq2UXRv5CsIoLV1v5Q3KRCtZdy47bqOXxA2Y/0cq7+9LLG8DRaLbveVidSBb4prBN0hT9eyEDy9xjldJc1WZ1G5/uARheite6RErb1p34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667962; c=relaxed/simple;
	bh=mMLurybXFoxMZjJpSuin0mHoZFBauZUbuYeHkZn6+vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTYl21Wd+v9+pvFvTCy2JJduPSxhTuJziZXCFv7Nd5Sldsi6g37ieih8hTMQ734pSxjMfAM8ZYtX5CvsSXVAXF4lIccNHH0XzlpRXgKPvL7SazMwI35gTwy1u3a7lCqlLGhJ37Ui26g3feoY2ES09leyMhFPCKT34nYjXLxp4BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjESgwVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjESgwVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EE41F000FF;
	Thu, 17 Sep 2026 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667960;
	bh=Z4A+ECbBr0r0hG0ptaBvjz59xwkeqKkLDxL8p1akjPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjESgwVaSlyQeTHdIvlWW7gJhBSDM1JcIDoqHE/j67+gp+WFjiT2diU9NLuan9Olj
	 64hbntBvxQgdH+WUmIYtxwwy4dKs4ILI+6/YUpFt7syLYQ682Vc8fyobYIc+YCHofy
	 mK9Lto47EGLO3xNIU8pMv0a4rp6gplqQ6vQD5d9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0267/1102] btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
Date: Thu, 17 Sep 2026 16:03:30 +0100
Message-ID: <20260917151546.307493989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 8befa96374a9c..b0035d13286a4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3339,7 +3339,16 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
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



