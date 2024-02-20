Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE80151CC8;
	Tue, 20 Feb 2024 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462781; cv=none; b=LN+U16hQPizSIPTzZxxTnau1yjbC0VTiRQxYzvEKaeBtPjnJQkejcxDxkJGJPhrb175G7vZ3A7A+svLalDfDL5gZIYZytert/K2FhhbxRSi6biYk4GJdHqhFC1Rw41qPm9viIra+9GA3MCVg2cOUccssbfISqguDtDYIyiFqQVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462781; c=relaxed/simple;
	bh=+fIDn93U6cj0Hxk8cK4jTnm7r81solQAYps6IM/hv5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbrYPh8jD7LySt+zDaom3EW6PzCFZaa4qz1m7LwmEfM7yz8Pf0+ScoR15PZy29++DwxzfN9gxlRixo7ldEqXq3PDhZxHjIGVvhaKFBqvTyKtSb4lgCuayMzKFZvw+BSaBFuERT/NQLyEltVRBHYFHg2SRRTKC8sZpOmWZbMHj5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7aE378W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7aE378W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97BBC43143;
	Tue, 20 Feb 2024 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462781;
	bh=+fIDn93U6cj0Hxk8cK4jTnm7r81solQAYps6IM/hv5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7aE378WxPzwexeairDOS8vTDDm3qArZ6KX8Xv2LB0IVwDkuVbvfmAjUjoIz+DMDp
	 r/3hrOb/fRNwRnUg34MfruCSpFZJE56uT5YWT7IJquX9g267uST3u8lojQV+khSVKH
	 KkZ8Qu/qI2kX8cMDmQTb5TSHjqhaGDPvw5sxMX08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 007/197] btrfs: forbid deleting live subvol qgroup
Date: Tue, 20 Feb 2024 21:49:26 +0100
Message-ID: <20240220204841.298606159@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1635,6 +1635,15 @@ out:
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
@@ -1654,6 +1663,11 @@ int btrfs_remove_qgroup(struct btrfs_tra
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


