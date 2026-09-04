Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D5A2F9DA1;
	Fri,  4 Sep 2026 06:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502195; cv=none; b=VX68PNwE06duOhoW5AwThW4NSfVrPgZ3VD5+Tv1JxdurXimjpQBxvS5sN1Ho5Wzp1gaqs4uevpD9mLAZr0DSgd+nKFZXUPJNH4i1gP6H6IjxBM2+8LZCkJ4xkjfWVX3jaSZgwz/KXe9z3AEUzI2rs6i2xBpMxNjTrZ1a+gLiuzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502195; c=relaxed/simple;
	bh=qYykGiizZXaTvCU0ZnesckoQUaDylaGO9Hugm7cOiaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJREMB/ywizquehRWAzzmKTIpehElX0ZObci1XuZVRDXidHTP4nQdjN6FxXDYQxxma5arcvSZat0gTNKRnjMXvwa+fTXZ0Ia6kIcGPZxCZsldLhfQekMvIvnyMkVIU/Kd07U4w0pR/paktDXxJie054mq9RycrHLGj3QEiG/kCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSBem89j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSBem89j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31351F00A3D;
	Fri,  4 Sep 2026 06:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502194;
	bh=zcm2oqJQZXGTJeFvOoDCm4zZxKFt1OeDepvK01XtwKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSBem89jevt1X1eOf6YcnR5+VA1KnwDVkY9YExWe1NfJEc6YoGQNokv1BlWtsnnGV
	 OhMnio68qn5l9WkV8HnTCSKPBDy7cEqcMlrVrxAI2m1ATcbQ7IG2hDkxh/wi3Tr2lc
	 +whKaZZZcICleCpRf3pdQ+ZeqPYDEF0hBoxTHtUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 121/403] smb: client: clear ce->tgthint in free_tgts()
Date: Fri,  4 Sep 2026 06:58:44 +0200
Message-ID: <20260904045737.587250924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


