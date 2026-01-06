Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C97B35503E;
	Tue,  6 Jan 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720223; cv=none; b=FJz6ASzcbkrNHhd5ziswIaIgTxAxus/7IR9BwOGmgiP3SI2jOptmv7MWdjEpvPi3z5efJx7SLpsOJkgvYjPuO5K1iEn6GR+cRYVHp5sqwJ+syMfNWiwYMrfhuLT8ucTTGoyH53dcEKdffY31fJjVl/j994k0EPsAJ7smjV+BeLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720223; c=relaxed/simple;
	bh=WdYQMjzuWvM3v3EpZr3AJklOxDdTLyTmWpKjPAoCwz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UahXW2PMBcv6sAs5OUZhIgCEJDd6jUkddYL67GZUS6ecgY4z3xnj/fEpiFrbrmtx7kgjlS3AUWelda1koo5blOIl0e+B5/lm8h5S/GcuhwhgIJjuhTQhd3a3spjfSSljI5qQV9J9W322qHwZMkthT8K98lW4aeiDfKgzxPTQEyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o20sWREC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o20sWREC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433C4C116C6;
	Tue,  6 Jan 2026 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720222;
	bh=WdYQMjzuWvM3v3EpZr3AJklOxDdTLyTmWpKjPAoCwz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o20sWREC78IshtGz370VN5wj78dU58khD3ldfXXC/JARHAicMc+cT4oqbRQ0x1D4g
	 yD+nIJReT11Xma4ahhbWtrU31kTaeU9DF/8OdOrYVoWzaDsDNjrpc+05g/3U0Fodak
	 EGuGGSu+F1nE6abkVvuVAOp6I0ziFPl1RKmWiV6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 170/567] ext4: fix incorrect group number assertion in mb_check_buddy
Date: Tue,  6 Jan 2026 17:59:12 +0100
Message-ID: <20260106170457.615315509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -778,6 +778,8 @@ static void __mb_check_buddy(struct ext4
 		ext4_group_t groupnr;
 		struct ext4_prealloc_space *pa;
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
+		if (!pa->pa_len)
+			continue;
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &groupnr, &k);
 		MB_CHECK_ASSERT(groupnr == e4b->bd_group);
 		for (i = 0; i < pa->pa_len; i++)


