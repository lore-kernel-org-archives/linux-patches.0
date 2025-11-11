Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF64F3431F8;
	Tue, 11 Nov 2025 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825172; cv=none; b=lDKuLAB6pgzK/onHEIUPBYZ4fvDkBRZZ9urb2fdozRSfSM30lfKnjHddqFPg6cyRGZInBLC/4sz705sQHpRBxrB3lUeUSBVmtv/elJcSE1eHVzJgQ1dbQv5B7isCcnyIhV9kymvPaAX4gzQ9/DnFQP17rmgN9FFQy3D4+Q+yaes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825172; c=relaxed/simple;
	bh=ksGYd6J9Ha2Rbt4r4oV4AenUXAskaGB5Ta4g//rk100=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfdlmi4LB9KnGNhf+q5UZOlr6F1HvVV4kWi5zE3x8TXhaeyRdzz0uXQK3oRG4z9H/YtgiswGukpNOYZVoLzXQPYhfIPD1hCuqHZ1M/oVt4CC9sg5+nIgZEPr/X95UxlRVKwiOTId/+647cJHHQYBXnD/jT2KwImd4RRgEkbMWkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahfxu/5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahfxu/5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5EBC113D0;
	Tue, 11 Nov 2025 01:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825172;
	bh=ksGYd6J9Ha2Rbt4r4oV4AenUXAskaGB5Ta4g//rk100=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahfxu/5URSBSHj9NcMgiHqc04rlBxmJEPpk0b/VFw0FBMtyj6Ls4vY5sKMvVwV3TW
	 sB6TUyRQQhIemI8/8fGf3wWzMWdd8Y7M/MIzwwKywJgvgUF3Lg2WZAustl1NdmKwkI
	 /9Re1n81uqYA1YtUpu41HgiISSdg53R0McIxE6h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Shardul Bankar <shardulsb08@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 691/849] btrfs: fix memory leak of qgroup_list in btrfs_add_qgroup_relation
Date: Tue, 11 Nov 2025 09:44:21 +0900
Message-ID: <20251111004553.135584849@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shardul Bankar <shardulsb08@gmail.com>

[ Upstream commit f260c6aff0b8af236084012d14f9f1bf792ea883 ]

When btrfs_add_qgroup_relation() is called with invalid qgroup levels
(src >= dst), the function returns -EINVAL directly without freeing the
preallocated qgroup_list structure passed by the caller. This causes a
memory leak because the caller unconditionally sets the pointer to NULL
after the call, preventing any cleanup.

The issue occurs because the level validation check happens before the
mutex is acquired and before any error handling path that would free
the prealloc pointer. On this early return, the cleanup code at the
'out' label (which includes kfree(prealloc)) is never reached.

In btrfs_ioctl_qgroup_assign(), the code pattern is:

    prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
    ret = btrfs_add_qgroup_relation(trans, sa->src, sa->dst, prealloc);
    prealloc = NULL;  // Always set to NULL regardless of return value
    ...
    kfree(prealloc);  // This becomes kfree(NULL), does nothing

When the level check fails, 'prealloc' is never freed by either the
callee or the caller, resulting in a 64-byte memory leak per failed
operation. This can be triggered repeatedly by an unprivileged user
with access to a writable btrfs mount, potentially exhausting kernel
memory.

Fix this by freeing prealloc before the early return, ensuring prealloc
is always freed on all error paths.

Fixes: 4addc1ffd67a ("btrfs: qgroup: preallocate memory before adding a relation")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Shardul Bankar <shardulsb08@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index da102da169fde..4958c6b324291 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1539,8 +1539,10 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src, u64 dst
 	ASSERT(prealloc);
 
 	/* Check the level of src and dst first */
-	if (btrfs_qgroup_level(src) >= btrfs_qgroup_level(dst))
+	if (btrfs_qgroup_level(src) >= btrfs_qgroup_level(dst)) {
+		kfree(prealloc);
 		return -EINVAL;
+	}
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root) {
-- 
2.51.0



