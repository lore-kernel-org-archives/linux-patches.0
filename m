Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADB12CD89;
	Tue, 14 May 2024 10:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682154; cv=none; b=UvOMkDJxhC1p/AzcCKkLniPsQBkkVtDcTBHwieIQk51/oSHick/E7PU3DqEKHRX+ZAoFJeBTIsGDHFGfA56YK2jAlS8WoK7g9rZLpgCxwiudcjjFPw/0V2B9I/m0J6A5A+SAt88s+NZPbYEBzH0bARpIRBpjvP369xr1awUKp54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682154; c=relaxed/simple;
	bh=xjyg7xN/ZMIBzITIFsvgPsM/+in8x+M56lO6YZjdGVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj9LGqW291dTMl6YTPzhI05zl50uojRpwdnscrU3Wb7ijLZiwoXp25DvMAi5ahTFLWSCBTpLKLi1Ow1cajw01iLDrpq9mz+wrex0r+MrazRy8xj6uNyTZC8JBxBXKHpqzmOlsSosoJDvJ2fGVfL3M8i5m8zY1Fx85tzYXm+BY9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esf3y4JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esf3y4JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E53C32781;
	Tue, 14 May 2024 10:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682154;
	bh=xjyg7xN/ZMIBzITIFsvgPsM/+in8x+M56lO6YZjdGVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esf3y4JUS0ibtc3qkoKqFUxsd6fH4RgVJG6Y901kb6MdpgFKnSBdhYkS7gdsralC2
	 VZVYZ4JToUPEpuQsKK+hdSXGh7NJ9V85ngNKbjsMeHaKWTbnofhDAkmnmgTQJ/1iYN
	 0ktWbiaHYJrgNnL414xS6GEidsMH1AnQFrWsOGPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 021/336] NFSD: Fix nfsd4_encode_fattr4() crasher
Date: Tue, 14 May 2024 12:13:45 +0200
Message-ID: <20240514101039.407812643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 18180a4550d08be4eb0387fe83f02f703f92d4e7 ]

Ensure that args.acl is initialized early. It is used in an
unconditional call to kfree() on the way out of
nfsd4_encode_fattr4().

Reported-by: Scott Mayhew <smayhew@redhat.com>
Fixes: 83ab8678ad0c ("NFSD: Add struct nfsd4_fattr_args")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c17bdf973c18d..24db9f9ea86a2 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3513,6 +3513,7 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	args.exp = exp;
 	args.dentry = dentry;
 	args.ignore_crossmnt = (ignore_crossmnt != 0);
+	args.acl = NULL;
 
 	/*
 	 * Make a local copy of the attribute bitmap that can be modified.
@@ -3567,7 +3568,6 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	} else
 		args.fhp = fhp;
 
-	args.acl = NULL;
 	if (attrmask[0] & FATTR4_WORD0_ACL) {
 		err = nfsd4_get_nfs4_acl(rqstp, dentry, &args.acl);
 		if (err == -EOPNOTSUPP)
-- 
2.43.0



