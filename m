Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459C018DF9D;
	Tue, 26 Aug 2025 11:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208600; cv=none; b=bjoNtRjbgqCxnOzXs2BsZpLhw0ccy05AKKT+g625IhXXaRak7cz4oBzltQt75tiQoes2e2Tsg3tKI6jfLqfHz5owGS5cpaSVobtu5kSQ33iZKxmFnfJ2MJ+JPtMUjNo/ua3L7ByHTNYLdLZE5hm6TTQO3Xj06KT13uQj+WGytDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208600; c=relaxed/simple;
	bh=lp1G6qUvmEMfUeQD/TMr+4gkvv8hFvYoIvyfG4T54U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAg49cJ03QC0vX0tI4uMDfectEyRsAlxvLYczl6mh6v7xsx/yPWm1n4Dlbr4/Nmvdz6TD4FfLx8Czdj0fP4u54C5JfSXdLDt/hHxF+ispdBDlXCtGhyU8XPbfusyYthuAYoDQUoSPsKkC7cb05GYclrrRwlNvl938It2xmaLIRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMMAItbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMMAItbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9889EC4CEF1;
	Tue, 26 Aug 2025 11:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208600;
	bh=lp1G6qUvmEMfUeQD/TMr+4gkvv8hFvYoIvyfG4T54U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMMAItbOg/CUsps6zoYRXHsgOmtphImlvPFTy69tX/s5AxUAExV0OQ6q5itL+A9pm
	 uTFoLj6bn7BKtZ6GrByFwg03nPt/Ote5oYJzqJiPkhRQudK3Q8Xda4QSLrjfwb0PN0
	 aEifBGMeHRP35T1kUDTx4XmEed1fenjSTqRuu5FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/322] btrfs: qgroup: drop unused parameter fs_info from __del_qgroup_rb()
Date: Tue, 26 Aug 2025 13:09:17 +0200
Message-ID: <20250826110919.310782129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 2651f43274109f2d09b74a404b82722213ef9b2d ]

We don't need fs_info here, everything is reachable from qgroup.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: e12496677503 ("btrfs: qgroup: fix race between quota disable and quota rescan ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -226,8 +226,7 @@ static struct btrfs_qgroup *add_qgroup_r
 	return qgroup;
 }
 
-static void __del_qgroup_rb(struct btrfs_fs_info *fs_info,
-			    struct btrfs_qgroup *qgroup)
+static void __del_qgroup_rb(struct btrfs_qgroup *qgroup)
 {
 	struct btrfs_qgroup_list *list;
 
@@ -258,7 +257,7 @@ static int del_qgroup_rb(struct btrfs_fs
 		return -ENOENT;
 
 	rb_erase(&qgroup->node, &fs_info->qgroup_tree);
-	__del_qgroup_rb(fs_info, qgroup);
+	__del_qgroup_rb(qgroup);
 	return 0;
 }
 
@@ -643,7 +642,7 @@ void btrfs_free_qgroup_config(struct btr
 	while ((n = rb_first(&fs_info->qgroup_tree))) {
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
 		rb_erase(n, &fs_info->qgroup_tree);
-		__del_qgroup_rb(fs_info, qgroup);
+		__del_qgroup_rb(qgroup);
 		btrfs_sysfs_del_one_qgroup(fs_info, qgroup);
 		kfree(qgroup);
 	}


