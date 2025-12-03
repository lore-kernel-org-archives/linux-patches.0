Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B25A2FFFAD;
	Wed,  3 Dec 2025 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776393; cv=none; b=CbuSnDDoPQFcsngii9ZQm0YDdKSmoxprUH3rSPN+E5WqMTBafKBZ/gXYIn2LheQc7S4SXKvN8iTKf8TclRkWk6llIN/pj0L8ebor+svXZKdzeGpIQTG0Wz3B804MrTX9ZWZ9Z9LUVufAPJGJRojqIiKpotj1Un4tSLNNSr4ybA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776393; c=relaxed/simple;
	bh=1b95N5qshDYBO9JlFVyVmVcUyAXiVUMV9mEyAXFoT3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGKC566SzkLiymWBeXtiW3E6NUmFPdeVoUUIGgu6AS6Ba+N8mYvm/tvIYADTNEz1ucLCpExGQTL9HRt241Ny1He4Ro/rd/FQzEuvlDtvsxQiZvmUG4DPdjbtRwn+HKVJ1qFgsMJDR/17+Y+urUlrehfiZh3VjU54jaMWNIjpE9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy1bW5eQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy1bW5eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103A9C4CEF5;
	Wed,  3 Dec 2025 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776393;
	bh=1b95N5qshDYBO9JlFVyVmVcUyAXiVUMV9mEyAXFoT3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qy1bW5eQVnEzFle/pOFz3+cVhwS2bXVm1ckNB7LMzjLU+eJTxl9Y7613znANOiUfZ
	 3S13hwEXNJb8w8F4+pC3G62c5LTAV8Li08jPS4gTt9nbUxksxDsgJGJoY8pAWllBo6
	 PWkWlNACzps4eHgQFMX1fgit/XZZDKUXoHA3pToM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/300] nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing
Date: Wed,  3 Dec 2025 16:25:40 +0100
Message-ID: <20251203152405.652563232@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit a890a2e339b929dbd843328f9a92a1625404fe63 ]

Theoretically it's an oopsable race, but I don't believe one can manage
to hit it on real hardware; might become doable on a KVM, but it still
won't be easy to attack.

Anyway, it's easy to deal with - since xdr_encode_hyper() is just a call of
put_unaligned_be64(), we can put that under ->d_lock and be done with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c454fb042ab2b..12f5c240a2689 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -365,7 +365,9 @@ static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dent
 	*p++ = htonl(attrs);                           /* bitmap */
 	*p++ = htonl(12);             /* attribute buffer length */
 	*p++ = htonl(NF4DIR);
+	spin_lock(&dentry->d_lock);
 	p = xdr_encode_hyper(p, NFS_FILEID(d_inode(dentry->d_parent)));
+	spin_unlock(&dentry->d_lock);
 
 	readdir->pgbase = (char *)p - (char *)start;
 	readdir->count -= readdir->pgbase;
-- 
2.51.0



