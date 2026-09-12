Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A26533C18B;
	Sat, 12 Sep 2026 15:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226875; cv=none; b=UbO4UPzcuRkoXpd3+mv2oqrx5+fHa0/hoMWrvUeCU05hPKN31zdyY1LWQlK0iXb0pZKyRXk2OleoCjgVXlqLvhS0bKXq0EEyx0hF6sJyCR9GPAKbGQsF01he+NooPKaWtTcnsSPb5c/QzryKxiJW9ha88Ox8e0JAUvWp4CoFSus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226875; c=relaxed/simple;
	bh=GaALZ17bUDGzpz4xTbzR8n5p4GvMzrhNFsIBRLcKUS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nsk+irLvGTrGtDSuQQmSIVbZmvK/c1EMnzl1TaGYhPVXXR/b5p/gHiVPfeATvSUU4M3Si8wSUVQ21Urdz61urrESr9tJWALI2QraHoeQpRrmrHaHhjIg/MDKpHX87jUs2ZgPv4EqSozd2lTLR7Ns/a84hFHlPECxzPJnBmIKalg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/85v9RG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/85v9RG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C7A1F000FF;
	Sat, 12 Sep 2026 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226873;
	bh=kVRs5Dkta0qGYOFgEHltRbb34579GaZlSndcdquUPOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/85v9RGJDLgOgElF8YWpXwbucNmDAhIzWLkI9taAfOoYiIHJU+r25bVbWiqBdi6R
	 3KpxZlTWM7tAOARQZQ+iUvKYeGBIY7X/MiCOLDha735yM3VMSP0u9v1tp3VMYLJPvt
	 06JJ0MnbKJOHBMRc49OpLniFgKR1jucX5Xd0mSc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 0067/1191] smb: client: clear ce->tgthint in free_tgts()
Date: Sat, 12 Sep 2026 08:46:35 +0200
Message-ID: <20260912065549.665162529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -234,6 +234,8 @@ static inline void free_tgts(struct cach
 		kfree(t->name);
 		kfree(t);
 	}
+
+	WRITE_ONCE(ce->tgthint, NULL);
 }
 
 static inline void flush_cache_ent(struct cache_entry *ce)


