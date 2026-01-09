Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9902B35A95F;
	Fri,  9 Jan 2026 12:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960516; cv=none; b=q1KIhTSO2qpDC6cp8/DvJZAz7LLQadwnSrR0vHbwLtYB/gpamOxt649K7Pr2dHmnoSjec/OzXVKPlzFiNPBM+Wfe9JoHg2BSHWLUUF2YzFvQ7boRXh91Cw8RhFFu1SnEpQF+naxp/MBbIGedASo11PegdzddujYH2LketL8HfS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960516; c=relaxed/simple;
	bh=bF5Gw54g8Lq97sYiP46B5EO2I37ZoOtB7Bbq6m38Lm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpqBa72bpY0/Y/dZK6qHM9aehwCdRr6H0uvfbdv4eK0amXi7qycqAn9ZqEHhmCwXbF9Dn7dP0o4EpdKQEvb+ygpHtnpu6nw8MQMmc0whFkOaQZwj8bl4fBI8nrYEx8aMGLyAz+1pfLRxc37c5RXFzhi43agrFZC3ippdK2eko1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIOpK5fB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIOpK5fB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27312C16AAE;
	Fri,  9 Jan 2026 12:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960516;
	bh=bF5Gw54g8Lq97sYiP46B5EO2I37ZoOtB7Bbq6m38Lm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIOpK5fBo8Ih6aUmEnk97vdooVXNMJv+4ZOu14hce43jOBshiH3Qq4VzC7Dp1Wezx
	 +d6AWIIV+oR+3VRdqgVf6q+dRQqAssbZjqVtDppJiud03vVgQ3vsNE6ULkjQJ9CNqo
	 CHxCWOTWrsFbyMeohI5YwcSxbNnrHQ0XjyqMszVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 424/737] ext4: fix incorrect group number assertion in mb_check_buddy
Date: Fri,  9 Jan 2026 12:39:23 +0100
Message-ID: <20260109112149.948017938@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjian Sun <sunyongjian1@huawei.com>

commit 3f7a79d05c692c7cfec70bf104b1b3c3d0ce6247 upstream.

When the MB_CHECK_ASSERT macro is enabled, an assertion failure can
occur in __mb_check_buddy when checking preallocated blocks (pa) in
a block group:

Assertion failure in mb_free_blocks() : "groupnr == e4b->bd_group"

This happens when a pa at the very end of a block group (e.g.,
pa_pstart=32765, pa_len=3 in a group of 32768 blocks) becomes
exhausted - its pa_pstart is advanced by pa_len to 32768, which
lies in the next block group. If this exhausted pa (with pa_len == 0)
is still in the bb_prealloc_list during the buddy check, the assertion
incorrectly flags it as belonging to the wrong group. A possible
sequence is as follows:

ext4_mb_new_blocks
  ext4_mb_release_context
    pa->pa_pstart += EXT4_C2B(sbi, ac->ac_b_ex.fe_len)
    pa->pa_len -= ac->ac_b_ex.fe_len

	                 __mb_check_buddy
                           for each pa in group
                             ext4_get_group_no_and_offset
                             MB_CHECK_ASSERT(groupnr == e4b->bd_group)

To fix this, we modify the check to skip block group validation for
exhausted preallocations (where pa_len == 0). Such entries are in a
transitional state and will be removed from the list soon, so they
should not trigger an assertion. This change prevents the false
positive while maintaining the integrity of the checks for active
allocations.

Fixes: c9de560ded61f ("ext4: Add multi block allocator for ext4")
Signed-off-by: Yongjian Sun <sunyongjian1@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251106060614.631382-2-sunyongjian@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -777,6 +777,8 @@ static void __mb_check_buddy(struct ext4
 		ext4_group_t groupnr;
 		struct ext4_prealloc_space *pa;
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
+		if (!pa->pa_len)
+			continue;
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &groupnr, &k);
 		MB_CHECK_ASSERT(groupnr == e4b->bd_group);
 		for (i = 0; i < pa->pa_len; i++)


