Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A8735F602;
	Sat, 12 Sep 2026 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204154; cv=none; b=gbvmlnzAPBBB3H0ayeVRRR0BtVq+OrjH/mkgj9z+WF9jxUpq74t62boRjVhTSlU+xdLrqigmDlhMY+nRbbaLKR/90ew1lrNdwAgSdprTZ2wnQAqp6hjKqX0ORmriDclqBRoJbCUQHiBUHeoT9qEaVyHjDuPrBQc2wlhdu3Kgt6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204154; c=relaxed/simple;
	bh=ufsNMLLQu0aK5KV+Yw8eYMYmuNfbZGRKbUkT3De7gbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2WCIQikgNuo/RnCFZN8LP16RaC21GsUWbzgDRJiQxVoJU5MJlOe7VwhjgEkS+mUZFmFsCD7KKSGqZRTvryyuOPImnjUVUbAQ8TsmAAaTG4HAdItnsxDiARNN5KqFRnLUiFKpk4rf44IpXV+q3DTaQeVNyynJxghaPJyz6FkIkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fDBdZlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fDBdZlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF71C1F000FF;
	Sat, 12 Sep 2026 09:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204153;
	bh=yw0WzFQK1/rfgykXzziVsiN8Z7Qx9pBlojf0LzOGP9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fDBdZlUmWeRVvfzGZ4OuRP7aZQQZ8sRgXrC8BSdauaSb9xP9AgtV+bYk6RkQJUgL
	 31PLpniyd8FczW2OM8VsA+QDkMIJEtEhUvZwDZpG3RzgFMNLXb6Hk3HpH3gVPqHRGJ
	 MOs5fF+hTSQaXZjQ7nNkFx2vLoEdVt3J5G8V3ueo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhansong Gao <zhsgao@hotmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1552/1815] NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()
Date: Sat, 12 Sep 2026 08:55:02 +0200
Message-ID: <20260912065725.434707238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5709c6fea85bb..2edd16e4981a2 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7762,6 +7762,7 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lease **lease,
 {
 	struct inode *inode = file_inode(file);
 	fmode_t type = arg == F_RDLCK ? FMODE_READ : FMODE_WRITE;
+	fl_owner_t owner = (*lease)->c.flc_owner;
 	int ret;
 
 	/* No delegation, no lease */
@@ -7771,7 +7772,8 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lease **lease,
 	if (ret || nfs4_have_delegation(inode, type, 0))
 		return ret;
 	/* We raced with a delegation return */
-	nfs4_delete_lease(file, priv);
+	dprintk("%s: raced with a delegation return\n", __func__);
+	nfs4_delete_lease(file, &owner);
 	return -EAGAIN;
 }
 
-- 
2.53.0



