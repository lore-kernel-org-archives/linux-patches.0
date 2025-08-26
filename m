Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884492FC008;
	Tue, 26 Aug 2025 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213788; cv=none; b=Ylobq8Yb5t/mmvqyBGvnD7G+EMqQMOu+1EEj7DNJMfaGuJBYFOv1NeIm6GA4F23aKanr6shSL2Lg+QMQ/Ht8Yokv62tFoc2+euj7szKCQyxlhTpKaN4LtJD+MuH2GrdkUSYfEgrtciEaG2+03QUeGSum5ztqZOUOs8Vc5V8zVio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213788; c=relaxed/simple;
	bh=4ADWSWIZj6qw1XBFvqo1fx2c1HW5URqxvA33TQCa1IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGB0eWILbYi5NklH9c4Wp12oUULxeHBu0Ym4623YOjFkx9bi+O/LLp+7hy6gkRp9Cagg0ufveXzGKrhz6N2pgvmd8Xq9Vii3NfhsYUewezRRmimt3q1FqjuvoLghJeVea0glPco6tgscdRc4iDuSqUVvZlgkv47Sbm5T1gakcvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbPdEtUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbPdEtUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E1C4CEF1;
	Tue, 26 Aug 2025 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213788;
	bh=4ADWSWIZj6qw1XBFvqo1fx2c1HW5URqxvA33TQCa1IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbPdEtUM5+oKDJDj/R8xOo8TKXLrSVVVatT7wIXgAiMjFcU5TpHRVCKIHkxiASFWS
	 XpKh44dTWBaNjHjoN4xBkcm9pf1Jw+Zdj/G5qMjD94MXBy0k0jgnjYaSVvxrxNtSDk
	 woHl4K/mfLhwWCFm6SYrqnx3knXZwjfjeLjRZiBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 448/587] btrfs: abort transaction on unexpected eb generation at btrfs_copy_root()
Date: Tue, 26 Aug 2025 13:09:57 +0200
Message-ID: <20250826111004.355178868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 33e8f24b52d2796b8cfb28c19a1a7dd6476323a8 ]

If we find an unexpected generation for the extent buffer we are cloning
at btrfs_copy_root(), we just WARN_ON() and don't error out and abort the
transaction, meaning we allow to persist metadata with an unexpected
generation. Instead of warning only, abort the transaction and return
-EUCLEAN.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -347,7 +347,14 @@ int btrfs_copy_root(struct btrfs_trans_h
 
 	write_extent_buffer_fsid(cow, fs_info->fs_devices->metadata_uuid);
 
-	WARN_ON(btrfs_header_generation(buf) > trans->transid);
+	if (unlikely(btrfs_header_generation(buf) > trans->transid)) {
+		btrfs_tree_unlock(cow);
+		free_extent_buffer(cow);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
 		ret = btrfs_inc_ref(trans, root, cow, 1);
 	else


