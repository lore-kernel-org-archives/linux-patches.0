Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5429446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDD7C433C8;
	Sun, 13 Aug 2023 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963313;
	bh=wu5YlgdflatvhWqqwHRrh3+ChpzUqewkexHXrF5pZy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdPjdreWZ4sKjxvIxKqY2/2LYaR/mDtt4gFz6tcURtPBP/6E9AKD2NARG7gFtY9e6
	 TJB7o7rPYRkaPOdVFTJGtYQIDhgNddHWSMBD6URGb1/4NEkJlg2ixbSbiQietMlPsx
	 41ZcxULEoSSiDEjsh8b4Uq5hRkFOEmlQqJ1JWqSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 29/39] btrfs: set cache_block_group_error if we find an error
Date: Sun, 13 Aug 2023 23:20:20 +0200
Message-ID: <20230813211705.801302111@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
References: <20230813211704.796906808@linuxfoundation.org>
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

commit 92fb94b69c6accf1e49fff699640fa0ce03dc910 upstream.

We set cache_block_group_error if btrfs_cache_block_group() returns an
error, this is because we could end up not finding space to allocate and
mistakenly return -ENOSPC, and which could then abort the transaction
with the incorrect errno, and in the case of ENOSPC result in a
WARN_ON() that will trip up tests like generic/475.

However there's the case where multiple threads can be racing, one
thread gets the proper error, and the other thread doesn't actually call
btrfs_cache_block_group(), it instead sees ->cached ==
BTRFS_CACHE_ERROR.  Again the result is the same, we fail to allocate
our space and return -ENOSPC.  Instead we need to set
cache_block_group_error to -EIO in this case to make sure that if we do
not make our allocation we get the appropriate error returned back to
the caller.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3989,8 +3989,11 @@ have_block_group:
 			ret = 0;
 		}
 
-		if (unlikely(block_group->cached == BTRFS_CACHE_ERROR))
+		if (unlikely(block_group->cached == BTRFS_CACHE_ERROR)) {
+			if (!cache_block_group_error)
+				cache_block_group_error = -EIO;
 			goto loop;
+		}
 
 		/*
 		 * Ok we want to try and use the cluster allocator, so


