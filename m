Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF4A18035
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7R0rzvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AD9C433C9;
	Mon,  9 Oct 2023 13:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858801;
	bh=MhMNGkNX0LYJTwIA8+myPWprkMNQj21SwZr8Sk85pb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7R0rzvFrKHoz5TOzDotY7g/ts8DJ9z/GQpopGME1sEwmVTgXwTnLOa7nGI7jPo7x
	 a57zUK8ORuSHWb9mJ9eONnMkIdnDF/ZaDlxcEB9Oib4P4ZKjWSHqGpMsXm9bmHF19N
	 t9L9aBbi9MqHd+owClnBDZvhgwnvqLvHQlnGzePc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/226] btrfs: reset destination buffer when read_extent_buffer() gets invalid range
Date: Mon,  9 Oct 2023 15:00:48 +0200
Message-ID: <20231009130129.051418904@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 74ee79142c0a344d4eae2eb7012ebc4e82254109 ]

Commit f98b6215d7d1 ("btrfs: extent_io: do extra check for extent buffer
read write functions") changed how we handle invalid extent buffer range
for read_extent_buffer().

Previously if the range is invalid we just set the destination to zero,
but after the patch we do nothing and error out.

This can lead to smatch static checker errors like:

  fs/btrfs/print-tree.c:186 print_uuid_item() error: uninitialized symbol 'subvol_id'.
  fs/btrfs/tests/extent-io-tests.c:338 check_eb_bitmap() error: uninitialized symbol 'has'.
  fs/btrfs/tests/extent-io-tests.c:353 check_eb_bitmap() error: uninitialized symbol 'has'.
  fs/btrfs/uuid-tree.c:203 btrfs_uuid_tree_remove() error: uninitialized symbol 'read_subid'.
  fs/btrfs/uuid-tree.c:353 btrfs_uuid_tree_iterate() error: uninitialized symbol 'subid_le'.
  fs/btrfs/uuid-tree.c:72 btrfs_uuid_tree_lookup() error: uninitialized symbol 'data'.
  fs/btrfs/volumes.c:7415 btrfs_dev_stats_value() error: uninitialized symbol 'val'.

Fix those warnings by reverting back to the old memset() behavior.
By this we keep the static checker happy and would still make a lot of
noise when such invalid ranges are passed in.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: f98b6215d7d1 ("btrfs: extent_io: do extra check for extent buffer read write functions")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0e266772beaef..685a375bb6af5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5634,8 +5634,14 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
 	char *dst = (char *)dstv;
 	unsigned long i = start >> PAGE_SHIFT;
 
-	if (check_eb_range(eb, start, len))
+	if (check_eb_range(eb, start, len)) {
+		/*
+		 * Invalid range hit, reset the memory, so callers won't get
+		 * some random garbage for their uninitialzed memory.
+		 */
+		memset(dstv, 0, len);
 		return;
+	}
 
 	offset = offset_in_page(start);
 
-- 
2.40.1



