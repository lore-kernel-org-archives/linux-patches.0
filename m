Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3BE14F9F4;
	Fri,  6 Dec 2024 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498562; cv=none; b=YDILxG+Utx13kfIQdYDnW4Tn3KQ9EY17mqSccL5RvQ6+0g8lxByTsxRvBp/w/GDkQqgfAXFkNKfJa4LEwYevomYexFJey1VDwNO1og86yZHLYiyCPEslUf+7Y43gs0Z3F+452judfplNzqc0wuf5EfGNCg41lJxXxfrkl4fS9GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498562; c=relaxed/simple;
	bh=K4NAtxrwt8qWvAXY2JuskNRUQz/YgFg8qvkvqnSvxHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0IA7X/ZkOir9ho+gU38l2rivK+IkUj//D1Ie6E81pma2OOXH+HgglFdRSxxIu5k18lp13josTpbLoah5Ofp7SDNXkOQ12f7ih6M2soBmvLQxoTNKykc7D/1mAbd4jp+dpTep3AqCafX/1XdeQ1sEWsDDHbAyG1twZewUiA/7EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehj3ChLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehj3ChLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5ACC4CEDC;
	Fri,  6 Dec 2024 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498562;
	bh=K4NAtxrwt8qWvAXY2JuskNRUQz/YgFg8qvkvqnSvxHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehj3ChLzZIXUf+q9M9lJWmWmgfxWYrXDItSYpsELYCvOkOZeyhPp/F6dFrXszWidg
	 6xhD2idZ6C6RZm41/bAb+TufDpzzXpdKLEeaO7XWUzuoLr767QLsyu5UdF1B8MD5dj
	 y1ve01uEiRKXs+l/bVzRsDmGgZLoUhQWD+RFj260=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 590/676] smb: Initialize cfid->tcon before performing network ops
Date: Fri,  6 Dec 2024 15:36:49 +0100
Message-ID: <20241206143716.415830305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Paul Aurich <paul@darkrain42.org>

[ Upstream commit c353ee4fb119a2582d0e011f66a76a38f5cf984d ]

Avoid leaking a tcon ref when a lease break races with opening the
cached directory. Processing the leak break might take a reference to
the tcon in cached_dir_lease_break() and then fail to release the ref in
cached_dir_offload_close, since cfid->tcon is still NULL.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 004349a7ab69d..9c0ef4195b582 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -227,6 +227,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 	}
 	cfid->dentry = dentry;
+	cfid->tcon = tcon;
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -298,7 +299,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
-	cfid->tcon = tcon;
 	cfid->is_open = true;
 
 	spin_lock(&cfids->cfid_list_lock);
-- 
2.43.0



