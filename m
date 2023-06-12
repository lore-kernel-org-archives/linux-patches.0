Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA506AD3C
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595FEC433D2;
	Mon, 12 Jun 2023 10:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566103;
	bh=RKK6AuOb3zNBcvBx6MLkarRTDF5FMuZBNkCAXgiXSqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhAsk3B0cCytFtUFbV7c6V3y+W0U2vlOgyt3m3A2IMw1xqS+I7ny9BVxVp5dqVZeQ
	 1nKETypGk6ANN54RHgarifEKrp6Bjq2J+MOg4fE8MBN9AaCsvue4vCJo5jGMx1poIm
	 Mfl6+j09GnGmvp7hDIRFv+K390zDNChaVrwIozxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 66/68] btrfs: check return value of btrfs_commit_transaction in relocation
Date: Mon, 12 Jun 2023 12:26:58 +0200
Message-ID: <20230612101701.177628475@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
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
@@ -1895,7 +1895,7 @@ again:
 	list_splice(&reloc_roots, &rc->reloc_roots);
 
 	if (!err)
-		btrfs_commit_transaction(trans);
+		err = btrfs_commit_transaction(trans);
 	else
 		btrfs_end_transaction(trans);
 	return err;
@@ -3270,8 +3270,7 @@ int prepare_to_relocate(struct reloc_con
 		 */
 		return PTR_ERR(trans);
 	}
-	btrfs_commit_transaction(trans);
-	return 0;
+	return btrfs_commit_transaction(trans);
 }
 
 static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
@@ -3443,7 +3442,9 @@ restart:
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


