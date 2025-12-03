Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FAA34EEF1;
	Wed,  3 Dec 2025 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777878; cv=none; b=UILToESNVcgwPwmpuw0J4tb9/bj+qREqtm2KhAY0tG5dn9qGXqfvyyQ1y/J3mv0pLSY/RBzAgiuMgR3V5riW5TuE2enT4EnIJ4CcgvweBl8pyLn6oG7qHeLT7x0fVDb3Ibg0xnuNneTNO//vzDfJT+RFrVlz4piB7ExeTmvup6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777878; c=relaxed/simple;
	bh=jwZQMhBE9JC2NktYd0GjecQ60mRwf9cTWbWyt1l7FEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHEYv9MvoS+hzqtiWHW0Zk4AxU08I11iI9nm+SrJPBVjFKioJsj8m90+cPX9cu1jdvkchu/+AQOoPiIyFH11cqcSkcffrMmPvnOJ3y5nmIL+PSaxqArKy8BL0rtJxe+qPymHtv0UeHnhp4l7/+SiTFFho94IVtOoSUPDtORQ+w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgLUGvnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgLUGvnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41344C4CEF5;
	Wed,  3 Dec 2025 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777878;
	bh=jwZQMhBE9JC2NktYd0GjecQ60mRwf9cTWbWyt1l7FEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgLUGvncHJPLVeQgwdTU/WUBEdju8P+bVJBm8Ik90icCX1udNKh6Vc54Svz7/fmwG
	 6nbf2yEJoU1jCT5IYirJUOx1SVYjlep+Gr+T2Sk4v6SHP1xyrbtVmCnDJr4fwzTJcR
	 6tPGnthGf0eir+k4zC8Wcsa7W4XlR6v+7F6VoxG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/392] nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing
Date: Wed,  3 Dec 2025 16:25:26 +0100
Message-ID: <20251203152420.559471817@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1c62c4314173e..5c29e2d383639 100644
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



