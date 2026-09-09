Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836A859481E;
	Wed,  9 Sep 2026 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963564; cv=none; b=F0KG8fploiAp+e2sz1PYicX+LgQotStmJeGjxM1itbRcbp9CATrw+xpbE6Xuuukejhc7q2jXZ9GW9cn8BdZCNUgSmou0gpLAeaW34PSJx9pfU3aQrJowaKfiBNyUOeBVOLNMl+FWVhWrS+JgTZ198LtNdV+FWPg4Dxg/2XGHx7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963564; c=relaxed/simple;
	bh=HWYqd4I4aIVz+tZafZGqzgh7/to9Ngijn8j3uwJlouM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdrSq/MjC72uKgocPY/GEgD0pxdq0o8fteGh0b0y1YEwXxznsi6hO8JcQj5C6MyDMyDjZ6bxtCPEHj6GyMsenXLVWndH8A+N3NfDZNAcA2kwUADBedsAJXK1pUiR8PCkKPzwg56CQrIuLM9zIUJ2BvJGVFWiQoUmY4E31d+5WP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1lixMct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1lixMct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0C61F00A3E;
	Wed,  9 Sep 2026 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963563;
	bh=c0UwYEOf7ISWZihruc6bev+OlX6GmCWkWcC2RWoV9f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1lixMctDzbTA6mV9QaXpefaL/NF5O6WTf+BpPO4PHg49BpPolyHMly/PRfMkxza4
	 Pn7DI3/Eua9oAFy2og80dgc4R2l2DswpUT1d/K/kR3Y3gDIqaVQxeT8rWI+F+Phjne
	 61X43fgLRGU0B+VPJNdWnGuPvj7CVCV7WzA+xKR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com,
	Nirbhay Sharma <nirbhay.lkd@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/583] fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list
Date: Wed,  9 Sep 2026 15:36:09 +0200
Message-ID: <20260909134241.033707199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirbhay Sharma <nirbhay.lkd@gmail.com>

[ Upstream commit 5f33da04e6ceee849e76e6592cc283c72fef7af9 ]

The call to kmalloc() to allocate the attribute list buffer is given a
size of al_aligned(rs). This size can be larger than the data
subsequently copied into the buffer, leaving trailing bytes uninitialized.

This can trigger a KMSAN "uninit-value" warning if that memory is
later accessed.

Fix this by using kzalloc() instead, which ensures the entire
allocated buffer is zero-initialized, preventing the warning.

Reported-by: syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83c9dd5c0dcf6184fdbf
Signed-off-by: Nirbhay Sharma <nirbhay.lkd@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 3a458975181c4..b24035c351925 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -769,7 +769,7 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	 * Skip estimating exact memory requirement.
 	 * Looks like one record_size is always enough.
 	 */
-	le = kmalloc(al_aligned(rs), GFP_NOFS);
+	le = kzalloc(al_aligned(rs), GFP_NOFS);
 	if (!le)
 		return -ENOMEM;
 
-- 
2.53.0



