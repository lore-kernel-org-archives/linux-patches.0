Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9151F03C5;
	Tue, 30 Sep 2025 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244286; cv=none; b=hItQBhA9meYY5c/PbaG/STI6/CrU4QjeTxzuqPa02lkeuekauxQmllVFyAstrDWOdU9xFP14/DXlK1M8m9//uJFt2gOqq/e7HVzFkarQRg9mXHGtXw50nJRaOYdLz5bc6yEP5NWh6yu0MOesIRcSh70P7D6BB6lcAb6zhw7dJBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244286; c=relaxed/simple;
	bh=crxPKSi79onbzGw4oVguT72ya4DJTAdg1O0IhtFoRCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orLKLdDg9rE8MfoKkONJfYYG1wxI/I8Tc2TWOKT70PdHX6h5ay5jXBjzj+X1zitR0livMlgRRy7q9+kw65QfcRa9kdK0jqK5t0IYYj8wsd7h8x+ujDUu/BPaGF8t0NWpkbLRRBGxEMymAIS6DbkgjoXxPDY0PH/JqGeQYvUGYIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqTjfI5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqTjfI5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A08EC4CEF0;
	Tue, 30 Sep 2025 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244286;
	bh=crxPKSi79onbzGw4oVguT72ya4DJTAdg1O0IhtFoRCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqTjfI5psOVcfvswjWghuJ2ZIXMOeiHjU0+IFkV0op93BGfMQdlLbKZG3WwsiLfmv
	 i+b5od0WrSLLsq/n1UAxz8dg9biIXaYFbcQYaZGCiLMXom2dcRQB+sEeC63gA1t5M1
	 jq/6mLZs6UdLSQ7aKswlWRzzGR2vhqNs6A2sKPSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/122] btrfs: tree-checker: fix the incorrect inode ref size check
Date: Tue, 30 Sep 2025 16:46:53 +0200
Message-ID: <20250930143826.356905778@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 96fa515e70f3e4b98685ef8cac9d737fc62f10e1 ]

[BUG]
Inside check_inode_ref(), we need to make sure every structure,
including the btrfs_inode_extref header, is covered by the item.  But
our code is incorrectly using "sizeof(iref)", where @iref is just a
pointer.

This means "sizeof(iref)" will always be "sizeof(void *)", which is much
smaller than "sizeof(struct btrfs_inode_extref)".

This will allow some bad inode extrefs to sneak in, defeating tree-checker.

[FIX]
Fix the typo by calling "sizeof(*iref)", which is the same as
"sizeof(struct btrfs_inode_extref)", and will be the correct behavior we
want.

Fixes: 71bf92a9b877 ("btrfs: tree-checker: Add check for INODE_REF")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ Added unlikely() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1545,10 +1545,10 @@ static int check_inode_ref(struct extent
 	while (ptr < end) {
 		u16 namelen;
 
-		if (ptr + sizeof(iref) > end) {
+		if (unlikely(ptr + sizeof(*iref) > end)) {
 			inode_ref_err(leaf, slot,
 			"inode ref overflow, ptr %lu end %lu inode_ref_size %zu",
-				ptr, end, sizeof(iref));
+				ptr, end, sizeof(*iref));
 			return -EUCLEAN;
 		}
 


