Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD694E322C;
	Thu, 17 Sep 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665513; cv=none; b=oxDnhOtsUueWE9oJNc71wgXxD/E+dL6zF47efWFQMC1SUX5CuTg0N/FWbM8kQBZGQIi9vyxEghSkjwOi+GBBITwr3QUbIUdb4PB89REr3lrF4XeXd0mu7s7aSrzRoaPRUfLZL4ph0J3L1CSdVArsKJ43M+juAOGmxjRVFxTHk2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665513; c=relaxed/simple;
	bh=I6dqvBE4qEYN6LvQydFAuuc3Z9bh9lBkKHI2CUIo4vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puQGOLiyP426yaaEREdFRWeDQgTN3klUjuYK5uNp37fRS/hl7JK58Y7D+fDSDCj+RAJyDazRWjpNPbywdvJJ06cqdRTBMEO7I5mVxsQUXDPUZY4oN8z8vHQkfkObhUvvgL0PlkNmEFgZGrMFg6ndzh2CmqexTs64lLUolY1vezM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KugvnkgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KugvnkgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8AF1F000FF;
	Thu, 17 Sep 2026 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665512;
	bh=2MP3se37ehtTDqza9LhznkUKwXCr5zvTyIMWT/LVIr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KugvnkgB4L9UxKVljjWIE+eArFugI17WNjKQMBfJxhLodqU0nM5u5aui5O3Ib01pb
	 syL3Tidk3AUTRANb7LbMtMKQQExB7nyG5ihRM/nO/0nn1sjGhN4NrUgkO6b2SnsCZy
	 TR+cT6+wLDx5i9GYxVc+mFVExwLQBWzaxxLyriOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0728/1250] btrfs: send: fix lost error return value in will_overwrite_ref()
Date: Thu, 17 Sep 2026 16:08:43 +0100
Message-ID: <20260917151611.621003471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit d0285dfbc3b46f41395b26ee2f4a16d99fb3e736 ]

The direct-return refactoring in commit b3047a42f55d ("btrfs: send:
directly return from will_overwrite_ref() and simplify it") changed
will_overwrite_ref() to return directly instead of going through the
common out label.

That resulted in a negative return value from is_inode_existent() to
start being converted to 0, making lookup errors unable to be
distinguished from the inode not existing.

process_recorded_refs() expects negative errors from
will_overwrite_ref() and aborts processing when it receives one.

Return the value from is_inode_existent() to restore the previous error
propagation behavior as it was before the refactor.

Fixes: b3047a42f55d ("btrfs: send: directly return from will_overwrite_ref() and simplify it")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 34a57f11e4bb9..22190902be81c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2074,7 +2074,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 
 	ret = is_inode_existent(sctx, dir, dir_gen, NULL, &parent_root_dir_gen);
 	if (ret <= 0)
-		return 0;
+		return ret;
 
 	/*
 	 * If we have a parent root we need to verify that the parent dir was
-- 
2.53.0



