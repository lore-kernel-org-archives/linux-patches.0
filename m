Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B9C1C75F2;
	Mon, 14 Oct 2024 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919325; cv=none; b=eOD47AUaWJ3x9N6dPqikcJltKGADVyIQe+qziGoZ/QaqbvkTwIRm+DaalaPSuL817pXhWGs2CHckFTlC6G80VZuhVQsUUvLEL6KzvAuIZSvxbhcXFPjIZxUWX3fzwIhf6jsXaAfifUpC6q7uRcdoC0T7isxQi1faQ/IPqm9hO/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919325; c=relaxed/simple;
	bh=LynaRG21rpdTzXfs6Ak8KN/WszbsAt5ZnwQXX9Zh7Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saEKqF5w1wTKxi4JYuZq04Vjn7jB2WpPEs02JxLlqKuive0Ig09P5txxVILj0+peKKIHKup9JTYSmW0O2ET9vUhv8lb2iLdRvjogIkr9jxlHjoMvObMwBbBKJbzmHhO48mMZbJ4w2WeXqZEX0E/begkcBmMASmqogVHJtiH+P80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYAf+VcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYAf+VcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDD3C4CEC3;
	Mon, 14 Oct 2024 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919325;
	bh=LynaRG21rpdTzXfs6Ak8KN/WszbsAt5ZnwQXX9Zh7Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYAf+VcAahOfjmPIkJfgv+N5PZbwBWhXrP5zU0G6tf4u5JmKhf+UyXY/x42iR+3FZ
	 eEGsDik5YW+ms8/p0jkTPSIem0X1QsliBSdJXCixnI2qEHHvuTVUqPx65bL693DaeY
	 tbEDDfi7BQI6ldDQ1P2r+5tgl+49IqOIS6cA78VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cedric Blancher <cedric.blancher@gmail.com>,
	Dan Shelton <dan.f.shelton@gmail.com>,
	Roland Mainz <roland.mainz@nrubsig.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 578/798] NFSD: Fix NFSv4s PUTPUBFH operation
Date: Mon, 14 Oct 2024 16:18:52 +0200
Message-ID: <20241014141240.710726074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 202f39039a11402dcbcd5fece8d9fa6be83f49ae upstream.

According to RFC 8881, all minor versions of NFSv4 support PUTPUBFH.

Replace the XDR decoder for PUTPUBFH with a "noop" since we no
longer want the minorversion check, and PUTPUBFH has no arguments to
decode. (Ideally nfsd4_decode_noop should really be called
nfsd4_decode_void).

PUTPUBFH should now behave just like PUTROOTFH.

Reported-by: Cedric Blancher <cedric.blancher@gmail.com>
Fixes: e1a90ebd8b23 ("NFSD: Combine decode operations for v4 and v4.1")
Cc: Dan Shelton <dan.f.shelton@gmail.com>
Cc: Roland Mainz <roland.mainz@nrubsig.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1246,14 +1246,6 @@ nfsd4_decode_putfh(struct nfsd4_compound
 }
 
 static __be32
-nfsd4_decode_putpubfh(struct nfsd4_compoundargs *argp, union nfsd4_op_u *p)
-{
-	if (argp->minorversion == 0)
-		return nfs_ok;
-	return nfserr_notsupp;
-}
-
-static __be32
 nfsd4_decode_read(struct nfsd4_compoundargs *argp, union nfsd4_op_u *u)
 {
 	struct nfsd4_read *read = &u->read;
@@ -2345,7 +2337,7 @@ static const nfsd4_dec nfsd4_dec_ops[] =
 	[OP_OPEN_CONFIRM]	= nfsd4_decode_open_confirm,
 	[OP_OPEN_DOWNGRADE]	= nfsd4_decode_open_downgrade,
 	[OP_PUTFH]		= nfsd4_decode_putfh,
-	[OP_PUTPUBFH]		= nfsd4_decode_putpubfh,
+	[OP_PUTPUBFH]		= nfsd4_decode_noop,
 	[OP_PUTROOTFH]		= nfsd4_decode_noop,
 	[OP_READ]		= nfsd4_decode_read,
 	[OP_READDIR]		= nfsd4_decode_readdir,


