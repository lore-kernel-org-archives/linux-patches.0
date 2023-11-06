Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9819EAE6
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peeiScM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7E0C433C9;
	Mon,  6 Nov 2023 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276893;
	bh=Pmw7PHjGKJFeOK4F/wmpVmUHFXi8U4d6OTLLpep6saU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peeiScM4rl7HyEg3zlo7stWZxl0DcUMsLzxUemgK8gVykPY3filYqH4mqqR760awd
	 A1NDUlGIA/kszeCbxG53AAkJINmbx7HQwvL6dWu8wLN7tII/Q5guyCL9df3KiNShk0
	 oYCCcVW2kC19xEKJpMa0TMGHfQfC0Rg1rSioioTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 42/74] ext4: avoid overlapping preallocations due to overflow
Date: Mon,  6 Nov 2023 14:04:02 +0100
Message-ID: <20231106130303.196643043@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit bedc5d34632c21b5adb8ca7143d4c1f794507e4c upstream.

Let's say we want to allocate 2 blocks starting from 4294966386, after
predicting the file size, start is aligned to 4294965248, len is changed
to 2048, then end = start + size = 0x100000000. Since end is of
type ext4_lblk_t, i.e. uint, end is truncated to 0.

This causes (pa->pa_lstart >= end) to always hold when checking if the
current extent to be allocated crosses already preallocated blocks, so the
resulting ac_g_ex may cross already preallocated blocks. Hence we convert
the end type to loff_t and use pa_logical_end() to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230724121059.11834-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3094,8 +3094,7 @@ ext4_mb_normalize_request(struct ext4_al
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_super_block *es = sbi->s_es;
 	int bsbits, max;
-	ext4_lblk_t end;
-	loff_t size, start_off;
+	loff_t size, start_off, end;
 	loff_t orig_size __maybe_unused;
 	ext4_lblk_t start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3203,7 +3202,7 @@ ext4_mb_normalize_request(struct ext4_al
 	/* check we don't cross already preallocated blocks */
 	rcu_read_lock();
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
-		ext4_lblk_t pa_end;
+		loff_t pa_end;
 
 		if (pa->pa_deleted)
 			continue;
@@ -3213,8 +3212,7 @@ ext4_mb_normalize_request(struct ext4_al
 			continue;
 		}
 
-		pa_end = pa->pa_lstart + EXT4_C2B(EXT4_SB(ac->ac_sb),
-						  pa->pa_len);
+		pa_end = pa_logical_end(EXT4_SB(ac->ac_sb), pa);
 
 		/* PA must not overlap original request */
 		BUG_ON(!(ac->ac_o_ex.fe_logical >= pa_end ||
@@ -3243,12 +3241,11 @@ ext4_mb_normalize_request(struct ext4_al
 	/* XXX: extra loop to check we really don't overlap preallocations */
 	rcu_read_lock();
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
-		ext4_lblk_t pa_end;
+		loff_t pa_end;
 
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0) {
-			pa_end = pa->pa_lstart + EXT4_C2B(EXT4_SB(ac->ac_sb),
-							  pa->pa_len);
+			pa_end = pa_logical_end(EXT4_SB(ac->ac_sb), pa);
 			BUG_ON(!(start >= pa_end || end <= pa->pa_lstart));
 		}
 		spin_unlock(&pa->pa_lock);


