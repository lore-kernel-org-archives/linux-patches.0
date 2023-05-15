Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E861BFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAA9C433D2;
	Mon, 15 May 2023 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170491;
	bh=bJvDzSiDRA/0B0ffx4zdfOhdzPoS6Nb4VA6jEJaBP0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDyvJajA5x2avB+C3tLwSI8kLwKOW4roFcJa3StnV5v15Y3lGz6IXQ6M+WdikKWZn
	 aVgCRkwOfakhac9s9oNNPsRALslZ8rxsWFhJuHF21ToLoZtF+1+pA+uuVrVDYru2s2
	 u/tEJtZRSoaQN0LVeKdeNmKjnTtsW/bFAi98uKk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 118/239] btrfs: fix space cache inconsistency after error loading it from disk
Date: Mon, 15 May 2023 18:26:21 +0200
Message-Id: <20230515161725.242555481@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

commit 0004ff15ea26015a0a3a6182dca3b9d1df32e2b7 upstream.

When loading a free space cache from disk, at __load_free_space_cache(),
if we fail to insert a bitmap entry, we still increment the number of
total bitmaps in the btrfs_free_space_ctl structure, which is incorrect
since we failed to add the bitmap entry. On error we then empty the
cache by calling __btrfs_remove_free_space_cache(), which will result
in getting the total bitmaps counter set to 1.

A failure to load a free space cache is not critical, so if a failure
happens we just rebuild the cache by scanning the extent tree, which
happens at block-group.c:caching_thread(). Yet the failure will result
in having the total bitmaps of the btrfs_free_space_ctl always bigger
by 1 then the number of bitmap entries we have. So fix this by having
the total bitmaps counter be incremented only if we successfully added
the bitmap entry.

Fixes: a67509c30079 ("Btrfs: add a io_ctl struct and helpers for dealing with the space cache")
Reviewed-by: Anand Jain <anand.jain@oracle.com>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -861,15 +861,16 @@ static int __load_free_space_cache(struc
 			}
 			spin_lock(&ctl->tree_lock);
 			ret = link_free_space(ctl, e);
-			ctl->total_bitmaps++;
-			recalculate_thresholds(ctl);
-			spin_unlock(&ctl->tree_lock);
 			if (ret) {
+				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
+			ctl->total_bitmaps++;
+			recalculate_thresholds(ctl);
+			spin_unlock(&ctl->tree_lock);
 			list_add_tail(&e->list, &bitmaps);
 		}
 


