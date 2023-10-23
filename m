Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE9415E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty2SUvVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA583C433CA;
	Mon, 23 Oct 2023 11:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061094;
	bh=FlnxSLwIBRIW7+8OtPLExaq/nwwRX5JbKhnq117q7MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty2SUvVGXIBUd5Prm34mQRXFw/RabpfK6AmcUAxK420zsvK2EaeENwY/iWqmP6zlR
	 SqO9p2DsAkxIRUNmyXSmNiopaWQGXLet5gkWgklqTONaOMgGWi70fUHyJCN2tw3HW2
	 g+W24WxL/SwGCVdwpn86fIuSC+Xo37nUJfWlGfNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/137] btrfs: return -EUCLEAN for delayed tree ref with a ref count not equals to 1
Date: Mon, 23 Oct 2023 12:57:07 +0200
Message-ID: <20231023104823.309706898@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 1bf76df3fee56d6637718e267f7c34ed70d0c7dc ]

When running a delayed tree reference, if we find a ref count different
from 1, we return -EIO. This isn't an IO error, as it indicates either a
bug in the delayed refs code or a memory corruption, so change the error
code from -EIO to -EUCLEAN. Also tag the branch as 'unlikely' as this is
not expected to ever happen, and change the error message to print the
tree block's bytenr without the parenthesis (and there was a missing space
between the 'block' word and the opening parenthesis), for consistency as
that's the style we used everywhere else.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 48f2de789b755..a19bdb3597405 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1674,12 +1674,12 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		parent = ref->parent;
 	ref_root = ref->root;
 
-	if (node->ref_mod != 1) {
+	if (unlikely(node->ref_mod != 1)) {
 		btrfs_err(trans->fs_info,
-	"btree block(%llu) has %d references rather than 1: action %d ref_root %llu parent %llu",
+	"btree block %llu has %d references rather than 1: action %d ref_root %llu parent %llu",
 			  node->bytenr, node->ref_mod, node->action, ref_root,
 			  parent);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
-- 
2.40.1



