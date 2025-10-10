Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3314C2F3631;
	Fri, 10 Oct 2025 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102533; cv=none; b=oCKGxFB8ibXnBE+lv0TG4/f5Ywq9OD4YiWRDcd0oWKopMctDsbhh4XZktID8ZvIuEZEa8rra+zK5zyYacITZq4HRtlhTnIPy2SUpREqfTOstEIlNOuG6yCpUDclq03fhx+rTe2wqlGeglwPEtlDTGHU6Bm4mn8Hy0VH7lwrKrC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102533; c=relaxed/simple;
	bh=YnpnUok3rdi5nU9KjQUzBegL9Yv/j7iyHdcd4UuMJMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FP9f/5NIP94E3/ZW+Nc0WsR3XmqnOmfdbmCbOzn2mokFTQ7A4KaQAHMMifWsth1iUrPgmyWkAABDtYQOTTinzmXbhXQeoqcMMJom//D4qLxzY3qotKIdWBuBkAWR0O0lr3N+z1oLmxClrlpW1Fqw4XScr8l/RlaqlyoULx5EBNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QEeATri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QEeATri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7580BC4CEF1;
	Fri, 10 Oct 2025 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102532;
	bh=YnpnUok3rdi5nU9KjQUzBegL9Yv/j7iyHdcd4UuMJMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QEeATriJ+WrZPGypdFYL0JOzLRkapWaFfqRqJ4N1uVkRQUHgMLvsykKhpxQC9UqM
	 BI18lKM3aqvymmjE1KEBQr4etBT/2VMxSd8z22GydNwEt1mWgiYnJ0zu8/BDTNTlJG
	 wv07I5FRnE7G/PTPT9SB+WMP9Q/a7htZMhz0CBCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c3e0cdfbfe351b0bc0e@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/28] btrfs: ref-verify: handle damaged extent root tree
Date: Fri, 10 Oct 2025 15:16:30 +0200
Message-ID: <20251010131330.810123897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit ed4e6b5d644c4dd2bc2872ffec036b7da0ec2e27 ]

Syzbot hits a problem with enabled ref-verify, ignorebadroots and a
fuzzed/damaged extent tree. There's no fallback option like in other
places that can deal with it so disable the whole ref-verify as it is
just a debugging feature.

Reported-by: syzbot+9c3e0cdfbfe351b0bc0e@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/0000000000001b6052062139be1c@google.com/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ref-verify.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index 28ac7995716e0..b8122582d7555 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -990,11 +990,18 @@ int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
 	if (!btrfs_test_opt(fs_info, REF_VERIFY))
 		return 0;
 
+	extent_root = btrfs_extent_root(fs_info, 0);
+	/* If the extent tree is damaged we cannot ignore it (IGNOREBADROOTS). */
+	if (IS_ERR(extent_root)) {
+		btrfs_warn(fs_info, "ref-verify: extent tree not available, disabling");
+		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
+		return 0;
+	}
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	extent_root = btrfs_extent_root(fs_info, 0);
 	eb = btrfs_read_lock_root_node(extent_root);
 	level = btrfs_header_level(eb);
 	path->nodes[level] = eb;
-- 
2.51.0



