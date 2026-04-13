Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71B030DEDD;
	Mon, 13 Apr 2026 16:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097764; cv=none; b=EWk3XO5Fl+dMvoFO818QW3FAO4dh5bt8eGiK3Mq/gMUmKKlSbaWsDKPPkraBL1NfoxJppeYeGwSGx1uLodalbEKh8qqIxWpxleaQtBJC/aVAaqFH7DGyvE2eYGmiKAKuj2G8YGT2DbLshF6X86G6N8CCxd6s+dJFfnmhDdIJTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097764; c=relaxed/simple;
	bh=d0n2ofhcmk4ca6cHAN0h064QCMPBND0SFaoVDnIL8wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASuHRcUM/+EdddBSDwcKGuqmaQpzTUsWMQzRRtL3MDylKnmP28/0FAZ5Du+7pV51AydbZa4iZhtP44fGUTe0BZ2tw6T5GZ2lTTHcTaPhbdlxUcaPkxl/0+w/iEQlfZ2CzNQVMZbaBeZiu5SYDp6ulnIGzIvoCakm2cwJc2sRH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGT3LkBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGT3LkBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028D1C2BCAF;
	Mon, 13 Apr 2026 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097764;
	bh=d0n2ofhcmk4ca6cHAN0h064QCMPBND0SFaoVDnIL8wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGT3LkBl5SKTvGmdK0X0oFYu3cwnAa45uky01anpRPgs2sVqn3KUEdUUFYRFTcuIt
	 AJItAMJlF5DDStk/huEHnP1uL8jny2aKyyjEoZdwFCceoQDzL0UU7r/cIzLF+68WfN
	 OGZqxzDWENYmhU6yHtyMNL+ep6oHm9UOxlNwd4oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Pedro Falcato <pfalcato@suse.de>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/570] ext4: always allocate blocks only from groups inode can use
Date: Mon, 13 Apr 2026 17:56:02 +0200
Message-ID: <20260413155839.114439764@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 4865c768b563deff1b6a6384e74a62f143427b42 ]

For filesystems with more than 2^32 blocks inodes using indirect block
based format cannot use blocks beyond the 32-bit limit.
ext4_mb_scan_groups_linear() takes care to not select these unsupported
groups for such inodes however other functions selecting groups for
allocation don't. So far this is harmless because the other selection
functions are used only with mb_optimize_scan and this is currently
disabled for inodes with indirect blocks however in the following patch
we want to enable mb_optimize_scan regardless of inode format.

Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20260114182836.14120-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ Drop a few hunks not needed in older trees ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -885,6 +885,21 @@ mb_update_avg_fragment_size(struct super
 	write_unlock(&sbi->s_mb_rb_lock);
 }
 
+static ext4_group_t ext4_get_allocation_groups_count(
+				struct ext4_allocation_context *ac)
+{
+	ext4_group_t ngroups = ext4_get_groups_count(ac->ac_sb);
+
+	/* non-extent files are limited to low blocks/groups */
+	if (!(ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS)))
+		ngroups = EXT4_SB(ac->ac_sb)->s_blockfile_groups;
+
+	/* Pairs with smp_wmb() in ext4_update_super() */
+	smp_rmb();
+
+	return ngroups;
+}
+
 /*
  * Choose next group by traversing largest_free_order lists. Updates *new_cr if
  * cr level needs an update.
@@ -2700,10 +2715,7 @@ ext4_mb_regular_allocator(struct ext4_al
 
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
-	ngroups = ext4_get_groups_count(sb);
-	/* non-extent files are limited to low blocks/groups */
-	if (!(ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS)))
-		ngroups = sbi->s_blockfile_groups;
+	ngroups = ext4_get_allocation_groups_count(ac);
 
 	BUG_ON(ac->ac_status == AC_STATUS_FOUND);
 


