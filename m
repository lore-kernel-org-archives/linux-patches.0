Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FBB34459
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DADC433EF;
	Wed,  7 Jun 2023 20:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171123;
	bh=2K8KYba4H7nGeXOqTQ5VhoGg1+ohPaKucxqJTziIA9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7nbDgPRx1aTOrBaUt85qyEPjRq1/431FE1r8Tko3IJCZKP6+R49DpxW1Y5Ck8C4/
	 9aQKrYbtTMFEq7WyaQweW9lesN84TIYZFzmfVHz6MhuzIHdR+ckrxB5B/y42PXy9lI
	 SNTyzkJdM5zL2pT+iFXMFKWl2uznglX/TnMa9lBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 119/120] ext4: enable the lazy init thread when remounting read/write
Date: Wed,  7 Jun 2023 22:17:15 +0200
Message-ID: <20230607200904.682521712@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit eb1f822c76beeaa76ab8b6737ab9dc9f9798408c upstream.

In commit a44be64bbecb ("ext4: don't clear SB_RDONLY when remounting
r/w until quota is re-enabled") we defer clearing tyhe SB_RDONLY flag
in struct super.  However, we didn't defer when we checked sb_rdonly()
to determine the lazy itable init thread should be enabled, with the
next result that the lazy inode table initialization would not be
properly started.  This can cause generic/231 to fail in ext4's
nojournal mode.

Fix this by moving when we decide to start or stop the lazy itable
init thread to after we clear the SB_RDONLY flag when we are
remounting the file system read/write.

Fixes a44be64bbecb ("ext4: don't clear SB_RDONLY when remounting r/w until...")

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20230527035729.1001605-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6006,18 +6006,6 @@ static int ext4_remount(struct super_blo
 	}
 
 	/*
-	 * Reinitialize lazy itable initialization thread based on
-	 * current settings
-	 */
-	if (sb_rdonly(sb) || !test_opt(sb, INIT_INODE_TABLE))
-		ext4_unregister_li_request(sb);
-	else {
-		ext4_group_t first_not_zeroed;
-		first_not_zeroed = ext4_has_uninit_itable(sb);
-		ext4_register_li_request(sb, first_not_zeroed);
-	}
-
-	/*
 	 * Handle creation of system zone data early because it can fail.
 	 * Releasing of existing data is done when we are sure remount will
 	 * succeed.
@@ -6054,6 +6042,18 @@ static int ext4_remount(struct super_blo
 	if (enable_rw)
 		sb->s_flags &= ~SB_RDONLY;
 
+	/*
+	 * Reinitialize lazy itable initialization thread based on
+	 * current settings
+	 */
+	if (sb_rdonly(sb) || !test_opt(sb, INIT_INODE_TABLE))
+		ext4_unregister_li_request(sb);
+	else {
+		ext4_group_t first_not_zeroed;
+		first_not_zeroed = ext4_has_uninit_itable(sb);
+		ext4_register_li_request(sb, first_not_zeroed);
+	}
+
 	if (!ext4_has_feature_mmp(sb) || sb_rdonly(sb))
 		ext4_stop_mmpd(sbi);
 


