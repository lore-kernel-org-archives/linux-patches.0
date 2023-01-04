Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B232AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50EDC433EF;
	Wed,  4 Jan 2023 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849632;
	bh=u3zHtlQsP12Ra3f/B/bvG47e3nPFrKyX4RCwckyKPqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XC8MKpHJ/fybGmeF9NodbAqOBrxlFts+ztfs+Zy4l58GTE+xdP0+V/pp4lh5i63hG
	 5p3A2igChlQeoxtK/RNgoSoXc33a+F/F74Ek1Ls/tUawyA9hfVy2RIEEWhdy6PaDyA
	 eW2lcbp55IRh8+yx0mefScvrU7FiqYFRHT5oGbG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.0 167/177] ext4: allocate extended attribute value in vmalloc area
Date: Wed,  4 Jan 2023 17:07:38 +0100
Message-Id: <20230104160512.739375557@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

commit cc12a6f25e07ed05d5825a1664b67a970842b2ca upstream.

Now, extended attribute value maximum length is 64K. The memory
requested here does not need continuous physical addresses, so it is
appropriate to use kvmalloc to request memory. At the same time, it
can also cope with the situation that the extended attribute will
become longer in the future.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221208023233.1231330-3-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2550,7 +2550,7 @@ static int ext4_xattr_move_to_block(hand
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kmalloc(value_size, GFP_NOFS);
+	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
 	if (!is || !bs || !buffer || !b_entry_name) {
 		error = -ENOMEM;
@@ -2602,7 +2602,7 @@ static int ext4_xattr_move_to_block(hand
 	error = 0;
 out:
 	kfree(b_entry_name);
-	kfree(buffer);
+	kvfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);
 	if (bs)


