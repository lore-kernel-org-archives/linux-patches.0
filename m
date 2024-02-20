Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12B414A4E6;
	Tue, 20 Feb 2024 21:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464393; cv=none; b=XklOz/lSLorSblWY5Se9Z1iRmnGkOflRpduPTuSZQ0yWELtfDRn2Qef5VB4dVhX8uW5iWWZs2lrlDVAsuqefS5jsI51883cou7Y0AvImA6kSIrpy8ur9BwixJ7aXRIKbwNohBsdTmU+uKbsUyE0eLEAgzoB4xPBN3gIT9W1vI6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464393; c=relaxed/simple;
	bh=FIbepJBWSRKf5unE36h3DD75ahtBKpuS1TolINuAyPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qv13EwZQYOBHSvuwmdDiE2SQqCYwO5mL17PLc7A2QtUCQCWiRj01YfgQChBcEP84cM8mZF/ISaIznD6YE75k7gNu4jivazccJKP+mblk61ZJ1tXW8EZGeiQtCRilxfA7IAAqtYNVNy+d7Vh0zr9tc/yJ90oKceY1LUYkdK3g6kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J/6TyCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J/6TyCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E418C433F1;
	Tue, 20 Feb 2024 21:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464392;
	bh=FIbepJBWSRKf5unE36h3DD75ahtBKpuS1TolINuAyPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J/6TyCwyGJx098g/tyY985xOe77Z4mUtFGrf4q5rSBUVd4u+0JhSiZqOUdS0hY8E
	 29DqF4mHTcpdydTa3LBZhBMechHxMqgilJKKF7c09Gptf+E0ekimg+/DKv4c5waFOc
	 Jb1TtttfvHZ4jWZ5SOu1s0kYJXOF41xctwYUSzxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 011/309] btrfs: forbid deleting live subvol qgroup
Date: Tue, 20 Feb 2024 21:52:50 +0100
Message-ID: <20240220205633.487299950@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1736,6 +1736,15 @@ out:
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
@@ -1755,6 +1764,11 @@ int btrfs_remove_qgroup(struct btrfs_tra
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


