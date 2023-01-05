Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DE28495
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938E7C433D2;
	Thu,  5 Jan 2023 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672924158;
	bh=+mj1P2kF30qa2AXKJ9+jWzIuU+Ker3aCexsGNA1TsgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2eG/avjUF/cRjcKg0K30HPwRPhRJRAFdTLXAzcxkt48eA2NyyNF64g6e7a57q+I8
	 5eJAxTPGRQMqX8F4Qbrn8/Y51gRXEc0Yz+VScHH/KYxqenbOmTegvTh7ANh/nXmXQb
	 1UPuHIP5pKphxd8MhVcvg4rcCQkvt2VGIj1jSW1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 251/251] ext4: initialize quota before expanding inode in setproject ioctl
Date: Thu,  5 Jan 2023 13:56:28 +0100
Message-Id: <20230105125346.370780485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

commit 1485f726c6dec1a1f85438f2962feaa3d585526f upstream.

Make sure we initialize quotas before possibly expanding inode space
(and thus maybe needing to allocate external xattr block) in
ext4_ioctl_setproject(). This prevents not accounting the necessary
block allocation.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221207115937.26601-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -333,6 +333,10 @@ static int ext4_ioctl_setproject(struct
 	if (IS_NOQUOTA(inode))
 		goto out_unlock;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		goto out_unlock;
@@ -345,10 +349,6 @@ static int ext4_ioctl_setproject(struct
 	}
 	brelse(iloc.bh);
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);


