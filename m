Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B51A13A259;
	Tue, 18 Jun 2024 12:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714814; cv=none; b=o86YxakOl0WEWehW3ci3FZt2kfzmOfhJ4FMr2IBt8piH1UgPcBoT8IGBg3KVlKLrprtGq9geXPE9D4oBnK+CoV17GpHaparYOMvftZwwcgQRA8d5D7R/m7qMcOjyEXAOuMq1NSSJE4XYy9TR95GRv3oibXwPOZzG/qkdIBl943Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714814; c=relaxed/simple;
	bh=pRDbck6xG9bNI5TUCX0QnOBpDXxs/LNWUv9t2UNLPMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e//9LhLOukqDB544LsZ2Yq+xgaYWV7ggzOtSCIYqlF3m80FTVnxamhIaFfPT9h5WIn5NP/J1gT9k1YwJz3merWplgwGTBp9Wz/WtrsDNsQEDprYuCmj8gh7QsdRvjOtXZJe+yKaPOczRHMp6xrpGVn3XEHk2PhsoF4TPkWU/W10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndhGhy7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndhGhy7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C659DC3277B;
	Tue, 18 Jun 2024 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714814;
	bh=pRDbck6xG9bNI5TUCX0QnOBpDXxs/LNWUv9t2UNLPMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndhGhy7pmEP75eXuOGydf/vlXLt9YUpTL5Gr0eGKpnbrl+KgVjbkXojZPMognsJHd
	 3Sko/NrtKGgKQeUhW0LUV0/pri6jyjlKRQb2Svt1ES2D25ORhXxgjQvByCSkcyB+OB
	 T8tnJJjnvIxzqRSV6Swk+2yveayJv/dJCEzWSXrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/770] nfsd4: dont query change attribute in v2/v3 case
Date: Tue, 18 Jun 2024 14:29:10 +0200
Message-ID: <20240618123411.015543489@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 942b20dc245590327ee0187c15c78174cd96dd52 ]

inode_query_iversion() has side effects, and there's no point calling it
when we're not even going to use it.

We check whether we're currently processing a v4 request by checking
fh_maxsize, which is arguably a little hacky; we could add a flag to
svc_fh instead.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 5956b0317c55e..7d44e10a5f5dd 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -259,11 +259,11 @@ void fill_pre_wcc(struct svc_fh *fhp)
 {
 	struct inode    *inode;
 	struct kstat	stat;
+	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
 	__be32 err;
 
 	if (fhp->fh_pre_saved)
 		return;
-
 	inode = d_inode(fhp->fh_dentry);
 	err = fh_getattr(fhp, &stat);
 	if (err) {
@@ -272,11 +272,12 @@ void fill_pre_wcc(struct svc_fh *fhp)
 		stat.ctime = inode->i_ctime;
 		stat.size  = inode->i_size;
 	}
+	if (v4)
+		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
 
 	fhp->fh_pre_mtime = stat.mtime;
 	fhp->fh_pre_ctime = stat.ctime;
 	fhp->fh_pre_size  = stat.size;
-	fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
 	fhp->fh_pre_saved = true;
 }
 
@@ -285,6 +286,8 @@ void fill_pre_wcc(struct svc_fh *fhp)
  */
 void fill_post_wcc(struct svc_fh *fhp)
 {
+	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
+	struct inode *inode = d_inode(fhp->fh_dentry);
 	__be32 err;
 
 	if (fhp->fh_post_saved)
@@ -293,11 +296,12 @@ void fill_post_wcc(struct svc_fh *fhp)
 	err = fh_getattr(fhp, &fhp->fh_post_attr);
 	if (err) {
 		fhp->fh_post_saved = false;
-		fhp->fh_post_attr.ctime = d_inode(fhp->fh_dentry)->i_ctime;
+		fhp->fh_post_attr.ctime = inode->i_ctime;
 	} else
 		fhp->fh_post_saved = true;
-	fhp->fh_post_change = nfsd4_change_attribute(&fhp->fh_post_attr,
-						     d_inode(fhp->fh_dentry));
+	if (v4)
+		fhp->fh_post_change =
+			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
 }
 
 /*
-- 
2.43.0



