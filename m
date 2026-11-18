Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037350;
	b=rY/BSeO8V9I9BG05aRvVWdHN6orD+w8Qwpvo3+cVt4TVBBM7mcZ5uDRix4U38Ldros2l
	 jQJNI21enT92fwEbRqWqd9CqlEpyYMEwizXnR53KeQ5ciQI8mrKz29WOsYeQ+wd+Olobd
	 hLOLXQ+2sVuCBICJkdSHfwLLC4ln9J53/nFmNkD6Azli7mnna9CI1zApQCyiPej3NO9I2
	 ySx85vcvujicR1MnRZQjnD6GBwTEoqwlx1m/nkw7kzNqo2o3F6eYIEmQPbRG1SoqpmaBu
	 /XaNNmUBAgdWnQ6W+DIKQRFE0bA0HBW1WAX5fk9N+fBIeYHUyM6OEQJsRKDZM0MAEHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7U4PP0xvhFXt+7VbybCnp9uTvudQeeul1Ri00SwppKo=;
	b=oRn5P6hbGDQBIuSVgt7jJ3bgWkXNbcHmeq0lsoVKWbal2JXZNlqJol9/j/tjbccleDqU
	 uiGxEBq6DvnJDtYw6RcztyLSyDB0rM0V93SHoJZGm9outX7qsnblDUCcXWVe5mQZx1o5U
	 H5IQvZIwL2e4z+BX2edmvOnsB1WbMoO13N/xM3+J5QivOzuRoD6GRZq7eRUq/F2g3e3QO
	 kPSkWX7j4AWRvtcNJ74azWYs4OUy69zRS4hjCHoemATTtnselJqV5mvujhJRJburgXaB1
	 GL0w+IT4EzyxUmHrBq5hU/pxSjdRNI4gaAcCHDrp5I8zVpwdWRNk5ZENbemCVWxf/kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsU9pyfK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4522E60A2624;
	Wed, 18 Nov 2026 21:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsU9pyfK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834AE1F000C4;
	Wed, 18 Nov 2026 21:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037350;
	bh=7U4PP0xvhFXt+7VbybCnp9uTvudQeeul1Ri00SwppKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsU9pyfKMcvmYIF8vEipJPHHDQNCqqx3PLkM5PmLVLK4tlWIXepNXwdnSxI8uBIe6
	 n3z2HFbCmM6bimT/ejCmzZsoM+n+kEgJ5hvZB7QkS/866Ut2CHsAzuERPVA5NcrQPo
	 3Cgd88bVqB8paXh1eYdoKgZ6BWoFaltEGkPdY9+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1372/3318] nfsd: fix NULL dereference in nfsd4_free_layout_stateid()
Date: Wed, 18 Nov 2026 15:33:14 +0100
Message-ID: <20261118150401.667366637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

Commit d12af460df27 ("nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on
racing delegation revoke") replaced BUG_ON(!ls->ls_file) with a bail-out
that calls nfs4_put_stid() on the partially initialized layout stateid.

nfs4_alloc_stid() leaves sc_count at 1 and nothing takes another
reference before that bail-out, so the put runs sc_free, which is
nfsd4_free_layout_stateid().  That function uses ls->ls_file
unconditionally, both for vfs_setlease() and for nfsd_file_put(), and
nfsd_file_put() does not accept NULL either.  The new error path thus
turns the race it was meant to handle gracefully into a NULL pointer
dereference.  The nfsd4_layout_setlease() failure path that already
called nfs4_put_stid() was safe only because the BUG_ON guaranteed
ls_file was non-NULL.

Upstream does not have this problem because its destructor goes through
nfsd4_close_layout(), which tests the pointer before using it.  That
helper came in with the admin-revoke series, which is not in 6.6, so
just add the NULL test here.

Fixes: d12af460df27 ("nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 821e7ab13211d..bf0334713b234 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -169,9 +169,13 @@ nfsd4_free_layout_stateid(struct nfs4_stid *stid)
 	list_del_init(&ls->ls_perfile);
 	spin_unlock(&fp->fi_lock);
 
-	if (!nfsd4_layout_ops[ls->ls_layout_type]->disable_recalls)
-		vfs_setlease(ls->ls_file->nf_file, F_UNLCK, NULL, (void **)&ls);
-	nfsd_file_put(ls->ls_file);
+	/* ls_file is NULL if nfsd4_alloc_layout_stateid() bailed out early */
+	if (ls->ls_file) {
+		if (!nfsd4_layout_ops[ls->ls_layout_type]->disable_recalls)
+			vfs_setlease(ls->ls_file->nf_file, F_UNLCK, NULL,
+				     (void **)&ls);
+		nfsd_file_put(ls->ls_file);
+	}
 
 	if (ls->ls_recalled)
 		atomic_dec(&ls->ls_stid.sc_file->fi_lo_recalls);
-- 
2.53.0



