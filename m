Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A67BB1E;
	Wed, 21 Feb 2024 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524580; cv=none; b=douMLssL/YShT6xd1JZjnxXbIBsFfT/Ah6eKITzS5nHleCN/wKgdzwTokmCOmpgkbUBQVhF1g2U5oOofoxefBILL7e8L1/MJp1XNxVhHmJs9nHT+mGimxcATfVyTC/sQ/3kr/+SIDMpLw1KJsYDwV7ekov9wl+tHBafprdV9R40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524580; c=relaxed/simple;
	bh=GHtq9do+4VY9UBt+Nj5mY+KweWeGjxLFuqrIuokV96s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwgP0kqtypyLO3sGF/WJrivwdTGYYWdXaCJP5bvTZcwJqkT8+AK5irvYZyAWHVxh9NAtIIZkaxWx8FjfhGUZVEvTVY8smmHdJmNKBLhfD6S3uaKusHKnPMWtDQwcR7FAEdelnah0weV5ealVMa7vgfaR285g8oXWg6DmpjNz+hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBtHB3cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBtHB3cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C74C433F1;
	Wed, 21 Feb 2024 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524580;
	bh=GHtq9do+4VY9UBt+Nj5mY+KweWeGjxLFuqrIuokV96s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBtHB3cTvt44wmNbzcL0FuykN5teQhj6eZ5W9QkDWkugTLPfLJda+Hl1n8vEjRq4M
	 oVFwfZH0CXvEC3ugIkgEBIcDNKSOlCb11G4dPVvo4XyZ7hFrwBUviA//CjkANuokTs
	 +oUG4l+Lz9Ccw2GeVW6p9Qaf5zWvfpqYS5mzxoIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 288/379] btrfs: forbid deleting live subvol qgroup
Date: Wed, 21 Feb 2024 14:07:47 +0100
Message-ID: <20240221130003.428595079@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit a8df35619948bd8363d330c20a90c9a7fbff28c0 upstream.

If a subvolume still exists, forbid deleting its qgroup 0/subvolid.
This behavior generally leads to incorrect behavior in squotas and
doesn't have a legitimate purpose.

Fixes: cecbb533b5fc ("btrfs: record simple quota deltas in delayed refs")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1608,6 +1608,15 @@ out:
 	return ret;
 }
 
+static bool qgroup_has_usage(struct btrfs_qgroup *qgroup)
+{
+	return (qgroup->rfer > 0 || qgroup->rfer_cmpr > 0 ||
+		qgroup->excl > 0 || qgroup->excl_cmpr > 0 ||
+		qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] > 0 ||
+		qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] > 0 ||
+		qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS] > 0);
+}
+
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -1627,6 +1636,11 @@ int btrfs_remove_qgroup(struct btrfs_tra
 		goto out;
 	}
 
+	if (is_fstree(qgroupid) && qgroup_has_usage(qgroup)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	/* Check if there are no children of this qgroup */
 	if (!list_empty(&qgroup->members)) {
 		ret = -EBUSY;


