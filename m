Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BB846B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93077C433D2;
	Mon, 16 Jan 2023 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886714;
	bh=w09RPJxjAR0Q4FlYYbbeTSrWsTeLwtO3akJKUHGKUsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sM0iOJWx/MS6OsGnB2gk+oz1sgIRgwWu9ac3L/kLnwH5yYc1zi18TFXrmhiftZ7Mn
	 QNAe9amtmt5C7OMGwIdwJ9dqdwPMZpfkFT3mldZeWpJA2F0bd9a94uMgHZpLxcqym1
	 t0NB+v/kBJ8HEqMCcZNUWrDKCls7v4KK/6wEP9ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 534/658] ext4: initialize quota before expanding inode in setproject ioctl
Date: Mon, 16 Jan 2023 16:50:22 +0100
Message-Id: <20230116154933.962935721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
@@ -461,6 +461,10 @@ static int ext4_ioctl_setproject(struct
 	if (ext4_is_quota_file(inode))
 		return err;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		return err;
@@ -476,10 +480,6 @@ static int ext4_ioctl_setproject(struct
 		brelse(iloc.bh);
 	}
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);


