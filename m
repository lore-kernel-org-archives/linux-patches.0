Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3A63A4F46;
	Tue, 17 Mar 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767156; cv=none; b=SaP1aGMmS3F5Zgq2R7kxlq0aGeanV+qdCHdJW/Fxgdl1UK8zeWXjG6bh30g9vZAesGXnKgtOa2DFy7JC+KiNgf2XROhG0vGQSOTn0ClI2wPRumMcZl5zKKghgRT26UPAAF+QXm7SsOi1dVSZZdf7m+NvSxi667N8wpMI/wUqF2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767156; c=relaxed/simple;
	bh=dFdF5J0VAG0SRXeZpDuw3ITxKUdfNTWk6ahg9Xgznko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cs8YEkf22RMNFU5VjM54JzS3hf5/seGq7fGNvdFmrZPLv4u0fFe9adqVtg1Oy4KwrLaYR30IHzqpyMVtjg4s0xgKOPIp+pKmIF+Lb9w+cwSqW3OGyq+qdtAHy4YjbwSzZvUC9MxH20Ue1Y3LKfnN94GK+7HASyJQ6K+ItCZwUCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDc6c/3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDc6c/3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08611C4CEF7;
	Tue, 17 Mar 2026 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767156;
	bh=dFdF5J0VAG0SRXeZpDuw3ITxKUdfNTWk6ahg9Xgznko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDc6c/3Yt9FJPrFQgU1BBDRHLUOyEfAMkDwF/3qmUCHG12eZByPRLBjgecMPy1Vbp
	 XfR1wvgG2uwH7/m8l2gvuIUI6OijJQp/+gSz/oReww/38xlznTSNjnXlf4XHg//x+9
	 ATBfBcCogfcIwMrA9VBns6typBXViXKlg5eC/zNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/333] nfs: return EISDIR on nfs3_proc_create if d_alias is a dir
Date: Tue, 17 Mar 2026 17:30:55 +0100
Message-ID: <20260317163000.331738366@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

[ Upstream commit 410666a298c34ebd57256fde6b24c96bd23059a2 ]

If we found an alias through nfs3_do_create/nfs_add_or_obtain
/d_splice_alias which happens to be a dir dentry, we don't return
any error, and simply forget about this alias, but the original
dentry we were adding and passed as parameter remains negative.

This later causes an oops on nfs_atomic_open_v23/finish_open since we
supply a negative dentry to do_dentry_open.

This has been observed running lustre-racer, where dirs and files are
created/removed concurrently with the same name and O_EXCL is not
used to open files (frequent file redirection).

While d_splice_alias typically returns a directory alias or NULL, we
explicitly check d_is_dir() to ensure that we don't attempt to perform
file operations (like finish_open) on a directory inode, which triggers
the observed oops.

Fixes: 7c6c5249f061 ("NFS: add atomic_open for NFSv3 to handle O_TRUNC correctly.")
Reviewed-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs3proc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index a4cb67573aa7c..993f62636a772 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -392,8 +392,13 @@ nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	if (status != 0)
 		goto out_release_acls;
 
-	if (d_alias)
+	if (d_alias) {
+		if (d_is_dir(d_alias)) {
+			status = -EISDIR;
+			goto out_dput;
+		}
 		dentry = d_alias;
+	}
 
 	/* When we created the file with exclusive semantics, make
 	 * sure we set the attributes afterwards. */
-- 
2.51.0



