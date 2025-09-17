Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9668302CDC;
	Wed, 17 Sep 2025 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113328; cv=none; b=M1a6Aob1ecKUORhgtoZya2BXlTCUeSMRilvjRoJEHxkwE4/N4dLvSCz6AOO5921HEC/181BXzVvgVA3wqYPTw2G6s+TFBsYB20rlz29AT/igjTIcXfjbocYnM0sYVMeou7F5m1LB314AjqZW2o0zv4hrV9gv8+9+5S1h/7Z79lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113328; c=relaxed/simple;
	bh=wM3NrQbRyAqijLfOZwLEHIeVNens9KSIsnLyUQU7F70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBt/qXJOq7zPxOYlh0hgrTHzxc8PuCE2yaFuFgpoQcL1r1L/cXXlAtkpKZMvE90sBIeAxu/+nopYm9ZnZFXYxQ/FoJZuvx5U5zI7PphCeFSDrvX9JdIDZkocdX1oVvjdoCgmwPAYkjig/6b12Z+qY8kN+cakJZ1+ZrXSHANd76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4gUJ5Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4gUJ5Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66212C4CEF0;
	Wed, 17 Sep 2025 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113327;
	bh=wM3NrQbRyAqijLfOZwLEHIeVNens9KSIsnLyUQU7F70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4gUJ5KfFe+sFd62m+XNJaDgRObKky8wAjqnT9L0/2yqLA/4SLSr7+Xk8r0WwJi1s
	 +xezqVTyxvcQ4BT2TC2J7KkVQ7jCKwPG3JD737NLg6A4OGqG01tULwB+fRy7NfjJXh
	 WHFxR9nzeO5O4gscnuknp+0dV0xNoLp6fjPdzlAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 052/140] btrfs: fix squota compressed stats leak
Date: Wed, 17 Sep 2025 14:33:44 +0200
Message-ID: <20250917123345.577950133@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit de134cb54c3a67644ff95b1c9bffe545e752c912 upstream.

The following workload on a squota enabled fs:

  btrfs subvol create mnt/subvol

  # ensure subvol extents get accounted
  sync
  btrfs qgroup create 1/1 mnt
  btrfs qgroup assign mnt/subvol 1/1 mnt
  btrfs qgroup delete mnt/subvol

  # make the cleaner thread run
  btrfs filesystem sync mnt
  sleep 1
  btrfs filesystem sync mnt
  btrfs qgroup destroy 1/1 mnt

will fail with EBUSY. The reason is that 1/1 does the quick accounting
when we assign subvol to it, gaining its exclusive usage as excl and
excl_cmpr. But then when we delete subvol, the decrement happens via
record_squota_delta() which does not update excl_cmpr, as squotas does
not make any distinction between compressed and normal extents. Thus,
we increment excl_cmpr but never decrement it, and are unable to delete
1/1. The two possible fixes are to make squota always mirror excl and
excl_cmpr or to make the fast accounting separately track the plain and
cmpr numbers. The latter felt cleaner to me so that is what I opted for.

Fixes: 1e0e9d5771c3 ("btrfs: add helper for recording simple quota deltas")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1501,6 +1501,7 @@ static int __qgroup_excl_accounting(stru
 	struct btrfs_qgroup *qgroup;
 	LIST_HEAD(qgroup_list);
 	u64 num_bytes = src->excl;
+	u64 num_bytes_cmpr = src->excl_cmpr;
 	int ret = 0;
 
 	qgroup = find_qgroup_rb(fs_info, ref_root);
@@ -1512,11 +1513,12 @@ static int __qgroup_excl_accounting(stru
 		struct btrfs_qgroup_list *glist;
 
 		qgroup->rfer += sign * num_bytes;
-		qgroup->rfer_cmpr += sign * num_bytes;
+		qgroup->rfer_cmpr += sign * num_bytes_cmpr;
 
 		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
+		WARN_ON(sign < 0 && qgroup->excl_cmpr < num_bytes_cmpr);
 		qgroup->excl += sign * num_bytes;
-		qgroup->excl_cmpr += sign * num_bytes;
+		qgroup->excl_cmpr += sign * num_bytes_cmpr;
 
 		if (sign > 0)
 			qgroup_rsv_add_by_qgroup(fs_info, qgroup, src);


