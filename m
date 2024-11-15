Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECCEAD0;
	Fri, 15 Nov 2024 06:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653391; cv=none; b=AmAvVEQkvIWrjblvSWbKWsS7TJyXsaUIUYUnMxbESYgdv3+Mt4TMPaHRBGE8ppb9aDFfqMnMPryi859LxvydAKgnJBE/12vhVpQCzd3H0pXdNM70iVoIb5Ohwm2f3OVBWUCPbVQ0HtLPXmDkxD1MJ7FCeUy3sTPgvmiVYXszXXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653391; c=relaxed/simple;
	bh=tg7M1z0n0SjBAQ7ne7adLKsKHuOytXJzvYnX9I0poTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4n0iEviLNRjR3bRDuuC6PW0+LUjAyb1rUtkFeZVNKMOC2LKcFuewMdRkj2SAFhevVEUaqUdh8Ykmu/dK9+iauC49n6SChzSQV1sgajPNwj4sxDPlO1vXj2AXNXQLhml85JDLP77WPtc9JOXFgA+DZ8Am1d70dY4BybO/r97Gl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjtfxKOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjtfxKOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F04C4CED0;
	Fri, 15 Nov 2024 06:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653390;
	bh=tg7M1z0n0SjBAQ7ne7adLKsKHuOytXJzvYnX9I0poTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjtfxKOtnU2At+UPMx/jH7kJHgsTLs7uny4WPtUJ4OEY+Sqjk3SiFDDDo43o0Tu9i
	 8XQxD+wEiNvGzmNX/dgdoMcELGmQNvoWXueL3iiEg9mKJvEjCuImt7KFXVcmCloT6Q
	 tceAljyJ3G2ldudjAt/+rqFVIh7QmXN8WfOWTnx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/48] 9p: v9fs_fid_find: also lookup by inode if not found dentry
Date: Fri, 15 Nov 2024 07:37:50 +0100
Message-ID: <20241115063723.017096136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 38d222b3163f7b7d737e5d999ffc890a12870e36 ]

It's possible for v9fs_fid_find "find by dentry" branch to not turn up
anything despite having an entry set (because e.g. uid doesn't match),
in which case the calling code will generally make an extra lookup
to the server.

In this case we might have had better luck looking by inode, so fall
back to look up by inode if we have one and the lookup by dentry failed.

Message-Id: <20240523210024.1214386-1-asmadeus@codewreck.org>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/fid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index de009a33e0e26..f84412290a30c 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -131,10 +131,9 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 			}
 		}
 		spin_unlock(&dentry->d_lock);
-	} else {
-		if (dentry->d_inode)
-			ret = v9fs_fid_find_inode(dentry->d_inode, false, uid, any);
 	}
+	if (!ret && dentry->d_inode)
+		ret = v9fs_fid_find_inode(dentry->d_inode, false, uid, any);
 
 	return ret;
 }
-- 
2.43.0



