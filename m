Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CF219E82A;
	Mon, 18 Aug 2025 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524981; cv=none; b=MmK/3xKGiV6cB75u/ONu/MIS1VmzEwxMoosqfdA73PICLLnZ60J+17xw+yvbgZp1q4HqCDfD5VqqZB25UIxAfPx1b4PCoQ66Q6uq+ZOhp1JanH14fjCxl8Vpm8oKerQ/lBvNvom1XhubwKXoML/4qr/tMIDRFYbZPxpjaGi87kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524981; c=relaxed/simple;
	bh=uP0NmnB2rM9xAK9MUO0OWYSSfk/HRzn+l9rsho1FiTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PC131jvjTsYJ/g+UYfgu/je5XTycWMn6uOZSjfBdwMFA7ksWZbctxert4YapQUGYH553hnLB/Pc4pPSS9Vv5F4/eFctMCbRkOV6gjGCaewz0asqJovt6GSmNwPgMkCO74GA9HZZi6aQsHrSrDqMBtpKh6x5WHTJ/mT108nQODhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lN7zzGqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lN7zzGqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22864C4CEEB;
	Mon, 18 Aug 2025 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524981;
	bh=uP0NmnB2rM9xAK9MUO0OWYSSfk/HRzn+l9rsho1FiTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lN7zzGqgRdoup++xP+fYjy/hQ9dmVzveVkczSeYh/q7Nt5NCkS+TTsrRNgUlCQAgw
	 cZbvcsg8ntj1FonGgKk4FNIT6ttyG8UxjK+nlIHhPJ6MesOAAEP/mAnrEAMV4T/hwz
	 /NakS6X1VYn5ALTwzkrrS3uKJigGPlMwZ+urIzyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 122/570] securityfs: dont pin dentries twice, once is enough...
Date: Mon, 18 Aug 2025 14:41:49 +0200
Message-ID: <20250818124510.523979720@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 3913501621fa..93460eab8216 100644
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



