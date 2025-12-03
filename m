Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EEF364E83;
	Wed,  3 Dec 2025 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779428; cv=none; b=m3nSBXYYNAn+KDjbeqkFb8q4huS3MjN9wHq9KXjcQOwYUOAUu+4dkEAPJZBq90q/ik981yfufd98IA/orDivGLVhvJKph9/msDFusTBSBofCKgI1bCVndN5NmjWoXZQZd1zGNPC284xU/rQgZOsyDhlVkc7FBLIdzIlBGxoA2TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779428; c=relaxed/simple;
	bh=N2UBRpNEaNqLMXLb6O9Bn7VOl9IHXbv3Gjb74echYLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLAw84kYqQ4fWjvrWM4HEH/Zaxj1rardPsvdIAPNXT4sr20zgfKPJZR8nO1xhemLZ/Ay5iWULvEBOUolNrGhCtgblsp3NF340nM4TQ+Cr5iMGUZuDvFi6p1W1Jom7ypTAX8issWXC41qazJBhhx70Rnzs80weJLvo8CDlZaPklc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vodQyXV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vodQyXV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD89C4CEF5;
	Wed,  3 Dec 2025 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779427;
	bh=N2UBRpNEaNqLMXLb6O9Bn7VOl9IHXbv3Gjb74echYLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vodQyXV22K730qXo7v8OwMkw/TGxWy5AIY4Yvo5PyJAOirmIZP0c/4JJb26120qYl
	 lqwdTqzR/KrR0yQzTlO1Ozk81o9TvZ2g1zOxXOMndj0q+eHnZyNoXyOc+Ah7/uud2D
	 J9lBaUQVo3VR0NMvJd7crE2yI68raXGH7I2dDXIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 255/568] nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing
Date: Wed,  3 Dec 2025 16:24:17 +0100
Message-ID: <20251203152450.060254434@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 935ca3845ce53..f387a3862ca09 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -362,7 +362,9 @@ static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dent
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



