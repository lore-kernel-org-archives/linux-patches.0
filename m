Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9008431E0FF;
	Mon, 18 Aug 2025 12:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521685; cv=none; b=IEiMjIbNKK4r8eM3cXE1QseMpTuzXHOu7p+XYPn8ZAtdrrsFFMH7ljJPFHZaan1oGOusHlvEDTywJ+1RDDiGZMSqNEPyGaCRT2pnguG4IY22zi7wUn5k3VwVbNEGMoGXNhwOGGPH1DWWrutB7wc7QwgKVTZCaAVyH0yBOu4x1yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521685; c=relaxed/simple;
	bh=1zSW5/PTzkcBAvrdB8cx5ySP3P4vv73ymfIz5UV6dpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwyOUnMAYz8JZ6osfligqjrZZsUb5lsuADaRh0BJWwmc93jNssw8h+S9I7+WYvivaRNU09phk0OFn9n9D3Yypsu7KKGi+Uv8YJE1z5qUSS2V3qcnitek9MzD3/KFR+lefupNAF4PdITeBfbdeRTkC6v1Kc/SgsX9kilyo8G1KZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh7mrkpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh7mrkpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864EBC4CEEB;
	Mon, 18 Aug 2025 12:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521685;
	bh=1zSW5/PTzkcBAvrdB8cx5ySP3P4vv73ymfIz5UV6dpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oh7mrkpCNzi4gLPFzBhXKERepLgsha612ysNd3CSsZ/QrSBGjV2zp/aBivTl2f2NZ
	 9GtxsJc3VRnpbiw5ub+teZAjWdSBuq1K5ucpwRNYeuyaee/IrPNFuwQWvjeSPB8lf1
	 Aauu0BlbeiArXmp86C/IbOQlpkimfQXfIfCDBDzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/444] securityfs: dont pin dentries twice, once is enough...
Date: Mon, 18 Aug 2025 14:41:59 +0200
Message-ID: <20250818124452.435490840@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



