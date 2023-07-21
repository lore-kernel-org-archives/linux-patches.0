Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C38D27F3E
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82158C433C7;
	Fri, 21 Jul 2023 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966775;
	bh=9Jw6cHR8t+o1avGt3zvSKMMtuQCar3AV5740yJu1NXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lF9fvYTNIhRGbJ637jqutlSGUUT9q8mP2DKJLEAwwg+chAHVmeaxDw/Jk08appbfa
	 wMd+iL5BZn3Od+QwVGrOtxHT1ZfpqyfBQ8SttV1Q2Yboz0vTbmcp710pbQOn1wmdnW
	 fR/Z/ak+Zq8KvERAmrcrf9u1955DLFyQJrMUoLm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 463/532] ext4: get block from bh in ext4_free_blocks for fast commit replay
Date: Fri, 21 Jul 2023 18:06:07 +0200
Message-ID: <20230721160639.652955224@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 11b6890be0084ad4df0e06d89a9fdcc948472c65 upstream.

ext4_free_blocks will retrieve block from bh if block parameter is zero.
Retrieve block before ext4_free_blocks_simple to avoid potentially
passing wrong block to ext4_free_blocks_simple.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-9-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6171,12 +6171,6 @@ void ext4_free_blocks(handle_t *handle,
 
 	sbi = EXT4_SB(sb);
 
-	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
-		ext4_free_blocks_simple(inode, block, count);
-		return;
-	}
-
-	might_sleep();
 	if (bh) {
 		if (block)
 			BUG_ON(block != bh->b_blocknr);
@@ -6184,6 +6178,13 @@ void ext4_free_blocks(handle_t *handle,
 			block = bh->b_blocknr;
 	}
 
+	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
+		ext4_free_blocks_simple(inode, block, count);
+		return;
+	}
+
+	might_sleep();
+
 	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
 	    !ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks not in datazone - "


