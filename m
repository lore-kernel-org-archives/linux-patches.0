Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD183BFE45;
	Thu, 15 Jan 2026 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498018; cv=none; b=WfBZpVdsbliFuabm9Ioz0uJphUL9udxVhrmWlycMiNws+6NlQDRbjUu0dU9iIxVAZ9Y8lX5DGFyfZk/F3cgsocFT1M6wRQUewvHy3i+Dep9Gvz6WhAja4PcF/0OCLBJOKG+hCHIT06+NAJgVijEojWl9gAt+x/QkozrthatPIJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498018; c=relaxed/simple;
	bh=jBJMwQ2zF/bDVQqI2kKIAjKs3MoGIFV44o33wdcy+iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlRAw/Coao2XvW/6yCU1PGWgVTZ/4XzQylOfhG73pZwlmAe/muP800yzQfsUM1+9Lp4YEJlJidnY3CdtGQJrpVHOtHfripTN+CFOdK2v1fsbKdOrHKKpj0aGMfc5QfPLb+3sb/C9EwjY0vtTevlKUXHUO3mv2J702JFDM0UuaA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXBxeijT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXBxeijT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27795C19423;
	Thu, 15 Jan 2026 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498018;
	bh=jBJMwQ2zF/bDVQqI2kKIAjKs3MoGIFV44o33wdcy+iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXBxeijTs5mk9mlAroshItCzisXT2gj0fO0w/Xb36LkKRMyCuQbmTUbju9K5l9lfT
	 atXjUFNudbWHZ8TDErFG0l9JVA0+4Z99FvUSCtoe4s+fXXdVIAyLtHcnhdRBsNt7VP
	 EDOfnGdE4QChJgcIPuNJ8QUPi7zEVpNZuOC/oA60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 285/554] ext4: fix incorrect group number assertion in mb_check_buddy
Date: Thu, 15 Jan 2026 17:45:51 +0100
Message-ID: <20260115164256.545506223@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -767,6 +767,8 @@ static void __mb_check_buddy(struct ext4
 		ext4_group_t groupnr;
 		struct ext4_prealloc_space *pa;
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
+		if (!pa->pa_len)
+			continue;
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &groupnr, &k);
 		MB_CHECK_ASSERT(groupnr == e4b->bd_group);
 		for (i = 0; i < pa->pa_len; i++)


