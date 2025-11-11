Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA713346FA2;
	Tue, 11 Nov 2025 01:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824249; cv=none; b=Se46FwaPdtMo7/pYLDyMqKG0bHi2jfTT/9VZJIhIrJF9Le0TBFh9nnT6ZgiVXMzBbCXhQXtpjx52qpbbXfMa60jYrfHgzS45UGg5WOEDlww23XHT2lAHWuO1dkLCjvn2i2XkPHxV62trc87U/gub31WcCru2cC2ZGYrjIm/iemg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824249; c=relaxed/simple;
	bh=YO3TAJBgCHNZShoMNwLIaV/76v7Kqg/6zMusK248k4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzrCXEER+D6fMCY4DvRhlTXk7pfrfoYtcGo29NXyJGMzIzvK6b2IXzmn7OU3TPPaXV4/jw/ePD+w9jmNBNzj5831m7pnkiszBlPFd9PGJO4XuWV3Acbx7qaUgAE1XTk3METxg+nf7xGWfM7XQbkgY81MxTbQQ3eB7LTEQKGIqiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7l9ggOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7l9ggOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFBDC4CEFB;
	Tue, 11 Nov 2025 01:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824249;
	bh=YO3TAJBgCHNZShoMNwLIaV/76v7Kqg/6zMusK248k4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7l9ggOafKoHb1inMv+BqHdmOfYdhHwl1R/wJ33Q0NyrScRdF8qJ2XWl1eBG8pJ2L
	 oJSrwNdRLDUudKZJYGwnY5GTcahUgQUhmg7rdO+sHyAL3HpbmmOyf3TqkWIKrOmfsO
	 jCvsuMPGpCUaK3g9WtqvYwh3yJoGbST6IyW1hxmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 419/565] nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing
Date: Tue, 11 Nov 2025 09:44:35 +0900
Message-ID: <20251111004536.288138112@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 2b71d39fe8c01..b0ba9f2bef56b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -374,7 +374,9 @@ static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dent
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



