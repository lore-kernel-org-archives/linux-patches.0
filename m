Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7328D34F473;
	Tue, 16 Dec 2025 12:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888472; cv=none; b=svleSfZ4MmtAXFOFQDsuuJMYn7Tsegfry7CgPxlv9CaFeulL1RDn7msoqRInPxtBJWufjFL988dz0Ew02WgAMyF5cy4Q+TCbpGyLTU211+u+wp0LD+jGAtfNTMP00iDo65kuBKpT8/ECwHU9ftfNuOO/CFhFcnFt9BGEzeuzypA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888472; c=relaxed/simple;
	bh=aSAeYIxjMKgP2wBr+sXRzwREnsNuHz+JZaogqN56PlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/6RIILZsKtT7ETVS9U/o/1dK6AsW/7gfwjqBB7n6zgi8p3wvQjzj2GGTA/dWjolvCFVMrF6jPi+pu1XhTzamahMze1BT9hAn7dWKBZixq4uqksbCiPvpfPboF6Qqdk55k7BXBhqtMoIYxDAZzfP0xDfAmoqcL5ckP5VA3YtWnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zs1IVRmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zs1IVRmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DA0C4CEF5;
	Tue, 16 Dec 2025 12:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888472;
	bh=aSAeYIxjMKgP2wBr+sXRzwREnsNuHz+JZaogqN56PlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zs1IVRmWPCz/hUbsSPJCH7qnsiXvWVaNElCjEQdlikBHXLHMujZWYSVPqbzGKfcEP
	 VxrC77PRqU3lQZ+O87/EkJY9wAsVOm+OVHdZOm16D2hBNvP4aG8DbeydGWmnPATgpn
	 iSn8uyH+ykhGYG7NxVd3yy3O4hK4Ab3AiWb1aH5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 544/614] NFS: Initialise verifiers for visible dentries in _nfs4_open_and_get_state
Date: Tue, 16 Dec 2025 12:15:11 +0100
Message-ID: <20251216111421.089967739@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 0f900f11002ff52391fc2aa4a75e59f26ed1c242 ]

Ensure that the verifiers are initialised before calling
d_splice_alias() in _nfs4_open_and_get_state().

Reported-by: Michael Stoler <michael.stoler@vastdata.com>
Fixes: cf5b4059ba71 ("NFSv4: Fix races between open and dentry revalidation")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 93c6ce04332b8..6f4e14fb7b9b8 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3174,18 +3174,6 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	if (opendata->o_res.rflags & NFS4_OPEN_RESULT_PRESERVE_UNLINKED)
 		set_bit(NFS_INO_PRESERVE_UNLINKED, &NFS_I(state->inode)->flags);
 
-	dentry = opendata->dentry;
-	if (d_really_is_negative(dentry)) {
-		struct dentry *alias;
-		d_drop(dentry);
-		alias = d_splice_alias(igrab(state->inode), dentry);
-		/* d_splice_alias() can't fail here - it's a non-directory */
-		if (alias) {
-			dput(ctx->dentry);
-			ctx->dentry = dentry = alias;
-		}
-	}
-
 	switch(opendata->o_arg.claim) {
 	default:
 		break;
@@ -3196,7 +3184,20 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 			break;
 		if (opendata->o_res.delegation.type != 0)
 			dir_verifier = nfs_save_change_attribute(dir);
-		nfs_set_verifier(dentry, dir_verifier);
+	}
+
+	dentry = opendata->dentry;
+	nfs_set_verifier(dentry, dir_verifier);
+	if (d_really_is_negative(dentry)) {
+		struct dentry *alias;
+		d_drop(dentry);
+		alias = d_splice_alias(igrab(state->inode), dentry);
+		/* d_splice_alias() can't fail here - it's a non-directory */
+		if (alias) {
+			dput(ctx->dentry);
+			nfs_set_verifier(alias, dir_verifier);
+			ctx->dentry = dentry = alias;
+		}
 	}
 
 	/* Parse layoutget results before we check for access */
-- 
2.51.0



