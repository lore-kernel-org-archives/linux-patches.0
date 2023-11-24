Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872A22FC36;
	Fri, 24 Nov 2023 19:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DE1ar3Kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18918C433C7;
	Fri, 24 Nov 2023 19:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853451;
	bh=M9rgfuV65kQoaMlQOG7IlJoo2xUsF3/fhyk5LSyQyN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DE1ar3KhMSYeLc/PE844RgRXrsLBcboQ2/zZwXaQkPkqdWoHm9AtVO7swJyayRYHk
	 xxmyDZUqs2lUplXagl1xhNaJi+okAuMNbkejQ3CMBCajegvMcoLKeLtURfWFpSHdG9
	 VfDPk0Ma7Vxgv+ehAYoMX+bstZNpjg7m+mwDuY54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 194/297] btrfs: dont arbitrarily slow down delalloc if were committing
Date: Fri, 24 Nov 2023 17:53:56 +0000
Message-ID: <20231124172007.009601044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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
@@ -312,9 +312,6 @@ int btrfs_delalloc_reserve_metadata(stru
 	} else {
 		if (current->journal_info)
 			flush = BTRFS_RESERVE_FLUSH_LIMIT;
-
-		if (btrfs_transaction_in_commit(fs_info))
-			schedule_timeout(1);
 	}
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);


