Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AFE30C37D;
	Mon, 18 Aug 2025 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524540; cv=none; b=OM1g617Ci7KELEvFLhl4F9/OOyvqGFAefDR6YyFidKDRFVMIXu1oInf2dL+IX2+nwpiVhJbDs2OBSKWveEDvup6igWbz3HHuWWesd+EHAI9c4oo8MPVrDQ6XUfxwW/EcLbMt51yglW+EtQjdCJUuAjzILsBO3DxvYOz3KROK7aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524540; c=relaxed/simple;
	bh=Gvk3ywyxTn02MVbFKPjtSPoDtdbMb/vwSirCps4vIbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJL0aRWYrYGUwPThCdQKQFwjKO6a/XGG2ZKf2+mBZ3ZWFBhoauyIJQPmRT4w8WJCUyVYIMKUxNAJpVrYSf1nxasCnaNbb8UE5yK+YV/Pb/dAsGrMDXInCFLfpGZaQwHk+mlT/JR62/lvI9zZqEKek1VkfFQLzwMXbetb1zqJZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFEy2gvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFEy2gvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37827C4CEEB;
	Mon, 18 Aug 2025 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524539;
	bh=Gvk3ywyxTn02MVbFKPjtSPoDtdbMb/vwSirCps4vIbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFEy2gvHOItZ1+hHFudbyMYBEXTUAXiYYs5GPwyTNLFxv4Nz7lNF5oZeeBC7PAPMJ
	 VGXpYgBK53tm4OhXEj7jhWpTQW/4IYb0rMW5UxXi/FLPj9HqUW6tvgdV4LBWAlqgWS
	 UxUXoY749pGLU1fguWsfbtO8sJ/rRR7vJIbhuyEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 472/515] btrfs: qgroup: fix qgroup create ioctl returning success after quotas disabled
Date: Mon, 18 Aug 2025 14:47:38 +0200
Message-ID: <20250818124516.591415449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 08530d6e638427e7e1344bd67bacc03882ba95b9 upstream.

When quotas are disabled qgroup ioctls are supposed to return -ENOTCONN,
but the qgroup create ioctl stopped doing that when it races with a quota
disable operation, returning 0 instead. This change of behaviour happened
in commit 6ed05643ddb1 ("btrfs: create qgroup earlier in snapshot
creation").

The issue happens as follows:

1) Task A enters btrfs_ioctl_qgroup_create(), qgroups are enabled and so
   qgroup_enabled() returns true since fs_info->quota_root is not NULL;

2) Task B enters btrfs_ioctl_quota_ctl() -> btrfs_quota_disable() and
   disables qgroups, so now fs_info->quota_root is NULL;

3) Task A enters btrfs_create_qgroup() and calls btrfs_qgroup_mode(),
   which returns BTRFS_QGROUP_MODE_DISABLED since quotas are disabled,
   and then btrfs_create_qgroup() returns 0 to the caller, which makes
   the ioctl return 0 instead of -ENOTCONN.

   The check for fs_info->quota_root and returning -ENOTCONN if it's NULL
   is made only after the call btrfs_qgroup_mode().

Fix this by moving the check for disabled quotas with btrfs_qgroup_mode()
into transaction.c:create_pending_snapshot(), so that we don't abort the
transaction if btrfs_create_qgroup() returns -ENOTCONN and quotas are
disabled.

Fixes: 6ed05643ddb1 ("btrfs: create qgroup earlier in snapshot creation")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c      |    3 ---
 fs/btrfs/transaction.c |    6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1690,9 +1690,6 @@ int btrfs_create_qgroup(struct btrfs_tra
 	struct btrfs_qgroup *prealloc = NULL;
 	int ret = 0;
 
-	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_DISABLED)
-		return 0;
-
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root) {
 		ret = -ENOTCONN;
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1736,8 +1736,10 @@ static noinline int create_pending_snaps
 
 	ret = btrfs_create_qgroup(trans, objectid);
 	if (ret && ret != -EEXIST) {
-		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		if (ret != -ENOTCONN || btrfs_qgroup_enabled(fs_info)) {
+			btrfs_abort_transaction(trans, ret);
+			goto fail;
+		}
 	}
 
 	/*


