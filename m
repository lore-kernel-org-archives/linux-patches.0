Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F46238F658;
	Sat, 17 Oct 2026 17:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259974; cv=none; b=Bj172ouOa8l6Xohad+X7Q6uvLpH+76BN6mDkzsiX27skSVyizte381tiUyJnzP1uYG2IuR66u4I3A5DTaNfcf7MMgUbyXgUGBGu/tbwQBPDuyqkeg0fqmiisur6991D/Z0RosPAUSJLnOGQxkk67iJFl+ERA2a5mJOUyU91Vji4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259974; c=relaxed/simple;
	bh=t45L965FnF9Q0XqHSOMVnRFiFHVA9wYr/R/S1bmHAC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpH2yJHswiJg/KWfW2To+jOPez1Q5Nr4vTciQpa0PJRZhONk/1mPKqrqXZ5zu8w1YKQhn3YMsTFNCY3F7BVs2/K671B5FkzBTFtXnQYkG+voZC41Ucyka1xAVPm9eZz8sd3svPaiOnycf06kWuHM1oKGz5eiJ43QKPSTs2K3Xe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRKJGpMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRKJGpMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8B91F000C4;
	Sat, 17 Oct 2026 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259973;
	bh=hCLn/8FB8l5Pel5z3gKtUMkpDiFgB2JCraypE8UZVBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRKJGpMZdp95L0/6r22Yjl/cZuffjfY6O48EExk5NbgoAe3RRkuy/w1VYhEZAUH3M
	 OdOGh6GMswjY4VF8vsbKRjl3i0+LzHl7j6HDD7P2lCwnNdzL8BadvxfjdSN6ivmwVM
	 G6S5NCHedxM+HqsFbx6yAa3bmuhEg3b7WNvHwo9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhansong Gao <zhsgao@hotmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1391/1674] NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()
Date: Sat, 17 Oct 2026 18:01:03 +0200
Message-ID: <20261017160506.874264329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhansong Gao <zhsgao@hotmail.com>

[ Upstream commit 468e458ffde907ba19acd2102ca1fbb8f6fbede2 ]

When nfs4_add_lease() races with a delegation return, it calls
nfs4_delete_lease() to clean up. Previously, it passed priv,
which can legitimately be NULL. Passing a NULL priv eventually
leads to a NULL pointer dereference in generic_setlease().

Fixes: e93a5e9306a5 ("NFSv4: Add support for application leases underpinned by a delegation")
Signed-off-by: Zhansong Gao <zhsgao@hotmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ce3ab0a9c0ef7..b226dbe853860 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7635,6 +7635,7 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lock **lease,
 {
 	struct inode *inode = file_inode(file);
 	fmode_t type = arg == F_RDLCK ? FMODE_READ : FMODE_WRITE;
+	fl_owner_t owner = (*lease)->c.flc_owner;
 	int ret;
 
 	/* No delegation, no lease */
@@ -7644,7 +7645,8 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lock **lease,
 	if (ret || nfs4_have_delegation(inode, type))
 		return ret;
 	/* We raced with a delegation return */
-	nfs4_delete_lease(file, priv);
+	dprintk("%s: raced with a delegation return\n", __func__);
+	nfs4_delete_lease(file, &owner);
 	return -EAGAIN;
 }
 
-- 
2.53.0



