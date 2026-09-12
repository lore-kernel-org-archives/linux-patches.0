Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDF44369A;
	Sat, 12 Sep 2026 19:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239792; cv=none; b=LTTlyG78QtvlzlAW7eBz74/gdk2pT6njm6y6Eds7ceL/OZQNvEOgTVqKKYZfCwCc4VCYjH8pgPvpzJ0QCR4sqec2eVDKZc7l4ZgqYjmaxcbesyGVGtDra2iuYxbFIeUuotYMLfqLpC2akhM1ucMgpmnxB6Y3BZw9dQjg3R+ThPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239792; c=relaxed/simple;
	bh=BRipjNxmW8HV+lvI3iLNnscd3Ol0Vgcr0IGaFnPbayo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOPHBlslhJsNL3erSk3xfMyxxiYE6vxf6LX4XK559f3mZu1bWs/gNG/lywpEKoHQsGj8ZCO1KPiBsSC3plTf2dsjRQm4/pH8Gzttt9lhHyoVRQjLSicJcRlfuLo8eioi3ILMLLvVg3pIxdFY8mFm9USfC9KKEmI6CA2HrF1eW34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSZCrHyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSZCrHyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FD01F000FF;
	Sat, 12 Sep 2026 19:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239791;
	bh=f9Zf9J8wSdHMWOJEY93oUwdWOUq93WFpZi8D9vplUiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSZCrHybv2lprhotwVX/dBwCWmdU/Q1sBph8iN94b96Q5cFaYwM8cu6QB8Mj68vdD
	 4ciSoTJOUXRMn2NYeLBHjM6LqhTSEZpSJnPXZ9N9cCPenrXVcpKIduC4DhX+I4CP+0
	 gm2TXMvBpXsUuUhtJ0eswngCTLwL6EBvNQ/2M0sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 737/935] hugetlbfs: release subpool on fill_super failure
Date: Sat, 12 Sep 2026 09:02:47 +0200
Message-ID: <20260912065543.734795287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 308ab73e97c87bd0e142b11758faab7f88d82854 ]

hugetlbfs_fill_super() allocates a hugepage subpool when size or min_size
mount options are specified.  hugepage_new_subpool() may also reserve huge
pages for min_size.

If root dentry creation fails after the subpool is created, the failure
path frees the subpool with kfree().  This bypasses hugepage_put_subpool()
and can leave min_size reservations charged.

Use hugepage_put_subpool() on the failure path, matching the normal
put_super path.

Link: https://lore.kernel.org/20260720021900.1376309-1-chenyichong@uniontech.com
Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3105376741865..f663657c237f0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1382,7 +1382,8 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	if (sbinfo->spool)
+		hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
-- 
2.53.0



