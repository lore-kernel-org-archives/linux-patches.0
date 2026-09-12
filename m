Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051DB47ECDF;
	Sat, 12 Sep 2026 13:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219959; cv=none; b=MVSEFD+0MjdPQgQWMADtYEVCC3x5UiLZtQQh5E/kRWEUe4FAkoFX8vH54UF1L6xqvdOFdj+ToQWZS4ufH4aBYX3B8D1KasIqklPwz524Hxi9k853iv1x7R2lpfDUN5ROAIJhPd0B+GXeFrkf8KjwjLj2Wq0A+PMg8Gj0jgn5ncc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219959; c=relaxed/simple;
	bh=S1qdIFe4Um1HW68Bc3458Xr56xIeC410QGV5ebo4eE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFm4hxjumeiFjj+pLzfuOe+ez95HhTN+6TyL0koNIozOw+ogm7qIe2uFx4zaFtrVmXzDm0pbpPu1A6xiH8X7Kod1ruYsuZn7UWYD/o1EVhmo5TKNV9/UHfkbe22H8iikYo9i1TG+IRptWV5xq1Zq3I1qSe3HthEvUiIjhqMGTyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXxK3Fuk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXxK3Fuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E480F1F000FF;
	Sat, 12 Sep 2026 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219957;
	bh=eCVCrs2EWen5kONdseceGf0l8wcqzd7IkHSj2MdrhNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXxK3Fukl1MaLPEgNFv5i0ZY2laE9Cj5tVg1aR7wi+RcN7L/HSAgmw5a9kvKZLefC
	 8egKd863IJqD5x+KBwOb9jS08XRYp8krNfLcBmqlPy1p1IdwCgKW8sNAsxpsIdhltz
	 iBs9Cn4EIejwPEfoCGJsxBiIWNZjFRAE+J9GxEYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0080/1424] smb: client: clear ce->tgthint in free_tgts()
Date: Sat, 12 Sep 2026 08:41:52 +0200
Message-ID: <20260912065609.100299386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

commit b1b741cf8e7ce1b91d937e23decd3d3358748700 upstream.

When free_tgts() frees all structures in ce->tlist, ce->tgthint
is left pointing to one of the freed cache_dfs_tgt structures.

If ce->tgthint is not reset before it is used later, it results
in a use-after-free.

Set ce->tgthint to NULL in free_tgts() after the elements are
freed to reflect that no elements remain.

Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
Cc: stable@vger.kernel.org # depends on: smb: client: harden DFS cache against invalid target hints
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs_cache.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -122,6 +122,8 @@ static inline void free_tgts(struct cach
 		kfree(t->name);
 		kfree(t);
 	}
+
+	WRITE_ONCE(ce->tgthint, NULL);
 }
 
 static inline void flush_cache_ent(struct cache_entry *ce)


