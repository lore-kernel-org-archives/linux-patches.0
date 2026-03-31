Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2FD25D527;
	Tue, 31 Mar 2026 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975534; cv=none; b=ZK7TZ+t6P/hsyxroqwWD+JIkDAlbFMps/3NaFgvJLuGVfjum57uB3Jspnswzd6s/vT+GN1cG8TvJC+b4XQnXBWEJKr6/RysutxHY0SxF9deNNac+p2lAvdjPx4iHLN8Cc39uu0xnv2YjKkVsktG/ruFkVkUMqqJITTanYv42HQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975534; c=relaxed/simple;
	bh=FA0e9+NlxG/rKtywro35pQZNKlhmtaMphqCewmrF+g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvPda3j/Iz75TdNWNP/zSQRRj/rHxsJnmMg35L+mcQNc0lhfVywGHyYqrzHQUeZQXT9D5YFymBAn01ZB26rwuT2nd4MJ2IESo8zFAOxTVpMMiMX01XnqSeLMZnapMoHAhciXwA07HXlFMt28P0f60dejmNd7I7ohxsCYOXeuTr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/khjhvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/khjhvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FC6C19423;
	Tue, 31 Mar 2026 16:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975534;
	bh=FA0e9+NlxG/rKtywro35pQZNKlhmtaMphqCewmrF+g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/khjhvgmTlJ1fB3gDVHf2CzTvUF/rzuLgCOtxuHe7yI8ko+8JJmJjcBmLbdnj5zJ
	 ZtsOZhSNF+OVMKDP6mVdKZTTSIahCe+SmZ+L7gPsOy1mQohlhuRj/F5xUo7QYgYYMu
	 xYBZAq1jrDdD+ILS06horo4/YEX5MVuLxM2h1AgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 305/342] ext4: handle wraparound when searching for blocks for indirect mapped blocks
Date: Tue, 31 Mar 2026 18:22:18 +0200
Message-ID: <20260331161810.149588561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit bb81702370fad22c06ca12b6e1648754dbc37e0f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1199,6 +1199,8 @@ static int ext4_mb_scan_groups(struct ex
 
 	/* searching for the right group start from the goal value specified */
 	start = ac->ac_g_ex.fe_group;
+	if (start >= ngroups)
+		start = 0;
 	ac->ac_prefetch_grp = start;
 	ac->ac_prefetch_nr = 0;
 


