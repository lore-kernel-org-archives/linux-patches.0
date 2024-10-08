Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A0D18F2FA;
	Tue,  8 Oct 2024 13:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392511; cv=none; b=JkYx41VfvJXbQBzJNRXsmGlK2Bi2CX5hAFkvLwEYo6eiy5uKuEEJ+fhDa7o05iAEPSfEFxDytmxTH+7EtwEAUEeBDdirysanHyx+sReGRItDtuYzCkc81Qci/HpQEiKVEkv+1rvze1GEhKn4HITut8yD0iQ+nm8GuWd27hPwD+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392511; c=relaxed/simple;
	bh=kWLk07RQ+IOoknPZ0uhsRm9GfQFz+4g0p3GnZvKrN0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKPyUQizV/nGdNvW2Exp5jE36IesmGt+E4+wYMyA2wQlwDOjV6OTtWyJh8DnfCQFAf8pmxZQM00/8TLC7E1lxSkknrTL8qv94wEMsHjgA8f/Fs4+IBny9EtIdfLayvxgilvu3vJm/fqlxdIfMje5FOVjW/IWYCp7vJIZoPoSHuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFh/UKmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFh/UKmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D09EC4CEC7;
	Tue,  8 Oct 2024 13:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392511;
	bh=kWLk07RQ+IOoknPZ0uhsRm9GfQFz+4g0p3GnZvKrN0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFh/UKmdkt0OPvMy+PoTwrAf83M/rIPjvr73wBWLNnKMLarHaOnjjNw1f6Un2mO1K
	 7jXqyCbpVwUvo9FE7YHlEa0Rqg4Wi9Atn0wS/N9BdLfU+mQiO4o/4LcYEls1JwX6QF
	 Ol2Vf0JZbJ16TzOfHVyYx304aveQj8H7ZrEuOG/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cedric Blancher <cedric.blancher@gmail.com>,
	Dan Shelton <dan.f.shelton@gmail.com>,
	Roland Mainz <roland.mainz@nrubsig.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.11 436/558] NFSD: Fix NFSv4s PUTPUBFH operation
Date: Tue,  8 Oct 2024 14:07:46 +0200
Message-ID: <20241008115719.429802962@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2374,7 +2366,7 @@ static const nfsd4_dec nfsd4_dec_ops[] =
 	[OP_OPEN_CONFIRM]	= nfsd4_decode_open_confirm,
 	[OP_OPEN_DOWNGRADE]	= nfsd4_decode_open_downgrade,
 	[OP_PUTFH]		= nfsd4_decode_putfh,
-	[OP_PUTPUBFH]		= nfsd4_decode_putpubfh,
+	[OP_PUTPUBFH]		= nfsd4_decode_noop,
 	[OP_PUTROOTFH]		= nfsd4_decode_noop,
 	[OP_READ]		= nfsd4_decode_read,
 	[OP_READDIR]		= nfsd4_decode_readdir,


