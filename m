Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EBB39FCE;
	Mon, 14 Oct 2024 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916737; cv=none; b=pe9Nnp8FtEpton/kvQLGYn0oMiU2cThz2qAis7jwL5N79UMszNn80/JCZcGKjs7xo7G8YWswHEFfJTiEYj8IkifxkVmtTS/Q+a+J9x5nZ+G93dNsq6IQmztMhfleyEDodyCXmwujnLl4+qEMDApU68lSNVhToGXyiTATRk93OrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916737; c=relaxed/simple;
	bh=C1SYtGmCBYM5wUPdTMLJLIQS8/8DHk0rzwbYbL25E2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FP2v+r1yYksoWIGNdxOlQmBBPuYAuKPzBN8jx5Sp5FjsTBWB0+iBPmpdh7uucCcYFxNP+4aXLadC8Xlzwb8skH+J8vTKzu3g5vIU0G/93TtosHuEdegpnuOHSRoX5YD6iHYmfUD7/5fmhaKcR+dLsfR0YaYyKs8PJyv/M3N9fiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+9wQGUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+9wQGUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB4BC4CEC3;
	Mon, 14 Oct 2024 14:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916737;
	bh=C1SYtGmCBYM5wUPdTMLJLIQS8/8DHk0rzwbYbL25E2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+9wQGUvlDv4u6woBflMgwkidGR0gJXTOhHQmWNnTvqnZCYu7ifIHEQko6vvk3mu5
	 LTv6zSr0TBGC13YLCB5xbnx/c2i5PmOO2xyCcLZTsOEL8VwtSRhIHZkQpQc4KftgAZ
	 6Pvcjpk2r1B7PIB3Vt/HgB/3LHcAJN3w1D10n3lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f71f79bbfb4427b00e1@syzkaller.appspotmail.com,
	Diogo Jahchan Koike <djahchankoike@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/213] ntfs3: Change to non-blocking allocation in ntfs_d_hash
Date: Mon, 14 Oct 2024 16:19:18 +0200
Message-ID: <20241014141045.023160798@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Jahchan Koike <djahchankoike@gmail.com>

[ Upstream commit 589996bf8c459deb5bbc9747d8f1c51658608103 ]

d_hash is done while under "rcu-walk" and should not sleep.
__get_name() allocates using GFP_KERNEL, having the possibility
to sleep when under memory pressure. Change the allocation to
GFP_NOWAIT.

Reported-by: syzbot+7f71f79bbfb4427b00e1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f71f79bbfb4427b00e1
Fixes: d392e85fd1e8 ("fs/ntfs3: Fix the format of the "nocase" mount option")
Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index b5687d74b4495..bcdc1ec90a96a 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -501,7 +501,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = __getname();
+	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -523,7 +523,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	__putname(uni);
+	kmem_cache_free(names_cachep, uni);
 	return err;
 }
 
-- 
2.43.0



