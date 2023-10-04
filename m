Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AF01C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2Uf/lym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2DCC433C8;
	Wed,  4 Oct 2023 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444563;
	bh=RrT5DFrO5mUky3OpoBX4a3uUxW+/8XdTxlFVjMMiXJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2Uf/lymp2Lyui8m+slBo+XPYIc7vGN29a0hN8+DcaJadKzHoSvwsNvo+fL+2JFko
	 6jidEED0wi8YzN+DdHTN2NglCeYYtYu31dODmRLrOEtQKxE7s/mgmtDr0clOxKecan
	 8inCkU0n3/A7xNOedrCskrl0+GRWZCt82AaS9VY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 294/321] btrfs: properly report 0 avail for very full file systems
Date: Wed,  4 Oct 2023 19:57:19 +0200
Message-ID: <20231004175242.914817836@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 58bfe2ccec5f9f137b41dd38f335290dcc13cd5c upstream.

A user reported some issues with smaller file systems that get very
full.  While investigating this issue I noticed that df wasn't showing
100% full, despite having 0 chunk space and having < 1MiB of available
metadata space.

This turns out to be an overflow issue, we're doing:

  total_available_metadata_space - SZ_4M < global_block_rsv_size

to determine if there's not enough space to make metadata allocations,
which overflows if total_available_metadata_space is < 4M.  Fix this by
checking to see if our available space is greater than the 4M threshold.
This makes df properly report 100% usage on the file system.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2111,7 +2111,7 @@ static int btrfs_statfs(struct dentry *d
 	 * calculated f_bavail.
 	 */
 	if (!mixed && block_rsv->space_info->full &&
-	    total_free_meta - thresh < block_rsv->size)
+	    (total_free_meta < thresh || total_free_meta - thresh < block_rsv->size))
 		buf->f_bavail = 0;
 
 	buf->f_type = BTRFS_SUPER_MAGIC;


