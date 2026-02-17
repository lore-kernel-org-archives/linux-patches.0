Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF97329A1;
	Tue, 17 Feb 2026 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361148; cv=none; b=mpC9woHPrd7I+4k/HHG5vMPm2WEQMjzG+IiDI5uPbBLKdabbJev3haMH4hSyDiPw0Z1DAHS9sf9G1XqlLznDqvXcBw0Zx289/EnxJuEUBxL9uL8HxxDxWjk3YXhS2Jto0ZvKaBoxBSuYHLhpnUAY9eF3jf36k6ozgKf+uAZipkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361148; c=relaxed/simple;
	bh=jzzEOjLugQEt5UjY8Sb1E22eLVv0UhxjwxD9oz/kqXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbshbGC4XZQE04DGumgUCi3dJoyz5BOWMTys4SdN9PSEJ4hoYj9nGzjk7NnUqsbkr9WkPNCaZxD1YrMtVyQ9p/JKxdHCEcfZ7pEssbo+aeT0poMMvYjTovAotCZ2lZu8mBsaMsodAbo8m7OnZqfXuTAXfl9xtOlxikChrCBVaoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+gKILhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+gKILhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AC9C4CEF7;
	Tue, 17 Feb 2026 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361148;
	bh=jzzEOjLugQEt5UjY8Sb1E22eLVv0UhxjwxD9oz/kqXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+gKILhxHSXCAu+DSUYahAP7P+xYekaX8zaN1UH7nP8Saf9+1UkDA7xwzR3fTWcdh
	 TbwtgIHRnN0XN4orbseXOItoajKEts0Dbxd537VcBZ6WcXj9CzhML0vbRBIyFrkpH7
	 KmTo9ljEMAwSUhNWI/P1cHEhUkshOwJyM0OaVIbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shane Nehring <snehring@iastate.edu>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 16/64] smb: client: set correct id, uid and cruid for multiuser automounts
Date: Tue, 17 Feb 2026 21:31:12 +0100
Message-ID: <20260217200008.121980471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 4508ec17357094e2075f334948393ddedbb75157 upstream.

When uid, gid and cruid are not specified, we need to dynamically
set them into the filesystem context used for automounting otherwise
they'll end up reusing the values from the parent mount.

Fixes: 9fd29a5bae6e ("cifs: use fs_context for automounts")
Reported-by: Shane Nehring <snehring@iastate.edu>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2259257
Cc: stable@vger.kernel.org # 6.2+
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ The context change is due to the commit 561f82a3a24c
  ("smb: client: rename cifs_dfs_ref.c to namespace.c") and the commit
  0a049935e47e ("smb: client: get rid of dfs naming in automount code")
  in v6.6 which are irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_dfs_ref.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/smb/client/cifs_dfs_ref.c
+++ b/fs/smb/client/cifs_dfs_ref.c
@@ -283,6 +283,21 @@ out:
 	return rc;
 }
 
+static void fs_context_set_ids(struct smb3_fs_context *ctx)
+{
+	kuid_t uid = current_fsuid();
+	kgid_t gid = current_fsgid();
+
+	if (ctx->multiuser) {
+		if (!ctx->uid_specified)
+			ctx->linux_uid = uid;
+		if (!ctx->gid_specified)
+			ctx->linux_gid = gid;
+	}
+	if (!ctx->cruid_specified)
+		ctx->cred_uid = uid;
+}
+
 /*
  * Create a vfsmount that we can automount
  */
@@ -333,6 +348,7 @@ static struct vfsmount *cifs_dfs_do_auto
 	tmp.source = full_path;
 	tmp.UNC = tmp.prepath = NULL;
 
+	fs_context_set_ids(&tmp);
 	rc = smb3_fs_context_dup(ctx, &tmp);
 	if (rc) {
 		mnt = ERR_PTR(rc);


