Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0834F47D;
	Tue, 26 Aug 2025 13:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214239; cv=none; b=bZ33IWx2Nl2MdvYrjY16E94JRQTwY/rR40Tn64KOO8bwOKqZX0vstJ/QnovfFWvD5sZT1o0NXR3q+Le00K2IU57NyHdd5UvcV24IwjpLDaIMbhPln8a0vGFtqcYcUUnPFwghjXMZYAHnb9saNFukBak37vYUJT6VatMktmoEY74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214239; c=relaxed/simple;
	bh=nVQXDkWOz30hKzjzuYNy/LFzrjTaFLxche09M6zDK0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlLX9OwIStcgH8q1tHuvxC+FCh5X5Gte1El2bbmNMriOQRRoK5Ap4U5yhNYWsZJe/LtMjkLf+OU4QisQD1ddyxaTAyoK8N3AIZ0vQtuS3Da1AM7obYTj6iVavOCh+TU7D0pGYbc6gvSBxPV/g6RkTL0blvzyhWHPxbf/4OOZFCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B98nfNin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B98nfNin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53696C4CEF1;
	Tue, 26 Aug 2025 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214239;
	bh=nVQXDkWOz30hKzjzuYNy/LFzrjTaFLxche09M6zDK0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B98nfNinSyJIrDyYwQvtJ9UqDH0tXlNLHgIfFWnWoDN1mhAzHFR6T30kUPUU2Gy/K
	 mn+/67QEM1d7uzLDXqAxdwoyDiYdoydklyVXdrJOHZ/RBuXon2qpeIJVLx/dv6vei5
	 Aex4tQ+rbz5T9t8AEdwxU3tcAVKyriNjrMBcAd+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/482] securityfs: dont pin dentries twice, once is enough...
Date: Tue, 26 Aug 2025 13:05:17 +0200
Message-ID: <20250826110932.407795951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



