Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D495535B632;
	Fri,  4 Sep 2026 05:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500882; cv=none; b=CCqy/rKtps1Pv6X3kUGVOCM6834PzejYZbFT850G/YicjygbH5drzIAQEiAIMMqS+dDQCgybyk+nokeEySunOS3uBMGiLiTH8iroyclTutleb+Z46xM0NHgopsMIVtRTpeb6t85+Y0EvlhM0uhLM14UkPt5pcdLrPdVHicOwoQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500882; c=relaxed/simple;
	bh=rJR7xLxSIVrROr1Dox11SBcYrItsmLG0gUJQ7MI/m08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceqW9KoLfCh/vS1MXwREs9KfjkNEOg+aoM8K+Qnx6XvVh9PZNh7RStdEkrWGvemwPI8GaUE351e6rabX7Bud7Tmtn6f3NkYBEb+1LZD3ow9sMCf/YOqOl73nZknXeksrBjrUTiMDIqZ1pqcSnRty+0hjErA/xl4yhcBZ3wZtKJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YG9fFxqQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YG9fFxqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79901F00A3D;
	Fri,  4 Sep 2026 05:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500881;
	bh=dFfuNMlUkZ567TOh5HYH8BSydWxdogzNldiABBjiCe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YG9fFxqQ5uxiiw4aTnFYzvycRmoU9VC3mGuo5lstQst6xz1fBv9fBTdbKdkp93iMo
	 ZMlqWQgdp6HXlKz6OOWQHSgi5UQKYhlVBWK/U1BEj40aNuk+rO+FrE40WqKx+MdpRz
	 B60G7UnUVj3/2si6X82Zm0UrOIpjUOMPjxo1YDVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 170/552] smb: client: clear ce->tgthint in free_tgts()
Date: Fri,  4 Sep 2026 06:55:27 +0200
Message-ID: <20260904045752.878748854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


