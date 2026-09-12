Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92C22882AB;
	Sat, 12 Sep 2026 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231034; cv=none; b=s+ERU6LdUliGcwcPgV2FlAffBqbO+s8s7Qj32cRdyKMMWJknvoKLoxMVXOqELLaqKN6/HqPft4FOLm5mPiYJIx236a8h6MoSfY8MYKgGZkivK8haDp5UU88ooOGyJGYsGQMjKk1El9maWzuihkZy5ejsaKevtF9lcHPgar1Vsr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231034; c=relaxed/simple;
	bh=CXEhJa2Wb81w2+6TmNhdaERr6KT8ugZvraZILzmAS5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHaMlAzecKZmuuvyaII68MD/4H+KQQX/cQhynUnlWlm9IN48lgikdMwHl0aKHMNvxtllJOwlx7AgM0A3riBKYLkg1+nWo+zf/igbu50NX95GD8giVZwZ7zq68pp1lL9nbHJ65LffurxvJcKc33GE+H5YiYc4nck7LsRcSu48b0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=choXxNKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="choXxNKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40761F00893;
	Sat, 12 Sep 2026 16:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231032;
	bh=Wf38JVeOLaBHZWQTH02XZKDKDkQymYuIKzJaBMSPwTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=choXxNKlVqcFm2JRTNyTaQsH/riIVHQnCDPQt+rr5/2FT5A6+jg8VSB0X3Hplh6pQ
	 yWjDIGdMWRjA5niY5F8Y/yUXvfigg7biJZqYBEt5bYezryMDegS4hRFwr3o7WkxnMh
	 Zx0cEaWYY3xLlzd3hRQGdbs5JOsbbI4fJNAS3S44=
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
Subject: [PATCH 6.1 0914/1191] hugetlbfs: release subpool on fill_super failure
Date: Sat, 12 Sep 2026 09:00:42 +0200
Message-ID: <20260912065608.762359122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f521311e3f09..3faad73c74ab2 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1513,7 +1513,8 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
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



