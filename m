Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A7E8837;
	Mon, 28 Oct 2024 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098381; cv=none; b=Zlqyh9xzx/5rI2ePhe7XalYAvzS6aP4xIw3SIVzhgz2rW33wVO3XX7YT9yIun1U3xP4tFMXcXWL0dBdrxvW/y6A7wFHzNwtV1fYrptHxfaYcHBPD7yq+B+40fl0YmJL1E4sCTewqVQ0k0JmLiLQ/8wG+fWS08X9k6CT//jHg3aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098381; c=relaxed/simple;
	bh=7WG31JQRnV63uGnjNX1mFYfUmtniXWsRBlPykdSiJLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkIvkIPMbaHbFrybL3Psv/r/v4/gSZ91yjMpVuJuV7EMAbBt2D62yEA2NqB0UUl1DgQUfy9jV0doZKPhpIsxK4C62lb9g34USkV8VtWhYSjizTzQZWVwLW5ktBSVhWoH1hBm70qLWasd/P19OoSoMV0NL/jjUq+0G1AxAYF7Suo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWPBZZXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWPBZZXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D48C4CEC7;
	Mon, 28 Oct 2024 06:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098381;
	bh=7WG31JQRnV63uGnjNX1mFYfUmtniXWsRBlPykdSiJLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWPBZZXpt0k+Kd1sHa8Nff6Cvet/DQInULk3cjuk/Fak9pcxmTkKKAF4wP3nUgI2X
	 c9S1LTb65dIowuWfIa8uQnfTWCzXbVnVpZxs9BWz0MySzNLF/FIg4fzx+5HM2NzbgZ
	 E3C8wUVUjbZMgYuwO1urNrSNwR55GN7uKGUD8Q40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 201/261] btrfs: qgroup: set a more sane default value for subtree drop threshold
Date: Mon, 28 Oct 2024 07:25:43 +0100
Message-ID: <20241028062317.090545510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 5f9062a48db260fd6b53d86ecfb4d5dc59266316 upstream.

Since commit 011b46c30476 ("btrfs: skip subtree scan if it's too high to
avoid low stall in btrfs_commit_transaction()"), btrfs qgroup can
automatically skip large subtree scan at the cost of marking qgroup
inconsistent.

It's designed to address the final performance problem of snapshot drop
with qgroup enabled, but to be safe the default value is
BTRFS_MAX_LEVEL, requiring a user space daemon to set a different value
to make it work.

I'd say it's not a good idea to rely on user space tool to set this
default value, especially when some operations (snapshot dropping) can
be triggered immediately after mount, leaving a very small window to
that that sysfs interface.

So instead of disabling this new feature by default, enable it with a
low threshold (3), so that large subvolume tree drop at mount time won't
cause huge qgroup workload.

CC: stable@vger.kernel.org # 6.1
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    2 +-
 fs/btrfs/qgroup.c  |    2 +-
 fs/btrfs/qgroup.h  |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1960,7 +1960,7 @@ static void btrfs_init_qgroup(struct btr
 	fs_info->qgroup_seq = 1;
 	fs_info->qgroup_ulist = NULL;
 	fs_info->qgroup_rescan_running = false;
-	fs_info->qgroup_drop_subtree_thres = BTRFS_MAX_LEVEL;
+	fs_info->qgroup_drop_subtree_thres = BTRFS_QGROUP_DROP_SUBTREE_THRES_DEFAULT;
 	mutex_init(&fs_info->qgroup_rescan_lock);
 }
 
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1407,7 +1407,7 @@ int btrfs_quota_disable(struct btrfs_fs_
 	fs_info->quota_root = NULL;
 	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
 	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE;
-	fs_info->qgroup_drop_subtree_thres = BTRFS_MAX_LEVEL;
+	fs_info->qgroup_drop_subtree_thres = BTRFS_QGROUP_DROP_SUBTREE_THRES_DEFAULT;
 	spin_unlock(&fs_info->qgroup_lock);
 
 	btrfs_free_qgroup_config(fs_info);
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -121,6 +121,8 @@ struct btrfs_inode;
 #define BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN		(1ULL << 63)
 #define BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING		(1ULL << 62)
 
+#define BTRFS_QGROUP_DROP_SUBTREE_THRES_DEFAULT		(3)
+
 /*
  * Record a dirty extent, and info qgroup to update quota on it
  */


