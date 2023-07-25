Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D543E1EA7E
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57830C433C8;
	Tue, 25 Jul 2023 11:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283308;
	bh=4YizPSOdcxOpe26SPgmpteg0DlIe9dzzGvuk8AGEH0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1v3VAgruh1xa78A14kXWPJdqH7YWFZA+NvMjbRas79McaxGu6wbkzA80qtQkIygHW
	 pa7DWYFD9X7uDMwUecroCzNJ4QnHRsL4VX5nKBMoWdXAOk/BNft0cgSRFrN8ZdlVzt
	 PKnnjUdTmITzD+F/ABhdulifCadtlLToermPanf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 08/78] btrfs: zoned: fix memory leak after finding block group with super blocks
Date: Tue, 25 Jul 2023 12:45:59 +0200
Message-ID: <20230725104451.648547994@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
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

commit f1a07c2b4e2c473ec322b8b9ece071b8c88a3512 upstream.

At exclude_super_stripes(), if we happen to find a block group that has
super blocks mapped to it and we are on a zoned filesystem, we error out
as this is not supposed to happen, indicating either a bug or maybe some
memory corruption for example. However we are exiting the function without
freeing the memory allocated for the logical address of the super blocks.
Fix this by freeing the logical address.

Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1855,6 +1855,7 @@ static int exclude_super_stripes(struct
 
 		/* Shouldn't have super stripes in sequential zones */
 		if (zoned && nr) {
+			kfree(logical);
 			btrfs_err(fs_info,
 			"zoned: block group %llu must not contain super block",
 				  cache->start);


