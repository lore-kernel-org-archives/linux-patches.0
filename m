Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44381335BCF;
	Mon, 18 Aug 2025 13:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523237; cv=none; b=hbGQwek6YtEYs5I3XMBh0Hv4buRzaLOrzuhlMxqa+FU6KdsNA4zPCIiSQi6jEKxO+CBVm/hrJCTtiDGIP0YLcaulAAR7PDdpwQDkid2H/Rw39pVGuuFzNLUGiA3TiRviZoluOOcSdMjs1N693OqPvzz+1CiN1msynL+2rpEWF6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523237; c=relaxed/simple;
	bh=8efvjH2oFPIuLGvAZooN2BlDZ/vzup5vw0rhH0AC9T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beGq1M3KP9lXD90GBz/J7L33jABPYl6NkIt+GX2MC484+VOPK3NvsIIW5GoPFZE3S5ZTFopVPbwGMktUsvYaXj+mss3VUGtusiV8wgbR/c5qb1XRzYitKKfKQEJMngxVkgAG3Grxx/n70g0sGwixWlctYdK9+iHSBLk2bZZe9pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtmYrhTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtmYrhTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC1DC4CEEB;
	Mon, 18 Aug 2025 13:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523237;
	bh=8efvjH2oFPIuLGvAZooN2BlDZ/vzup5vw0rhH0AC9T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtmYrhTBwzfA9dd+I/W2H7h9iDGykPi2Qr5Rk0ZCcPN2qNf3q/vtJItx09+xI8sth
	 CoEDnR7VSb/UQk0a6Ysh7XJt5vtpV5O1tpOgMzgwzbaHVWVUJl3imX0KKlbobHcw8s
	 qNomUBxjR3dY0f6b1ofLmhN50OJVLR+2b1H7B35g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 110/515] securityfs: dont pin dentries twice, once is enough...
Date: Mon, 18 Aug 2025 14:41:36 +0200
Message-ID: <20250818124502.592765102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index da3ab44c8e57..58cc60c50498 100644
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



