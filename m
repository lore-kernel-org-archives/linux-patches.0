Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B774A23B604;
	Mon,  9 Feb 2026 14:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647453; cv=none; b=duQ4m/LJPPkZS1zslsfUSkk4oaGrDcWuRZ22/lWpcbhtHTBQZUrEUKPqVhnJGowLu4PIIhTAFqRZaAR1BrpypBLwoywyTpO9XwdjoUySqjjR+OMRMhBb5t6CCAuFaNZDDRsRqMYam4U+b8Nrovn6XS5yZpQYar42iEtVaU1yd+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647453; c=relaxed/simple;
	bh=R9XJBQnDP4SAoojy/oZJSJeNzLZB8yqZRy9tluVapfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtSlqpdd0bpmT5nmI3zDWciB6QXS3zNQAof4g9bf+tJn+QytGj1iNXWw+Ii2mKTLDFBv0e1Fv3TdNrDzD5c6hWi/ZM/k1qkLxbsH80aK+vqPW7rmROLUrT6Jw8/S4/Zq7j7ZwEQgMVi3WtzkmxYP38f0ir2EwrwJBpF5vdobyWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8VaDcft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8VaDcft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349FEC116C6;
	Mon,  9 Feb 2026 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647453;
	bh=R9XJBQnDP4SAoojy/oZJSJeNzLZB8yqZRy9tluVapfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8VaDcfteirD6Dftn7a9YhHaDck+mXsaP4t3ZbIADdhfvLism3cP7qvdqamobV5WI
	 6+sTjhln8/UrRKsW1K3bJHOa/oHCbsKLWF5jlOPfS0wFzftq34R26CKYYxrNosbsXn
	 IJG1gvcSHh37bYAZP2yuVaXKR6I8X58ea4rxSixw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/175] btrfs: fix Wmaybe-uninitialized warning in replay_one_buffer()
Date: Mon,  9 Feb 2026 15:22:58 +0100
Message-ID: <20260209142324.191895639@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

[ Upstream commit 9c7e71c97c8cd086b148d0d3d1cd84a1deab023c ]

Warning was found when compiling using loongarch64-gcc 12.3.1:

  $ make CFLAGS_tree-log.o=-Wmaybe-uninitialized

  In file included from fs/btrfs/ctree.h:21,
		   from fs/btrfs/tree-log.c:12:
  fs/btrfs/accessors.h: In function 'replay_one_buffer':
  fs/btrfs/accessors.h:66:16: warning: 'inode_item' may be used uninitialized [-Wmaybe-uninitialized]
     66 |         return btrfs_get_##bits(eb, s, offsetof(type, member));         \
	|                ^~~~~~~~~~
  fs/btrfs/tree-log.c:2803:42: note: 'inode_item' declared here
   2803 |                 struct btrfs_inode_item *inode_item;
	|                                          ^~~~~~~~~~

Initialize the inode_item to NULL, the compiler does not seem to see the
relation between the first 'wc->log_key.type == BTRFS_INODE_ITEM_KEY'
check and the other one that also checks the replay phase.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1444857de9fe8..ae2e035d013e2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2800,7 +2800,7 @@ static int replay_one_buffer(struct extent_buffer *eb,
 
 	nritems = btrfs_header_nritems(eb);
 	for (wc->log_slot = 0; wc->log_slot < nritems; wc->log_slot++) {
-		struct btrfs_inode_item *inode_item;
+		struct btrfs_inode_item *inode_item = NULL;
 
 		btrfs_item_key_to_cpu(eb, &wc->log_key, wc->log_slot);
 
-- 
2.51.0



