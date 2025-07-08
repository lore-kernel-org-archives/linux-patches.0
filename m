Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF2C1DB127;
	Tue,  8 Jul 2025 16:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993413; cv=none; b=pMyLoJf7Bob2mmR9HSwchYGYZlKq7K1rRfiGIM//JVZHKDPRTo4+BPFKqDKgLKrhd4fjetmmbARsB+Hq2M/fb4t5ToFgLPeL06yQkg+iVuCOfrR7Xr27Aib1Tum4atpO3vd0fyctffsB/SQ4vXQ5ox1rUkz3F8RLf6ni5Br+ZO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993413; c=relaxed/simple;
	bh=t3JbKBosVQo/LrN2efddHEQdrVwMSte6/3J1gmnoCMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJ14TrodqBu2G9LLDw+trX31/5g1k3/UHN3+ZTVf8rcGEEdU28w2/2ovoyoqtdk+WT/05uQVrFO02DKMqrRgKAQSXee5PpGnBQX3sASIMELJnRNujbVp/Qnw3MzMlhuxdpKxMgh7LoYOlHFuFERthJm7BnvgSaeGh2AHOqcO9d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tii2si6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tii2si6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244D5C4CEED;
	Tue,  8 Jul 2025 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993413;
	bh=t3JbKBosVQo/LrN2efddHEQdrVwMSte6/3J1gmnoCMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tii2si6JUSMp1d1kB6Ear0Vtb0Ku2cYhLGWS51gbJfWsQXnURy22oaGkxpw7lUFZK
	 rHAR3sFQG8z+uz4mchzHcoEPOCaLq+N+ohVsiYouA1ZWKYaXDVWtkkG8lOvAJJY9N1
	 iW2WZCE5K5ojn3KvfMsHXdHjulJaBYN+nhpe/hsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 065/178] btrfs: fix missing error handling when searching for inode refs during log replay
Date: Tue,  8 Jul 2025 18:21:42 +0200
Message-ID: <20250708162238.373896497@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6561a40ceced9082f50c374a22d5966cf9fc5f5c ]

During log replay, at __add_inode_ref(), when we are searching for inode
ref keys we totally ignore if btrfs_search_slot() returns an error. This
may make a log replay succeed when there was an actual error and leave
some metadata inconsistency in a subvolume tree. Fix this by checking if
an error was returned from btrfs_search_slot() and if so, return it to
the caller.

Fixes: e02119d5a7b4 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ef9660eabf0c6..cc223c3b39c10 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1070,7 +1070,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	search_key.type = BTRFS_INODE_REF_KEY;
 	search_key.offset = parent_objectid;
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
-	if (ret == 0) {
+	if (ret < 0) {
+		return ret;
+	} else if (ret == 0) {
 		struct btrfs_inode_ref *victim_ref;
 		unsigned long ptr;
 		unsigned long ptr_end;
-- 
2.39.5



