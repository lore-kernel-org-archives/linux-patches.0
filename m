Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46BD34F489;
	Wed,  3 Dec 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777907; cv=none; b=d3XQTJ3UA0cLSzn5tzH2fh/LLFnrdSKpzj8BDb2sEyM5FSv7wenr1Zdaaa3HOb6ese4lR/dgjjOS+irwOEqPTp3xX/JXkRZWQ/dEGGH7UqJhG6H3e48ejECLc0jjY26rEqYxNYPTRtkAWWXhumoKrqnuN3YzBkHYTq9rYMpm5hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777907; c=relaxed/simple;
	bh=8yN1dEloPiX2awuDjA0r/zVpsENF4MzM2UhwFn2ObpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNOV+wg4ttONAehKogLjYKRJPqVQC9LnaFUm1D16nUueQejbl/nywKGMpwJ2bX6W3YT5y6eo9MG4OQsfvWCfkU6be4hRGPaUA0Bv2UMF3adaZsnlWFD/fGazScRQQrf076G9/yBZA3sp9OB+XvAZdx5LTllLvzXZYNO6vGvaxa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSDF7QWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSDF7QWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46797C4CEF5;
	Wed,  3 Dec 2025 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777907;
	bh=8yN1dEloPiX2awuDjA0r/zVpsENF4MzM2UhwFn2ObpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSDF7QWOJCWTaKty4PqCneb/k/qS+eH3pDrpIcrtVqbCcTM/9IU5UOknx2KDv8pVK
	 SnJfQXfb7d7+3msuz6cS3fR65cZghm8dk1WRG07KoeiAFAtPkQPK9jdIWpUY5aE9mC
	 o0G69RHkIz5dcfBdXV9TsE5ME9tgvM5j18BcreVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Stanislav Fort of Aisle Research <stanislav.fort@aisle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/392] orangefs: fix xattr related buffer overflow...
Date: Wed,  3 Dec 2025 16:25:35 +0100
Message-ID: <20251203152420.887969528@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 025e880759c279ec64d0f754fe65bf45961da864 ]

Willy Tarreau <w@1wt.eu> forwarded me a message from
Disclosure <disclosure@aisle.com> with the following
warning:

> The helper `xattr_key()` uses the pointer variable in the loop condition
> rather than dereferencing it. As `key` is incremented, it remains non-NULL
> (until it runs into unmapped memory), so the loop does not terminate on
> valid C strings and will walk memory indefinitely, consuming CPU or hanging
> the thread.

I easily reproduced this with setfattr and getfattr, causing a kernel
oops, hung user processes and corrupted orangefs files. Disclosure
sent along a diff (not a patch) with a suggested fix, which I based
this patch on.

After xattr_key started working right, xfstest generic/069 exposed an
xattr related memory leak that lead to OOM. xattr_key returns
a hashed key.  When adding xattrs to the orangefs xattr cache, orangefs
used hash_add, a kernel hashing macro. hash_add also hashes the key using
hash_log which resulted in additions to the xattr cache going to the wrong
hash bucket. generic/069 tortures a single file and orangefs does a
getattr for the xattr "security.capability" every time. Orangefs
negative caches on xattrs which includes a kmalloc. Since adds to the
xattr cache were going to the wrong bucket, every getattr for
"security.capability" resulted in another kmalloc, none of which were
ever freed.

I changed the two uses of hash_add to hlist_add_head instead
and the memory leak ceased and generic/069 quit throwing furniture.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: Stanislav Fort of Aisle Research <stanislav.fort@aisle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/xattr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/orangefs/xattr.c b/fs/orangefs/xattr.c
index 9a5b757fbd2f6..2d2d16caf9190 100644
--- a/fs/orangefs/xattr.c
+++ b/fs/orangefs/xattr.c
@@ -54,7 +54,9 @@ static inline int convert_to_internal_xattr_flags(int setxattr_flags)
 static unsigned int xattr_key(const char *key)
 {
 	unsigned int i = 0;
-	while (key)
+	if (!key)
+		return 0;
+	while (*key)
 		i += *key++;
 	return i % 16;
 }
@@ -175,8 +177,8 @@ ssize_t orangefs_inode_getxattr(struct inode *inode, const char *name,
 				cx->length = -1;
 				cx->timeout = jiffies +
 				    orangefs_getattr_timeout_msecs*HZ/1000;
-				hash_add(orangefs_inode->xattr_cache, &cx->node,
-				    xattr_key(cx->key));
+				hlist_add_head( &cx->node,
+                                   &orangefs_inode->xattr_cache[xattr_key(cx->key)]);
 			}
 		}
 		goto out_release_op;
@@ -229,8 +231,8 @@ ssize_t orangefs_inode_getxattr(struct inode *inode, const char *name,
 			memcpy(cx->val, buffer, length);
 			cx->length = length;
 			cx->timeout = jiffies + HZ;
-			hash_add(orangefs_inode->xattr_cache, &cx->node,
-			    xattr_key(cx->key));
+			hlist_add_head(&cx->node,
+				&orangefs_inode->xattr_cache[xattr_key(cx->key)]);
 		}
 	}
 
-- 
2.51.0



