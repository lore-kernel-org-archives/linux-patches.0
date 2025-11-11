Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE730E0F6;
	Tue, 11 Nov 2025 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824518; cv=none; b=ZGGIo2xsiSe0VcH26ITF/Dzz+RmQk4PpBwtNkfVGyrCQeF+T7DXkwNd2m2vk9rhE1SyKyPa2ExMXQtcNQfjgktplf2L4BIOfl3SZhoYFy6Uw/ggccofTEK6sXRTohj4dgVrSPPBlmzVyDdNAzPqD/5MDPlz/foFp1NPzjzFzdeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824518; c=relaxed/simple;
	bh=cSur7KQ2d8sY24UE8ZBzUoPxs3pfkNqk5zFx2eui8QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6PNj+WlAzdx52ECV6adBqLnL6dEDUuqEIfIOQQwcCbo+g0MUdmVxAY36wIStviMfNRmK6eemLzG9AMDTSHhxLJlZhpXvYQSAo3PG3Dxm8tFCXEw10DYu1NGungSOp3fLiRsh3+mZKBacsQaqCyBhGH6WQzT+iI2IBEdfxU5rW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZT8P38u9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZT8P38u9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D5DC113D0;
	Tue, 11 Nov 2025 01:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824518;
	bh=cSur7KQ2d8sY24UE8ZBzUoPxs3pfkNqk5zFx2eui8QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT8P38u9LXcJv84KT+gxdasQC94v9tXsMFvSPEazTimb90B7uoHKRufbiL0V+umO2
	 TZ93EsO9l1s0jQEq8qvjNBxpZJU4j8/CMCghNZ41b+BQgRDsQQpQCOckLjdVGrIvSo
	 sA69i6hOhFjxWeUjqve6RHRsnBy7EXls549XqqxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Shardul Bankar <shardulsb08@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/565] btrfs: fix memory leak of qgroup_list in btrfs_add_qgroup_relation
Date: Tue, 11 Nov 2025 09:45:17 +0900
Message-ID: <20251111004537.268366487@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 2c9b38ae40da2..3c77f3506faf3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1585,8 +1585,10 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src, u64 dst
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



