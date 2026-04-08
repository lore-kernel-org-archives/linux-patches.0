Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13D23D6674;
	Wed,  8 Apr 2026 18:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672829; cv=none; b=eFD3IBZ4q1s4fk8puvP4d/6+whU0cdbY0SpEC3W075bgJPzj7/3JHaMuULZwiDn+4tqalbSM6msGQKsf4FoCqDzFdmLh3XRmzduJ624xpp4mEUezpL5Mel3asTbLzovr2IMQnb8IPHkIuTj+Xmn+KZJTjEbXW5FQSZMG8jp9/N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672829; c=relaxed/simple;
	bh=B41VHLU87xsOWiQKSIMgLbWEZ9stYSbnvmy+4aUoq0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmNKkzCla2SRGisBnuNcvMyozF7Ovo+9cn6iWAPkFWZ/f6qZIxyvFuLGWb/Tpx4mLOx8FD4jhzLMTwoMtDRLbEiVEJ9n7deyCK2U+4eOUM44eLSDrbj7JbmmGKfzqy0msmgGkllQyBLLHauZ4OgO5pw4LlfnyfqyNv5qu+XCeBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNIkvwo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNIkvwo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF2EC19421;
	Wed,  8 Apr 2026 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672829;
	bh=B41VHLU87xsOWiQKSIMgLbWEZ9stYSbnvmy+4aUoq0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNIkvwo/iSLWc8v7yigGCOpGuFekIwn1A1OMQa99PTx3244NMoj2rBThPxATkoa6s
	 m3dMMB165t5sa0sihT2MAJZnLu3FCWBoMpJN5fweyJKJCPXS7XHu8cBdGX1QfyCYyN
	 0Zsh3dU5RKz7BrUa7KUd9ZpI4nleCtM/w8kJl8pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/160] ext4: handle wraparound when searching for blocks for indirect mapped blocks
Date: Wed,  8 Apr 2026 20:04:05 +0200
Message-ID: <20260408175919.104401903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit bb81702370fad22c06ca12b6e1648754dbc37e0f ]

Commit 4865c768b563 ("ext4: always allocate blocks only from groups
inode can use") restricts what blocks will be allocated for indirect
block based files to block numbers that fit within 32-bit block
numbers.

However, when using a review bot running on the latest Gemini LLM to
check this commit when backporting into an LTS based kernel, it raised
this concern:

   If ac->ac_g_ex.fe_group is >= ngroups (for instance, if the goal
   group was populated via stream allocation from s_mb_last_groups),
   then start will be >= ngroups.

   Does this allow allocating blocks beyond the 32-bit limit for
   indirect block mapped files? The commit message mentions that
   ext4_mb_scan_groups_linear() takes care to not select unsupported
   groups. However, its loop uses group = *start, and the very first
   iteration will call ext4_mb_scan_group() with this unsupported
   group because next_linear_group() is only called at the end of the
   iteration.

After reviewing the code paths involved and considering the LLM
review, I determined that this can happen when there is a file system
where some files/directories are extent-mapped and others are
indirect-block mapped.  To address this, add a safety clamp in
ext4_mb_scan_groups().

Fixes: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
Cc: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://patch.msgid.link/20260326045834.1175822-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2892,6 +2892,8 @@ repeat:
 		 * from the goal value specified
 		 */
 		group = ac->ac_g_ex.fe_group;
+		if (group >= ngroups)
+			group = 0;
 		ac->ac_groups_linear_remaining = sbi->s_mb_max_linear_groups;
 		prefetch_grp = group;
 


