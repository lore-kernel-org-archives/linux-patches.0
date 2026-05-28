Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB11EA65;
	Thu, 28 May 2026 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000100; cv=none; b=dPNBEm9eHSmQJWbJmp1bvcmNJ6vokNHEz4bWo189AwshjLmdWNaW+nPS+h92FZ2JuIkQpmbHzupXAgZlchjtsdr+XG6tJbWjtU1tU6p/4bxUludplhsJyhQQ+GCBRUUCM4O6xfe1nS9DDGubYURbrhiawN0FzfI5sgMM7OBQjw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000100; c=relaxed/simple;
	bh=GEXT96pCHlIlLSmkXH2QJeBK+tOnc6/VxQv0mnv67YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPYe85ej+DqLjOOd36EdIlFzX8wpgJzxpktdY8886fvmqosQLZXHQYK3KSuOQMzV5dv/nQu1KVs+7ZRXvdgDWM1L4O6Z1CVnnt+7kHEnZJ5RS3In+RU6H39cWcMrT4LfrHqhUddt9rRWC6fmC1CZwmzBOASPW5erT8QfeLI0QD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MACM0Oki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MACM0Oki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC7C1F000E9;
	Thu, 28 May 2026 20:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000099;
	bh=22YPI7fdEjW2gVbpRrjaUpQMm5gvhIMLj68aq/eamfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MACM0Oki/Md233PJ64WD0S8c8KnQPtux4WJKSK54iSK3EHW08dB1eAne8a628kwZ4
	 8lHcJxfQenH3P6sosE939eOFZ49ymr9L4R7tiyn3dvPDSjzLTLQECuvoFqnVcif7vQ
	 r+DPNpF47bonevQja79Km61lUbZlFC/YyoetSWv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/377] btrfs: check squota parent usage on membership change
Date: Thu, 28 May 2026 21:48:59 +0200
Message-ID: <20260528194647.074909933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 9c46bcda5f347febdbb4d117fb21a37ffcec5fa4 ]

We could have detected the quick inherit bug more directly if we had
an extra warning about squota hierarchy consistency while modifying the
hierarchy. In squotas, the parent usage always simply adds up to the sum of
its children, so we can just check for that when changing membership and
detect more accounting bugs.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1e92637722ae ("btrfs: check for subvolume before deleting squota qgroup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7b62d2faaf7ec..db1df67bccf38 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -346,6 +346,42 @@ int btrfs_verify_qgroup_counts(const struct btrfs_fs_info *fs_info, u64 qgroupid
 }
 #endif
 
+static bool squota_check_parent_usage(struct btrfs_fs_info *fs_info, struct btrfs_qgroup *parent)
+{
+	u64 excl_sum = 0;
+	u64 rfer_sum = 0;
+	u64 excl_cmpr_sum = 0;
+	u64 rfer_cmpr_sum = 0;
+	struct btrfs_qgroup_list *glist;
+	int nr_members = 0;
+	bool mismatch;
+
+	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE)
+		return false;
+	if (btrfs_qgroup_level(parent->qgroupid) == 0)
+		return false;
+
+	/* Eligible parent qgroup. Squota; level > 0; empty members list. */
+	list_for_each_entry(glist, &parent->members, next_member) {
+		excl_sum += glist->member->excl;
+		rfer_sum += glist->member->rfer;
+		excl_cmpr_sum += glist->member->excl_cmpr;
+		rfer_cmpr_sum += glist->member->rfer_cmpr;
+		nr_members++;
+	}
+	mismatch = (parent->excl != excl_sum || parent->rfer != rfer_sum ||
+		    parent->excl_cmpr != excl_cmpr_sum || parent->rfer_cmpr != excl_cmpr_sum);
+
+	WARN(mismatch,
+	     "parent squota qgroup %hu/%llu has mismatched usage from its %d members. "
+	     "%llu %llu %llu %llu vs %llu %llu %llu %llu\n",
+	     btrfs_qgroup_level(parent->qgroupid),
+	     btrfs_qgroup_subvolid(parent->qgroupid), nr_members, parent->excl,
+	     parent->rfer, parent->excl_cmpr, parent->rfer_cmpr, excl_sum,
+	     rfer_sum, excl_cmpr_sum, rfer_cmpr_sum);
+	return mismatch;
+}
+
 __printf(2, 3)
 static void qgroup_mark_inconsistent(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
@@ -1565,6 +1601,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src, u64 dst
 		goto out;
 	}
 	ret = quick_update_accounting(fs_info, src, dst, 1);
+	squota_check_parent_usage(fs_info, parent);
 	spin_unlock(&fs_info->qgroup_lock);
 out:
 	kfree(prealloc);
@@ -1623,6 +1660,8 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 		spin_lock(&fs_info->qgroup_lock);
 		del_relation_rb(fs_info, src, dst);
 		ret = quick_update_accounting(fs_info, src, dst, -1);
+		ASSERT(parent);
+		squota_check_parent_usage(fs_info, parent);
 		spin_unlock(&fs_info->qgroup_lock);
 	}
 out:
-- 
2.53.0



