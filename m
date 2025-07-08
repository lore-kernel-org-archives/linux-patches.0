Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E012E5B2E;
	Tue,  8 Jul 2025 17:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994063; cv=none; b=sbCYVnC6RldLG8UzB3F17no13kJujWBBsA+aK5YN4aeN5nMFPzMCoiW9wncyce7c1T+TqeVGLn8m3V+Q7VKynjTz56Xy8ouu7ODf7jDMcFcF2xO4jOBXjUsqp9odPxsLjglodl5RxNn9/+hyOb2zap9At8QY37D3VPfyhL43a2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994063; c=relaxed/simple;
	bh=S5FiDj7xY2tUb/+nu6coTGiTqWnkgyx8YYa9wRLUIDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eafy43LjNFCtr89VTpSfGI+2St8VoQovS2L1Tuy+jZ6kW3y28JQivsmGoaMgTDlrCc9t9BkhotEf8UNNhV1ogiwUBS+xPggSvNttH/MLtEx9EgiWHjX+691LATv68p2tJ64uvNCCdn9jg1kslGGP9YHIaJNpHtr7xUkhvk7SDNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnCmgV2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnCmgV2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92254C4CEED;
	Tue,  8 Jul 2025 17:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994063;
	bh=S5FiDj7xY2tUb/+nu6coTGiTqWnkgyx8YYa9wRLUIDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnCmgV2HHsn+YHO/QZa/KqYA1Fw2aimVrYmiM3q0hwZHWnv9d2M94TeppktaCrexz
	 jDSSNTK/dkJWDDFmP0LIDqxYwzAYyCni8yeCfqy9tQvIv2yxPtCmiPKu0aPsg5u9PL
	 9l6JJzCwNgr4Prf7rjjsmxZ66WppMo6Bq8SQRO64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/160] btrfs: fix missing error handling when searching for inode refs during log replay
Date: Tue,  8 Jul 2025 18:22:30 +0200
Message-ID: <20250708162234.600266139@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6561a40ceced9082f50c374a22d5966cf9fc5f5c ]

During log replay, at __add_inode_ref(), when we are searching for inode
ref keys we totally ignore if btrfs_search_slot() returns an error. This
may make a log replay succeed when there was an actual error and leave
some metadata inconsistency in a subvolume tree. Fix this by checking if
an error was returned from btrfs_search_slot() and if so, return it to
the caller.

Fixes: e02119d5a7b4 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index dcf0dd2093f58..7049a19e07baf 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1066,7 +1066,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	search_key.type = BTRFS_INODE_REF_KEY;
 	search_key.offset = parent_objectid;
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
-	if (ret == 0) {
+	if (ret < 0) {
+		return ret;
+	} else if (ret == 0) {
 		struct btrfs_inode_ref *victim_ref;
 		unsigned long ptr;
 		unsigned long ptr_end;
-- 
2.39.5



