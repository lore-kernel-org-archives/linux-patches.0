Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90F6CA6F;
	Sat, 12 Sep 2026 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211533; cv=none; b=JwodLGkjLLITAK2ipa2M5mvOveFK5UUqDycp/O8wg4WI8XI/gq+NHu422h7RfZqopVHX2UWYgDewD2sGXhk/fYiiL422jtvXHvyY8tVTj7HTI6hOY1QWHjVZsvngRhdSXTEPjjO9cHvX5WMB56VJDtgy7WWJ7VY43ffkcuUl6/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211533; c=relaxed/simple;
	bh=FRRtNbKE5KMbRlvy6jICUxFrQUdPVaLSQaMvJvobqQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phkJwhI5xaNFlxu+JMpd+ql9Zr4rU2cLcagJebKNBJn5EB2Rjknp3u+ZLf5aOOSLGXfUC6daA8vVE1vNBSNuKZFd9/jux8hSkaXXUqDMsS0w4jbLBVzOWY9OxOJ0zljp8bmoE78PkJabmNU8NxJw4VsN54pRmWj3flra592gCmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0uQfQeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0uQfQeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24311F000FF;
	Sat, 12 Sep 2026 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211532;
	bh=mpligvwF0emWDllRgb4+vZ7L9JvU9l2WEDZhkgtPmOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0uQfQeKQCN7RJ2iHrWDEiBravVX/UsbBy5czmr+GNSkZor/3jNtp10PSguQYftSV
	 S1CeLyWQuFkwgZo9ArPB5OYAhg9y41LShvQ939MVFiOmBguCsyPb3STdSSJjXoQjDC
	 Jvvjnb7vPhVoQdk1pi39e0bAyUoXfTFnq3UMeSG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhansong Gao <zhsgao@hotmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1251/1518] NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()
Date: Sat, 12 Sep 2026 08:57:00 +0200
Message-ID: <20260912065651.809345170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 66b8da741a06f..84ba899bf0a74 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7862,6 +7862,7 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lease **lease,
 {
 	struct inode *inode = file_inode(file);
 	fmode_t type = arg == F_RDLCK ? FMODE_READ : FMODE_WRITE;
+	fl_owner_t owner = (*lease)->c.flc_owner;
 	int ret;
 
 	/* No delegation, no lease */
@@ -7871,7 +7872,8 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lease **lease,
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



