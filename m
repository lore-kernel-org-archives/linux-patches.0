Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38763ACF11;
	Wed,  8 Apr 2026 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672369; cv=none; b=o8uIHXqQDFbc0TzzC0uV1n3lgG3KqTmmNTWbK647mtcJ8H8KNRVWJV02FlYvtJ34JAQG7zcsTYbCMOfMmpKFV7cZbp+r0C92UlAvGpQzeqh4YGyYVUvZJKqFEHBDYtyIhqVy9kJkPtl0g91IbAXJ38YkiPJUOF4TzEOLAqrE1mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672369; c=relaxed/simple;
	bh=5QSiDOFZ/VL1XHcwCsE0uPq7iw7DoPr3uEBdNm1dJGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRhgne8L2G7SauiVGo0nX1IS6no9uJgFwdh5sibtsJqx9Y/8ZLdYNMRaTeDqDgH6HGWjQCU6c1WaRnhCYyoHvKozDc3esan6szwxbhBCWeflhXLfZloJsJmd5vyhxuyXLD6lWAUeh8DDEuHQYAePt2wQ2vcr4oEYZELOdPNCxnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlpBmgbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlpBmgbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DCCC19421;
	Wed,  8 Apr 2026 18:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672369;
	bh=5QSiDOFZ/VL1XHcwCsE0uPq7iw7DoPr3uEBdNm1dJGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlpBmgbskjTgFd5o+T/mFj/6Xo7k3LwUmv8azL3lL7iac+JLbxDeQGdZxDxtInNa8
	 kdAy5Bz5bKnML9UD23/fs9pqoeWibUhpPYMho3wcgnpagAu77FTFh4CjuvQO+4kH8A
	 JMUlUlL9GyJC/VKZ+Oo7PC8x0n1z7z5Ep/eE7lOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/312] ext4: handle wraparound when searching for blocks for indirect mapped blocks
Date: Wed,  8 Apr 2026 20:03:29 +0200
Message-ID: <20260408175944.671597745@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted fix from ext4_mb_scan_groups() to inline equivalent in ext4_mb_regular_allocator() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2733,6 +2733,8 @@ repeat:
 		 * from the goal value specified
 		 */
 		group = ac->ac_g_ex.fe_group;
+		if (group >= ngroups)
+			group = 0;
 		ac->ac_groups_linear_remaining = sbi->s_mb_max_linear_groups;
 		prefetch_grp = group;
 


