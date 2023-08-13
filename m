Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3109443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B74C433C7;
	Sun, 13 Aug 2023 21:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962379;
	bh=D/zCZ/lLsKSaKVthLupujWj3giWgIWTGCj6S7xmS6po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7eMI0x2U9r1hzRx8waNcp0uwo3nA6XCsh3Vj+nnyMIJalOFFrjqpj9HrvAmF0aud
	 z3XW2NIreb/sSWZqfDZQupon97jU5nh5fVj2alKWVCDyLupjOftbb9kGfx91Eao1iv
	 JJOnyFm1OOsAugdIbIyahg5KpYNJzvjcMUYd01cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 185/206] btrfs: properly clear end of the unreserved range in cow_file_range
Date: Sun, 13 Aug 2023 23:19:15 +0200
Message-ID: <20230813211730.318215521@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 12b2d64e591652a2d97dd3afa2b062ca7a4ba352 upstream.

When the call to btrfs_reloc_clone_csums in cow_file_range returns an
error, we jump to the out_unlock label with the extent_reserved variable
set to false.   The cleanup at the label will then call
extent_clear_unlock_delalloc on the range from start to end.  But we've
already added cur_alloc_size to start before the jump, so there might no
range be left from the newly incremented start to end.  Move the check for
'start < end' so that it is reached by also for the !extent_reserved case.

CC: stable@vger.kernel.org # 6.1+
Fixes: a315e68f6e8b ("Btrfs: fix invalid attempt to free reserved space on failure to cow range")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1453,8 +1453,6 @@ out_unlock:
 					     clear_bits,
 					     page_ops);
 		start += cur_alloc_size;
-		if (start >= end)
-			return ret;
 	}
 
 	/*
@@ -1463,9 +1461,11 @@ out_unlock:
 	 * space_info's bytes_may_use counter, reserved in
 	 * btrfs_check_data_free_space().
 	 */
-	extent_clear_unlock_delalloc(inode, start, end, locked_page,
-				     clear_bits | EXTENT_CLEAR_DATA_RESV,
-				     page_ops);
+	if (start < end) {
+		clear_bits |= EXTENT_CLEAR_DATA_RESV;
+		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+					     clear_bits, page_ops);
+	}
 	return ret;
 }
 


