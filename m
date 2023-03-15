Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5AF4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C875AC433D2;
	Wed, 15 Mar 2023 12:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883172;
	bh=aA5HqEZj/XixqWMm8gqMQmPAnsUD2Yx5ds8zraWhddk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFDGBnxHmnu/ULDYViux11FCvhy/du8hHW/2bt+riWTR4RfIij4UzgQ/84S5kJEro
	 ZMhimXEIMYldjN2hJ304Lmk2B2QyTjsmvC0wDlwTWOMrI829NpJmysv/8sHjdlL6fd
	 dzrFWg9DmNrOf0jRXrB3FwOrQ2lut8jYAMgPyxak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 012/145] ext4: move where set the MAY_INLINE_DATA flag is set
Date: Wed, 15 Mar 2023 13:11:18 +0100
Message-Id: <20230315115739.400439574@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

commit 1dcdce5919115a471bf4921a57f20050c545a236 upstream.

The only caller of ext4_find_inline_data_nolock() that needs setting of
EXT4_STATE_MAY_INLINE_DATA flag is ext4_iget_extra_inode().  In
ext4_write_inline_data_end() we just need to update inode->i_inline_off.
Since we are going to add one more caller that does not need to set
EXT4_STATE_MAY_INLINE_DATA, just move setting of EXT4_STATE_MAY_INLINE_DATA
out to ext4_iget_extra_inode().

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230307015253.2232062-2-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    1 -
 fs/ext4/inode.c  |    7 ++++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -158,7 +158,6 @@ int ext4_find_inline_data_nolock(struct
 					(void *)ext4_raw_inode(&is.iloc));
 		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
 				le32_to_cpu(is.s.here->e_value_size);
-		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	}
 out:
 	brelse(is.iloc.bh);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4549,8 +4549,13 @@ static inline int ext4_iget_extra_inode(
 
 	if (EXT4_INODE_HAS_XATTR_SPACE(inode)  &&
 	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
+		int err;
+
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-		return ext4_find_inline_data_nolock(inode);
+		err = ext4_find_inline_data_nolock(inode);
+		if (!err && ext4_has_inline_data(inode))
+			ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		return err;
 	} else
 		EXT4_I(inode)->i_inline_off = 0;
 	return 0;


