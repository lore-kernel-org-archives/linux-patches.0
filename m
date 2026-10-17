Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B164F3AAF7D;
	Sat, 17 Oct 2026 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255900; cv=none; b=cG0b4ht1vY5y9Bh2oeR2i3uSoZZgb1Fk6nrEYO91oHmxqKrYvdbQoVYzOhhiAyUZmyXDrZyaNut+dwluDRX5pYOns9Y/gzAX1T2dsNhaqkip0rKHWN8E6mCaoIt26sOjA+2rpztEyPAXzzV/mgKbcv7G2MDEaC4Qmc0MLQwt25I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255900; c=relaxed/simple;
	bh=ECK2pZs6JyOPgcN8WH2UiONk4ZWblrPr0FgGs85svdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6Z72Ga8Q90lhThPnGk5vX/gGRQ3faUor84292jJy9SZu+N4t030LbtX2fyrNdk149tCLPPl5kvtdGNfzYi5Zl0uZYyKjrHmmbaAkFkXhyxdTaVN7jb8f1kU0XWmYU8dCtIh9TC8iEwoRwhvEP+qrn2ovbwWbBYPrdLbRAQEob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyS323up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyS323up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134221F000C4;
	Sat, 17 Oct 2026 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255899;
	bh=EFovtRtAYO9bfNt2WQFn96WOpzbjGPlmnhZ270Y0fh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyS323up2phNFoMAaf9b4XAegf+QnS/0IniFpTMLR0DYC6nqyXg3PPNI7DB8PwiIB
	 JIPtAkFLgYrBE29R06JscXWw0jhCIQgWGtSq3VybimOCrR8t6fWOKCWDhJA3Ocxfmq
	 gs8G7uokBtzMraRJ33zEXkZBwYXESe1zbcIcomjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0057/1674] nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()
Date: Sat, 17 Oct 2026 17:38:49 +0200
Message-ID: <20261017160432.602756428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 2c7912732184773dbd371a411da87af1cc080b86 ]

nfsd4_create() stores the return value of nfsd4_acl_to_attr() in
status, but the switch(create->cr_type) block unconditionally
overwrites it in every branch. ACL translation errors are silently
discarded, and the CREATE proceeds without the requested ACL.

Add an early exit check after nfsd4_acl_to_attr(), matching the
pattern already used in nfsd4_setattr().

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: prefer NFS4ERR_BADTYPE over NFS4ERR_ATTRNOTSUPP ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-5-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 1d87cf0c6b932..79791ebfc1a30 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -795,7 +795,23 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		return status;
 
+	/* Sanitize cr_type to avoid returning ATTRNOTSUPP. */
+	switch (create->cr_type) {
+	case NF4LNK:
+	case NF4BLK:
+	case NF4CHR:
+	case NF4SOCK:
+	case NF4FIFO:
+	case NF4DIR:
+		break;
+	default:
+		status = nfserr_badtype;
+		goto out_aftermask;
+	}
+
 	status = nfsd4_acl_to_attr(create->cr_type, create->cr_acl, &attrs);
+	if (status != nfs_ok)
+		goto out_aftermask;
 	current->fs->umask = create->cr_umask;
 	switch (create->cr_type) {
 	case NF4LNK:
@@ -862,6 +878,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fh_put(&resfh);
 out_umask:
 	current->fs->umask = 0;
+out_aftermask:
 	nfsd_attrs_free(&attrs);
 	return status;
 }
-- 
2.53.0



