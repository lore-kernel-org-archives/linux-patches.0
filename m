Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B304417AAB
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345A3C433C7;
	Wed,  9 Aug 2023 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580583;
	bh=/WRBvWGVG7RkHzuXV21BKs3nkK2w1tXGY1UeJlWxZ/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVaxNta5k8k9bg5s0J5ZLO3cIgP4UPuIEbxt0sKtey6vAE7GODrbA14LH0JdoDgiK
	 WeHf5CwSLAb4K9rdO2uaK65E4NC4K2W+LxdQGAtYX02L/9OC+0271GrCBtPYeo6kaK
	 NtqSatsRGTvYpZQX45wl7vd/dE972WeA07ty8Ifw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/154] btrfs: check if the transaction was aborted at btrfs_wait_for_commit()
Date: Wed,  9 Aug 2023 12:41:47 +0200
Message-ID: <20230809103639.499682180@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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

[ Upstream commit bf7ecbe9875061bf3fce1883e3b26b77f847d1e8 ]

At btrfs_wait_for_commit() we wait for a transaction to finish and then
always return 0 (success) without checking if it was aborted, in which
case the transaction didn't happen due to some critical error. Fix this
by checking if the transaction was aborted.

Fixes: 462045928bda ("Btrfs: add START_SYNC, WAIT_SYNC ioctls")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f2bd9f833e8d7..f2e348d22dc1e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -776,6 +776,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid)
 	}
 
 	wait_for_commit(cur_trans);
+	ret = cur_trans->aborted;
 	btrfs_put_transaction(cur_trans);
 out:
 	return ret;
-- 
2.40.1



