Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396A114270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEFFC433C8;
	Tue, 25 Jul 2023 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282363;
	bh=got4Ws7ggV3zCHMha0/hRrpZr/HWX1Nu4xkRbyQ7kEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzIn03R7itr7CzKZ6nHSvTmzw+6I7HIDfs4wdrfTJVTu9YWK/0fToJ/mJ/9SwOYRg
	 lHCB737NA9osD5QlnfwMscoPzzyVcAv03wCzQnUfFvQxWLyc6PLmJ+QjqV18LlY9FD
	 YtTzhUgZFpny03TxflTUSwuj30ZpPrlS+yqSQyr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 095/227] btrfs: abort transaction at update_ref_for_cow() when ref count is zero
Date: Tue, 25 Jul 2023 12:44:22 +0200
Message-ID: <20230725104518.653215692@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
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

[ Upstream commit eced687e224eb3cc5a501cf53ad9291337c8dbc5 ]

At update_ref_for_cow() we are calling btrfs_handle_fs_error() if we find
that the extent buffer has an unexpected ref count of zero, however we can
simply use btrfs_abort_transaction(), which achieves the same purposes: to
turn the fs to error state, abort the current transaction and turn the fs
to RO mode as well. Besides that, btrfs_abort_transaction() also prints a
stack trace which makes it more useful.

Also, as this is a very unexpected situation, indicating a serious
corruption/inconsistency, tag the if branch as 'unlikely', set the error
code to -EUCLEAN instead of -EROFS, and log an explicit message.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4912d624ca3d3..886e661a218fc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -417,9 +417,13 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 					       &refs, &flags);
 		if (ret)
 			return ret;
-		if (refs == 0) {
-			ret = -EROFS;
-			btrfs_handle_fs_error(fs_info, ret, NULL);
+		if (unlikely(refs == 0)) {
+			btrfs_crit(fs_info,
+		"found 0 references for tree block at bytenr %llu level %d root %llu",
+				   buf->start, btrfs_header_level(buf),
+				   btrfs_root_id(root));
+			ret = -EUCLEAN;
+			btrfs_abort_transaction(trans, ret);
 			return ret;
 		}
 	} else {
-- 
2.39.2



