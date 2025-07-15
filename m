Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B092EBDC3;
	Tue, 15 Jul 2025 13:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587644; cv=none; b=sR0rKElgNMYTl/WebkAIHoHDkjAzbmG2BJrnOkGdE0zkn71c8EF4lxmgAsL34YcJfV06dDcTbjk/I+9zVvfRkKeOq3IWKjCChps52woVt7Pf8Yd0jMHxDZTtYtYVMw4UgvLPe9AI3K6zhsOLS6lBGshXP49TNVfJpiTiitWGL6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587644; c=relaxed/simple;
	bh=Yl7V3Y7bPXrq+DUc9G3u1sCbXKk7szKaWlfvWeT0VEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krXPewE70YOI2jVmKTgawtuZp9pZeyBpg1qsOLdKpJUFrWjDxOa3cSlXtMDMwdRq8ManKr1uVflYQhMDZ+fiJHryzZcj3kMKEjBCmkZqBUFx/7HPEe4rvOyLCyG8fYr7W7jC0NB5f0yQ3D5rMm1MTZpq1PKCj6LAL3/ElpnVv7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TATeT4EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TATeT4EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675C4C4CEF4;
	Tue, 15 Jul 2025 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587644;
	bh=Yl7V3Y7bPXrq+DUc9G3u1sCbXKk7szKaWlfvWeT0VEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TATeT4EHapWBt94hLvcpb6Vd/nLe1+mK4JIhaGCT58sQPIP9vy97QMuICzyGTK6qY
	 C4v1c5OuWEAuK/1Eu2xRHQtkE82eBojgIzFbY+O4JlEPDiDzesMnGGBT5ackH1Bl8U
	 VTOYDJfyzlRknt3wTeE/d34IO5VYDcebrXzFFGVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/208] btrfs: fix missing error handling when searching for inode refs during log replay
Date: Tue, 15 Jul 2025 15:13:18 +0200
Message-ID: <20250715130814.507367160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4ee6814293279..dd1c40019412c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1005,7 +1005,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
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



