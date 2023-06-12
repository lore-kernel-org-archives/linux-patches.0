Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008FF168A6
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D872C433D2;
	Mon, 12 Jun 2023 10:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565925;
	bh=I3Z1qdOgquV4y6gNQwSq/xK8lRpaqCtjAQvOZEh0sPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZM22/4P74KU9Ki4OQm190vGikOsIiCqB7RsAuX2O364i9AFI10YyCVO5lNE9hv5Te
	 gxlC+hsIy2dr7Ypjam8b1c9xGnCwtQPYcyqMn9HZ/MEkOu1qUq9PrhAwDPQNRQuFR1
	 yr5qppPlKK2Sh2c6qG4/QEoW6ZEJJUR+JjIOzBu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 42/45] btrfs: check return value of btrfs_commit_transaction in relocation
Date: Mon, 12 Jun 2023 12:26:36 +0200
Message-ID: <20230612101656.339643484@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

commit fb686c6824dd6294ca772b92424b8fba666e7d00 upstream.

There are a few places where we don't check the return value of
btrfs_commit_transaction in relocation.c.  Thankfully all these places
have straightforward error handling, so simply change all of the sites
at once.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2511,7 +2511,7 @@ again:
 	list_splice(&reloc_roots, &rc->reloc_roots);
 
 	if (!err)
-		btrfs_commit_transaction(trans);
+		err = btrfs_commit_transaction(trans);
 	else
 		btrfs_end_transaction(trans);
 	return err;
@@ -4102,8 +4102,7 @@ int prepare_to_relocate(struct reloc_con
 		 */
 		return PTR_ERR(trans);
 	}
-	btrfs_commit_transaction(trans);
-	return 0;
+	return btrfs_commit_transaction(trans);
 }
 
 static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
@@ -4263,7 +4262,9 @@ restart:
 		err = PTR_ERR(trans);
 		goto out_free;
 	}
-	btrfs_commit_transaction(trans);
+	ret = btrfs_commit_transaction(trans);
+	if (ret && !err)
+		err = ret;
 out_free:
 	ret = clean_dirty_subvols(rc);
 	if (ret < 0 && !err)


