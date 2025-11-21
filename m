Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE0D3F9D2;
	Fri, 21 Nov 2025 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732871; cv=none; b=W/N9PbFcU3erfbpTURygcaaVEM/PlSE9TQZmBXKUOAJdvaQuJAdCPtlFmZzJQJ8ggkdP8WTJ5oZbwdNsUzv6G0b/xQIsbKkduPJDrhOWVF46mIdhqtPb3lDQosYY/Q34+DRnbRjBq6NpgTstoXVl1zoAFvAiQS9L4Ged5mfO2eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732871; c=relaxed/simple;
	bh=Z3rQjr/xz5gGxUertnAuoVbVjUzHn9QmvKLCDJEBU08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckpMxj/REhr0jO8tnIQocL4a8fEvaqTrvMNuqRdZ7cBLxu4F3q/uCJ/6ndtAcdilxeRPDtRz4JNQ0I+zChJcEw2turefHUYskBn5AWsuUze5T2Gq8YO49vjUmYJ6FquWMJZk4Q83hOHfE00MuJRLdMsad5t+ErMRosIy3kJZrbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FqKbwJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FqKbwJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26188C4CEF1;
	Fri, 21 Nov 2025 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732871;
	bh=Z3rQjr/xz5gGxUertnAuoVbVjUzHn9QmvKLCDJEBU08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FqKbwJqISsexGb/vsC8qt/91h0RZUvS5D3FF/XByo30tbAYjBmsCRaFWO2O1nSTO
	 NZkn5yguGY2QO7zI5mXcVrVmwIQa7BTcT0VGWVeDzOxMv0YYrRaIFVL4m85bLBXH/K
	 MZMteI1QYHiZb0ZAyDsC67BL4GULjNNasOsk8hME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/529] nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing
Date: Fri, 21 Nov 2025 14:09:30 +0100
Message-ID: <20251121130240.663234662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cfeef23ac9412..92e40e41443cd 100644
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



