Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0AC3AF643;
	Mon, 23 Mar 2026 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275240; cv=none; b=kvxLiGOgYv7QnWrb9AEcLKh/L5Fpp+pg8r8EPfxYL0hL2p7nwxmTcoK4QV7JgzGezpVUzyjre3CSUk8YpQ3hYqc1LnAiKg7rAvPjcAkXXrJHTiHzgBD0JY5mIBrjlYaJ88HIvzepBHd+0cSH1myMxc6PEGUCuFPfH7qZGh6s5VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275240; c=relaxed/simple;
	bh=B94d4e+yfRBE2tWtVQWkKt2XV3FYyvWIDp6pksrLQFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcc3LnDdJvNuyv/nINEk59x0paeoZZV1DQfCNwQCjsRjeQfQtS/MlPLzvZzoAhLgOATP76fCKruel8WjQ1cSo3vVzjRJ/58zcU1/W/8QETEaQO64sKVZ/t3pqMB4tOeOYSXAwlHYUMoV6M6J2Nyt/jOPv2Jb5tUsVJT2oprvQAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y37RcH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y37RcH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F7C2BCB1;
	Mon, 23 Mar 2026 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275240;
	bh=B94d4e+yfRBE2tWtVQWkKt2XV3FYyvWIDp6pksrLQFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Y37RcH/4MrHOVmuezE5KD2HDXw7u6PzTl3rdy3MpKFf+2/8g2eb8w2rsrUyMlRU2
	 0hwqMwWufhDWM54xoiW3UKyzz/IEGSnoseSqHcGTVppnNQbr3T+T2OGqpDKeb5IOZM
	 rAmxazRgIBa0l1JQ87pRT3cw70hUF5+l6O2MSyK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/460] nfs: return EISDIR on nfs3_proc_create if d_alias is a dir
Date: Mon, 23 Mar 2026 14:40:21 +0100
Message-ID: <20260323134527.311151796@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

[ Upstream commit 410666a298c34ebd57256fde6b24c96bd23059a2 ]

If we found an alias through nfs3_do_create/nfs_add_or_obtain
/d_splice_alias which happens to be a dir dentry, we don't return
any error, and simply forget about this alias, but the original
dentry we were adding and passed as parameter remains negative.

This later causes an oops on nfs_atomic_open_v23/finish_open since we
supply a negative dentry to do_dentry_open.

This has been observed running lustre-racer, where dirs and files are
created/removed concurrently with the same name and O_EXCL is not
used to open files (frequent file redirection).

While d_splice_alias typically returns a directory alias or NULL, we
explicitly check d_is_dir() to ensure that we don't attempt to perform
file operations (like finish_open) on a directory inode, which triggers
the observed oops.

Fixes: 7c6c5249f061 ("NFS: add atomic_open for NFSv3 to handle O_TRUNC correctly.")
Reviewed-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs3proc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 88b0fb343ae04..b02ea9fc812da 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -393,8 +393,13 @@ nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	if (status != 0)
 		goto out_release_acls;
 
-	if (d_alias)
+	if (d_alias) {
+		if (d_is_dir(d_alias)) {
+			status = -EISDIR;
+			goto out_dput;
+		}
 		dentry = d_alias;
+	}
 
 	/* When we created the file with exclusive semantics, make
 	 * sure we set the attributes afterwards. */
-- 
2.51.0



