Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51321171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C93C433D2;
	Mon, 22 May 2023 19:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783652;
	bh=KUyy0skmmfGj1I/uMR/3FPlqUsK/ODaqOCMjz3G+bxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XazrZs6OWoORd4iKrkaBLO0CWZp0ueN76qXod6+CyKlhPT+rSaT9fW0/OWNywU01I
	 i/6boPLDiQ1Zz7gjLPd9iAffw/8YKlKqSr8lfnLrpKnqmshosNcIA1BadPTpBPY3zx
	 ZuN0nLyM0VHhny/SpvsuGyaxUTuEh2rqK1t5KkBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/292] ext4: set goal start correctly in ext4_mb_normalize_request
Date: Mon, 22 May 2023 20:07:26 +0100
Message-Id: <20230522190408.199103681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit b07ffe6927c75d99af534d685282ea188d9f71a6 ]

We need to set ac_g_ex to notify the goal start used in
ext4_mb_find_by_goal. Set ac_g_ex instead of ac_f_ex in
ext4_mb_normalize_request.
Besides we should assure goal start is in range [first_data_block,
blocks_count) as ext4_mb_initialize_context does.

[ Added a check to make sure size is less than ar->pright; otherwise
  we could end up passing an underflowed value of ar->pright - size to
  ext4_get_group_no_and_offset(), which will trigger a BUG_ON later on.
  - TYT ]

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230303172120.3800725-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 09bb1dae40cf0..21f09bcffbbaa 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4018,6 +4018,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
+	struct ext4_super_block *es = sbi->s_es;
 	int bsbits, max;
 	ext4_lblk_t end;
 	loff_t size, start_off;
@@ -4213,18 +4214,21 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	ac->ac_g_ex.fe_len = EXT4_NUM_B2C(sbi, size);
 
 	/* define goal start in order to merge */
-	if (ar->pright && (ar->lright == (start + size))) {
+	if (ar->pright && (ar->lright == (start + size)) &&
+	    ar->pright >= size &&
+	    ar->pright - size >= le32_to_cpu(es->s_first_data_block)) {
 		/* merge to the right */
 		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
+						&ac->ac_g_ex.fe_group,
+						&ac->ac_g_ex.fe_start);
 		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
 	}
-	if (ar->pleft && (ar->lleft + 1 == start)) {
+	if (ar->pleft && (ar->lleft + 1 == start) &&
+	    ar->pleft + 1 < ext4_blocks_count(es)) {
 		/* merge to the left */
 		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
+						&ac->ac_g_ex.fe_group,
+						&ac->ac_g_ex.fe_start);
 		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
 	}
 
-- 
2.39.2



