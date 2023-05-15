Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17024FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733E5C433EF;
	Mon, 15 May 2023 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169998;
	bh=bMM3M3/6iaUkQz5bnBelOCDckOMOPVJg0H7sSqX7GwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRwIRVo15Tb4e4974rwKZjINGnPRgyOjRmLQVBkmPt912hUIENdjsS0qH2l3vMDrb
	 0a5msoa83f/UVmgjTiKDnjauiqw0ybXK89zdD/5rfibkPM9RBl6NJ40Ee2j4Lemciz
	 Ge93pA5spqHFMRfjrEU4KA8ugZL4u7EJ0eIBO328=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+e2efa3efc15a1c9e95c3@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.3 238/246] ext4: remove a BUG_ON in ext4_mb_release_group_pa()
Date: Mon, 15 May 2023 18:27:30 +0200
Message-Id: <20230515161729.784477072@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

commit 463808f237cf73e98a1a45ff7460c2406a150a0b upstream.

If a malicious fuzzer overwrites the ext4 superblock while it is
mounted such that the s_first_data_block is set to a very large
number, the calculation of the block group can underflow, and trigger
a BUG_ON check.  Change this to be an ext4_warning so that we don't
crash the kernel.

Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230430154311.579720-3-tytso@mit.edu
Reported-by: syzbot+e2efa3efc15a1c9e95c3@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=69b28112e098b070f639efb356393af3ffec4220
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4820,7 +4820,11 @@ ext4_mb_release_group_pa(struct ext4_bud
 	trace_ext4_mb_release_group_pa(sb, pa);
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
-	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
+	if (unlikely(group != e4b->bd_group && pa->pa_len != 0)) {
+		ext4_warning(sb, "bad group: expected %u, group %u, pa_start %llu",
+			     e4b->bd_group, group, pa->pa_pstart);
+		return 0;
+	}
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
 	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
 	trace_ext4_mballoc_discard(sb, NULL, group, bit, pa->pa_len);


