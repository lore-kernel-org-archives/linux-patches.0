Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEAC17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43326C433C8;
	Wed,  9 Aug 2023 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580858;
	bh=d1ZAlTI9uhU7W9fDSrct5ECdfzuzf0UCNoBPnbmkhJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpOBCnW7/FPibQS69KGSTemicrbG/EcDdBOk9L1V+VU406Gh6FelJDLlYRkeyL9qG
	 rGNZXk6e+ceYUXsuTkRrBT7Zh3GQUbREIfJhiSFp3quw0SOj5JQd/IW+wa8/25joFw
	 BKutIKHyoBX9oYMQA4bwPWn4lhWf4NbZA3f6jqac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/201] btrfs: fix extent buffer leak after tree mod log failure at split_node()
Date: Wed,  9 Aug 2023 12:40:07 +0200
Message-ID: <20230809103643.980511568@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ede600e497b1461d06d22a7d17703d9096868bc3 ]

At split_node(), if we fail to log the tree mod log copy operation, we
return without unlocking the split extent buffer we just allocated and
without decrementing the reference we own on it. Fix this by unlocking
it and decrementing the ref count before returning.

Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 41a7ace9998e4..814f2f07e74c4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3589,6 +3589,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 
 	ret = tree_mod_log_eb_copy(split, c, 0, mid, c_nritems - mid);
 	if (ret) {
+		btrfs_tree_unlock(split);
+		free_extent_buffer(split);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}
-- 
2.39.2



