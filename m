Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CB61A23BE;
	Tue, 26 Aug 2025 12:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212733; cv=none; b=iUCwz0YhxNPlVDnX3fDrSIlVrfYIrLrbJIPOgzVhFQ0AWUj+MGmzbSAOGJy5bQs4w+dL7EBHpKY/U4u+oxOBe/9d1rOVG1HOUmhWFCkt+uAnnbPwqslEVkmfb556DMdpAqDO3KcjsGSvzjLMCXivFNKMojGqxpDs+6JdCTBIJzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212733; c=relaxed/simple;
	bh=vAqatpia5whUNMZS7xFF2jj/dClp+ykL+pZsjOGN46M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biTVUsxGh7AoRkXnS2r/bnX/IYzHQcakhsfRqcJmXyZ7w9Gw+57t4qweaumTwQgzDpXmO2451fTBFzv1+eZkQH6KadLYwZwGa+aBZRnDiQIW/AaUFpDe7V/ocxDCDlP6LxfAMLXmRsWckNunNazdJyNppOG1cpCIuxBIypu5sMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2Ew3zuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2Ew3zuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55B7C4CEF1;
	Tue, 26 Aug 2025 12:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212733;
	bh=vAqatpia5whUNMZS7xFF2jj/dClp+ykL+pZsjOGN46M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2Ew3zuRbsLQ/W4VuGXaVL6y5P6JpSN81+E/Q9nzb4UJPS1NJGRb9sEn2r26TeTir
	 PICHsY9AaTowX0PIvz4TM4fT8qHGWOCtIF90/AP1aZCQ4Hqaeq9mvpJzEnoDGUJA39
	 3wgssJ4jaglkkDqyVkFUNYMQAQshZvKHB3FLSbvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/587] securityfs: dont pin dentries twice, once is enough...
Date: Tue, 26 Aug 2025 13:03:50 +0200
Message-ID: <20250826110954.995515513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3aa75fffa8c9..a90b043695d9 100644
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



