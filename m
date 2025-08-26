Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74713223335;
	Tue, 26 Aug 2025 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218910; cv=none; b=paRKKTRKW6izA8kOAeXqcsB92qiVKHjxC7cQP4nXavJeh/MzqWVypaURzzj793IA01LRmZHCGZuDmAMt7hiPD7zFxA8yVY3H6OTw3w1o3Qb8SLTzJJ045gpTVbvkfhozcnvSL9ONyXkJSQ1I4eCkMlkLsliyFDZVfy5nmSj1q4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218910; c=relaxed/simple;
	bh=s5R7S5bXGaL+optILVcI8iFoC5QDd4BIh73cEXKO8io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sifDeL4nGz9X4alaQ1kLiF6GHVFVCKj/lXgfT0GcWLrOBRe4xu6r2sfIcXZaGg7dv3PZR418+ZI+M3J3NPhxaK7Acdgp8tv6SBNmErqNHsBhCHkRYkyHGWbypJtj+yTSb/w6VyKYl+R2LtKj2Qh41cSAZy2mQIuNHt8ZXQ/Swio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrAOTa0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrAOTa0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01601C4CEF1;
	Tue, 26 Aug 2025 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218910;
	bh=s5R7S5bXGaL+optILVcI8iFoC5QDd4BIh73cEXKO8io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrAOTa0N69co8rhwxf4tdH0hAvLQuXabToPwLtTUdP02+h8q085AUso3gmljucUNT
	 CtcjT2Wzmx9vIMUE2jO/ZLJHIufPW/csxKhKoucqGrih3ZwExiERYxmko/NtGCliJ/
	 oViZwazzyv27nO4W2UFgNPctS0T4sTmQqvok4jnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/403] securityfs: dont pin dentries twice, once is enough...
Date: Tue, 26 Aug 2025 13:08:25 +0200
Message-ID: <20250826110911.828556342@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 27cd1bf1240d482e4f02ca4f9812e748f3106e4f ]

incidentally, securityfs_recursive_remove() is broken without that -
it leaks dentries, since simple_recursive_removal() does not expect
anything of that sort.  It could be worked around by dput() in
remove_one() callback, but it's easier to just drop that double-get
stuff.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index 6c326939750d..e6e07787eec9 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -159,7 +159,6 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 		inode->i_fop = fops;
 	}
 	d_instantiate(dentry, inode);
-	dget(dentry);
 	inode_unlock(dir);
 	return dentry;
 
@@ -306,7 +305,6 @@ void securityfs_remove(struct dentry *dentry)
 			simple_rmdir(dir, dentry);
 		else
 			simple_unlink(dir, dentry);
-		dput(dentry);
 	}
 	inode_unlock(dir);
 	simple_release_fs(&mount, &mount_count);
-- 
2.39.5



