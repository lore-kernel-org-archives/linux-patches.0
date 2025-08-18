Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B1B2765D9;
	Mon, 18 Aug 2025 13:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522818; cv=none; b=SUDDhbb9zkLZzklIDk+1pTS5BYR9CvH7NDpRPGpzxRZFEGDjLr6GiqAE8UlamvTr6PgTHKbD2u5xE9lwCpmp2XKXyTMfMZPFvDxSa2MZLT+9q2H42wyt+BLT0tVUk5BzM3YYJHlWcFeeQJKGImgeuLrMxGZHk3LheJneSRQ+6CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522818; c=relaxed/simple;
	bh=nDbEx6jSJbmKSvPcXlwaCHejf1/Hb7T6Pd1uYbA/kfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaVTEPGUZ9KgCb+zj2cVTwc7iq2l7CnlfSxMS9RHTSCQqLcGXvjv//a6tsWVewTbjuL7uJOHEiHAi+Z9ZfDFqyMB8S6DrcanbsGuanTMMbivJNLyLLCUKAxq2MtNiPpPGVG3Uwmqks04W8ClBWCvAYCGBc9nhRrPecx+bLYBgtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6zwMu2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6zwMu2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F72CC4CEEB;
	Mon, 18 Aug 2025 13:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522818;
	bh=nDbEx6jSJbmKSvPcXlwaCHejf1/Hb7T6Pd1uYbA/kfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6zwMu2aUQatIE79Z6+JsUJGz5SzTqFfmzKCezu4hDQpxlV1dOy48MUSxlmXGRsEW
	 9JqzTfnCibxl+qft5MbBxecHpQ6XOQgoYuRYbq/IYI6MUKjQcixPugSWu34N9MJO4a
	 Dv77BJjWlDg2Cd4sG1Ke5vZbyCoEJBAmYhv0Fsfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 398/444] btrfs: qgroup: fix qgroup create ioctl returning success after quotas disabled
Date: Mon, 18 Aug 2025 14:47:04 +0200
Message-ID: <20250818124503.843224795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1701,9 +1701,6 @@ int btrfs_create_qgroup(struct btrfs_tra
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
@@ -1739,8 +1739,10 @@ static noinline int create_pending_snaps
 
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


