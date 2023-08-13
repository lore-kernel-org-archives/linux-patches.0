Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B29443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCDBC433C7;
	Sun, 13 Aug 2023 21:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962360;
	bh=eQt7qd2P1Afc1nZDVmMp/yLSa/HpBufOBZvujW1dcOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjW9hKwZraOZjd3oYEss7ecXD5kspxbbG16vX+T5Ftz6pFeADAtR8IW/HEjq5kVET
	 mbi+yLQic7jL8WdIMX04mH75b1UvsrWcsCH13xsDQy5nutH1rUsgfXX5GdB4La6hqr
	 c9guB0kbiZjjNdKnqDCfSiHPgSdI+Ik8aHJP+c4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 188/206] btrfs: set cache_block_group_error if we find an error
Date: Sun, 13 Aug 2023 23:19:18 +0200
Message-ID: <20230813211730.403252978@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
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
@@ -4318,8 +4318,11 @@ have_block_group:
 			ret = 0;
 		}
 
-		if (unlikely(block_group->cached == BTRFS_CACHE_ERROR))
+		if (unlikely(block_group->cached == BTRFS_CACHE_ERROR)) {
+			if (!cache_block_group_error)
+				cache_block_group_error = -EIO;
 			goto loop;
+		}
 
 		if (!find_free_extent_check_size_class(ffe_ctl, block_group))
 			goto loop;


