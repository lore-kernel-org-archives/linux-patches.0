Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C6415F0E;
	Tue, 21 Jul 2026 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660620; cv=none; b=kSCjNJkax1TbqMFcIsWGUPvjy6JT2FUbihUwmp5/Zw3+Sj13S3mBg5lyya0inhT3tN4RT/1ohSJFNaga0mNqXZNSQOhlBTSW0kNVbje72Dm7HfRSWSnxVUI8MGGxrQojrpy3j24ZdJXvd3bGjDKgh6/4RJwSnKtsb6BBuwTcbUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660620; c=relaxed/simple;
	bh=WfBj6/KGbszIukYZx74yRMsP+tHw0GUejQE5gDf82q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzKpgsPv4sz0SxoSe+RmtKQrAEYrvC/lBfD0Je6L79v9P3vVjk5SLW5oCVaijZZllLBU/n9xk+fxDkCqCFbCsUbeJS12Ki5+88hoWfOXBMvB6NDTh/wU1PGQp62qWmbPdz6SdP9QM44BP1dXyP3H9G3PoP7QANSIu0ivbIm6oFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bgeC+P5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bgeC+P5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D01A1F000E9;
	Tue, 21 Jul 2026 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660618;
	bh=y4hZbCihm1ElhVJEGkWDT2XGmOiZUozPMAzZhrF00kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bgeC+P5YhmAaFLQwIw5LH+8ZB9epBA8HDFjrNxPpOIQfSXYPY7mVtYemL9WJdLAY
	 GiQanPYhKKfIzrm9bsJWx0vtKbr53+FsBrnoElpu6awjATo9AY4IlJ+s/EA+xDRBcm
	 H0QRVT9pPAYJS3A0imTNiEx3EFVQdAYWpUkuxVio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1047/2077] apparmor: Fix return in ns_mkdir_op
Date: Tue, 21 Jul 2026 17:12:00 +0200
Message-ID: <20260721152617.507845380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit b7a2b49bba4e5994a476c49d662b796818079e5e ]

Return NULL instead of passing to ERR_PTR while error is zero.
  Fixes smatch warning:
    - security/apparmor/apparmorfs.c:1846 ns_mkdir_op() warn:
      passing zero to 'ERR_PTR'

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index be924700ba6c90..95deb867a76b55 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1975,7 +1975,7 @@ static struct dentry *ns_mkdir_op(struct mnt_idmap *idmap, struct inode *dir,
 	mutex_unlock(&parent->lock);
 	aa_put_ns(parent);
 
-	return ERR_PTR(error);
+	return error ? ERR_PTR(error) : NULL;
 }
 
 static int ns_rmdir_op(struct inode *dir, struct dentry *dentry)
-- 
2.53.0



