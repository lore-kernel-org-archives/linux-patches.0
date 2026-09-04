Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DE23F7ABD;
	Fri,  4 Sep 2026 05:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498929; cv=none; b=QCqn9sqN/Jt5FGcMaiYXpw0ph7ZDWCqV7BPDEzbKDQupPLczRZ1QAgRZkIPwuQA3g76d50LvZjj+Mx1tOk8hErEaoMp6QzP5LAzuDo92J0vr6WFVjBhAaiV/ERdqAdBEkv+X18PdYTM5Fh79sS/BS2fi6t8mKMG63QCINlf0nCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498929; c=relaxed/simple;
	bh=FoO4ZRkUJtj5YqD4VPCnhabO2qL2GcLN+LWPKS2cfJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnF9cvLO51xgP5osVwurXGR+0ZbqXYZQAK67ueoum7m0JIUmnya+lLLehKukS803J4uFDVvnqRKSnAW5oBkk+7llnHxqe4yxrK4xZIUi8hrfqji5O07ufbjqxtc3CDaDOVIiAqBwTCo/lpw+IfiTmWUGaa+n1sfEhVrfGOndal4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZAdKwAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZAdKwAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C0F1F00A3E;
	Fri,  4 Sep 2026 05:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498928;
	bh=7GMgookZEi06WzYcj5VRPZLpSQzz5g8cw6thqNs2kY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZAdKwAqy4N7FqmQ20Ko67trUhVKaD5tPO2rnv0adxIehlhkvIDQnJoWE//P1Rrzt
	 VnN5eqx3AJgDCxXu13DhEyVJp8vNojPAZ/FxlkhsIBAiCIUb8oNS8r8ZyxKv4KT7EA
	 tLfs9togWqklxq3e2lhPJ8S84I+ZCNiP046VO+KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 237/713] smb: client: clear ce->tgthint in free_tgts()
Date: Fri,  4 Sep 2026 06:53:25 +0200
Message-ID: <20260904045809.136140982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


