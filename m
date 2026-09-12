Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E27343893;
	Sat, 12 Sep 2026 13:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219973; cv=none; b=HdRMqHQcq8QfIgkoNXW8iy0I5kzEbJr6SA4Hlma43lcEKJJSl+Ml5FnTm7PX4e48h6fkSJTEHEjQdaVWPlBb50qMyyn0elhQO5XUVy9ozW3wl//rGsP/RxdDuGNBFeW3oGEKYu3wJGg7kVdZw/5Ock6g3nVcpHZh+ZsSQ2bNsV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219973; c=relaxed/simple;
	bh=fdQ4bg0xanjSrp3bIgA7DSh5Bll8z2BjtzL3caKz7hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXQ4OchqAdwHd4WHopS3jvENAj2n9vxYRR1TsfAaU2YyMRjtBFi7Z2SV1FGO0dTfrqeCUjMp4EPw9Xc5ilzsUxv35qzxEq98cCxA6SOYVu+NhK+AiR3Oblm0KcoK6LFbjORGHQ9TQ/nDSX2pJXa80Mv37UP38jmGe65SPMT6XvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrORkJuP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrORkJuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A653A1F000FF;
	Sat, 12 Sep 2026 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219972;
	bh=A9YiUxdcPuWyaWQyXz+5EWIqL7ok9xta2kyFIFB7hgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrORkJuPKvO1MHE/9q4dsrk+GqcME1ToWYjHw7TE80Ws0rXpahKixJvEslHTjcMV4
	 hAx8Sk4cquOL1nCiuHGzUSMbvFo5hD2BZWbQeprEJt241W6gXXWVgWinJlUDKTkFpD
	 pe9hYQk0F4VBm6GXQKB6lac3arA5RkH/lFipwuRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0083/1424] smb: client: harden DFS cache against invalid target hints
Date: Sat, 12 Sep 2026 08:41:55 +0200
Message-ID: <20260912065609.166604810@linuxfoundation.org>
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

commit bf86c08123c6ab8c61cc0be1dad7540db93738ff upstream.

Currently, get_tgt_name() returns ERR_PTR(-ENOENT) when ce->tgthint is
NULL, and dfs_cache_noreq_update_tgthint() assumes ce->tgthint is always
valid.

In preparation for clearing ce->tgthint in free_tgts(), harden callers
of get_tgt_name() against ERR_PTR results and harden
dfs_cache_noreq_update_tgthint() against NULL pointer dereferences.

Cc: stable@vger.kernel.org
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs_cache.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -873,13 +873,22 @@ int dfs_cache_find(const unsigned int xi
 		goto out_free_path;
 	}
 
-	if (ref)
-		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
-	else
+	if (ref) {
+		char *target = get_tgt_name(ce);
+
+		if (IS_ERR(target)) {
+			rc = PTR_ERR(target);
+			goto out_unlock;
+		}
+		rc = setup_referral(path, ce, ref, target);
+	} else {
 		rc = 0;
+	}
+
 	if (!rc && tgt_list)
 		rc = get_targets(ce, tgt_list);
 
+out_unlock:
 	up_read(&htable_rw_lock);
 
 out_free_path:
@@ -919,10 +928,17 @@ int dfs_cache_noreq_find(const char *pat
 		goto out_unlock;
 	}
 
-	if (ref)
-		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
-	else
+	if (ref) {
+		char *target = get_tgt_name(ce);
+
+		if (IS_ERR(target)) {
+			rc = PTR_ERR(target);
+			goto out_unlock;
+		}
+		rc = setup_referral(path, ce, ref, target);
+	} else {
 		rc = 0;
+	}
 	if (!rc && tgt_list)
 		rc = get_targets(ce, tgt_list);
 
@@ -963,7 +979,8 @@ void dfs_cache_noreq_update_tgthint(cons
 
 	t = READ_ONCE(ce->tgthint);
 
-	if (unlikely(!strcasecmp(it->it_name, t->name)))
+	/* Check 't' in case ce->tgthint was cleared by free_tgts() */
+	if (t && unlikely(!strcasecmp(it->it_name, t->name)))
 		goto out_unlock;
 
 	list_for_each_entry(t, &ce->tlist, list) {


