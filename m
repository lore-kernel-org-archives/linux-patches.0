Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3554431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98102C433D2;
	Wed, 15 Mar 2023 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883549;
	bh=9QoEpDcIcUd29OnwvTMF++ZEnTZS/FtRkMHXth4qmQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idFebO5oLqJRMTlQyt4EaMcP74NdLtPlDiLo6q8INg6B6Etwss4X193C+xIHD+n0y
	 rvEA5c/HQMqCB8lrbm/HfAIeYISEnVizASP6oeMkPNzrpPPCF0Dn2tr0K9ktSNUSyc
	 xhUUNZ2p59IMu0evF5sfzyecD/JmO79TjgJ+NWI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/143] udf: Fix off-by-one error when discarding preallocation
Date: Wed, 15 Mar 2023 13:12:06 +0100
Message-Id: <20230315115741.727698686@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit f54aa97fb7e5329a373f9df4e5e213ced4fc8759 ]

The condition determining whether the preallocation can be used had
an off-by-one error so we didn't discard preallocation when new
allocation was just following it. This can then confuse code in
inode_getblk().

CC: stable@vger.kernel.org
Fixes: 16d055656814 ("udf: Discard preallocation before extending file with a hole")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 259152a08852b..a4e875b61f895 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -443,7 +443,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	 * Block beyond EOF and prealloc extents? Just discard preallocation
 	 * as it is not useful and complicates things.
 	 */
-	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+	if (((loff_t)block) << inode->i_blkbits >= iinfo->i_lenExtents)
 		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
-- 
2.39.2



