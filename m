Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FAD39FF3;
	Fri, 24 Nov 2023 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLBXdnFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E162BC433C8;
	Fri, 24 Nov 2023 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849828;
	bh=vLY4ck8bCOeFdCVX0QaNsXWUKv0in3K+chja6jz0bAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLBXdnFyovPoDS2Zp356geZ+sA7EsHSYi2prjh5LYKk4tiF2UEGZOZDh7XsN9VqW6
	 gon3PHK4bk5JYRpuEfnFYQZkAbgbXB6UyQHOxPYYeVe/7dAYr7NVt56BwcOmcjvLHs
	 XSM0q8iRc7XB2yflHVwitWwsRwSKsPLUALJuS9IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 337/530] btrfs: dont arbitrarily slow down delalloc if were committing
Date: Fri, 24 Nov 2023 17:48:23 +0000
Message-ID: <20231124172038.286510847@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 11aeb97b45ad2e0040cbb2a589bc403152526345 upstream.

We have a random schedule_timeout() if the current transaction is
committing, which seems to be a holdover from the original delalloc
reservation code.

Remove this, we have the proper flushing stuff, we shouldn't be hoping
for random timing things to make everything work.  This just induces
latency for no reason.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delalloc-space.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -322,9 +322,6 @@ int btrfs_delalloc_reserve_metadata(stru
 	} else {
 		if (current->journal_info)
 			flush = BTRFS_RESERVE_FLUSH_LIMIT;
-
-		if (btrfs_transaction_in_commit(fs_info))
-			schedule_timeout(1);
 	}
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);


