Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7532E2F18;
	Tue, 15 Jul 2025 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586441; cv=none; b=bnn4KY3Qxo58nrK7mHb/L0/7YDSAyelesohcD4ZdoZeQLJZIyos7kYBmfiQL4qiIG8GuRgNmxZW16YZ2lZYIxIsk6ws9V2fRxcgd8Cmwf6l9WMdvjzXKIfBTmCeXyomm+s0tN+iwLdvWWPUlic6Wzow4qBK5IvmdQjU3myO21ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586441; c=relaxed/simple;
	bh=vO0ybVFdYtiRpS509Ter6qoZp4wfsevSQpzRgd6eoUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjpeJS/WxcY14cKXEK5/ULMQv1plTJV1WaCEONUbp4/cE4PDdytrmEpc6StXIZpwyXGKDX+rL/TdYqnH58N80t3JQdc5HEFbOd4o5RRGRucCFyrdmsSWtGxGFQVkwSvocOhc+/5MnJVSX8u3e+Nb0+NcuRxBCFmoQQ2N0VG6maU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACrw9BIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACrw9BIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D6AC4CEE3;
	Tue, 15 Jul 2025 13:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586441;
	bh=vO0ybVFdYtiRpS509Ter6qoZp4wfsevSQpzRgd6eoUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACrw9BIqTAoOUP7spVD49MSuufqjeVnsmxtdlTKBUzQaMRn20IvbTFgow6XnkNPNg
	 efP7ZB6Be8m3W73jXllT3XWCsiH5yTCJ2Y4pcfQysYh9WOMi9IhMPWfDGobws8a4VQ
	 yn6yborN5wZVRGcK2PnCUTJ2QEqigkIXk9BdSuKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/148] btrfs: fix missing error handling when searching for inode refs during log replay
Date: Tue, 15 Jul 2025 15:13:07 +0200
Message-ID: <20250715130802.931013347@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f75333d7b78a5..75bf490cd7320 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1033,7 +1033,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
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



