Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F45C334C3B;
	Wed, 23 Sep 2026 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173474; cv=none; b=enpHG5yBz0ssA3PwdHxxIDtbUE/eqhuF1rpZ+nLetLf5E2AKu+MJ/3tnR3YSzasW0yTuIWco5RrJ3C/FPqHuVqXRKmvqhMfCOARVb4ViVOqXEgXlloxisBjeJGo8yylhFhcuM0TCuSd7juBy7KzxWfcgb4BOenhRez5QrYzbRa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173474; c=relaxed/simple;
	bh=VGonTURYXV6qde/nfA/DCKrUfxw7vHq/ZEpcUtmdLIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaMvXGTCPWQwZM1SrExkvgOAdDgf8ygQ3T5PuJpAM7yV1L+vMMgtc1W+hfHkvCZ04E9MHz/Vc0+O7B996QxLYEEfCg1TnsXkQRCj0m8vYul83b3E5RrbRYuYkyXrccf7YpdA9xsDVJoljtht7QIKT0cOFZf4lVcQDWJJDavVUA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiXfYxI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiXfYxI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B291C1F000FF;
	Wed, 23 Sep 2026 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173473;
	bh=RU4XG6YxgH2VCVcDOyAFGT967nfmCU5C4ydPKJvEwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiXfYxI5DFUX/fC9+I6Rnqvya1PjhgTYjFdZbAXtGeZGNzoqsBCxjKQ7utV8xmyvm
	 bzQSr8Kh8w05tQAgSS/nGz6y1kVyBlEE/VnUr9q+WGiUknElPrlQIkQ7UHq5EUH9H8
	 wFeqyveWT55M02o0G8KvI0vIX7oLPvwWSpo4S98M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 224/438] btrfs: abort transaction on failure to update inode for hole punching and reflinking
Date: Wed, 23 Sep 2026 16:04:05 +0200
Message-ID: <20260923140650.572088928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 97fcd34aa9fd73cefe3120ac9a82ca9d7763922f ]

If we fail to update the inode we error out without aborting the
transaction, which can result in a persistent inconsistency if after
the failure the transaction is committed, as we have dropped file
extent items from a range and either punched a hole or insert a new file
extent item for that range (for reflinks).

So add the missing transaction abort.

Fixes: 2aaa66558172 ("Btrfs: add hole punching")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f949805f2c3ef..d892683927149 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2513,8 +2513,10 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 					      inode_set_ctime_current(&inode->vfs_inode));
 
 		ret = btrfs_update_inode(trans, inode);
-		if (ret)
+		if (unlikely(ret)) {
+			btrfs_abort_transaction(trans, ret);
 			break;
+		}
 
 		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
-- 
2.53.0



