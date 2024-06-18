Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC82713E022;
	Tue, 18 Jun 2024 12:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714696; cv=none; b=piUL35fPmZih3S4SNH785y3VQ2RVfGzlD6ZeLOE3vb7vzOcLi2lSFj1h16oO8QObK/royltY5Smy1ZlVYMqzlWVxTeoe0TMBQEt81jDOi5v8o4Jc4+2dIMpZNWksJz/Edi2M7c2rUC1+z/9xdXkT0gB6w5MkAiMSHK78SaPxETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714696; c=relaxed/simple;
	bh=ZyEYVcosxY3vnFpphpWFToRNZenUswhZaiQ63RgIQNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoH/KjIc9uracIZGskxGMP9yirErHa6U7gt2KfrWnX3jr8xp1iNcrde4GP/mz9qzaxaFtSmWRo5d+ahw5pZY008dpPeQhK9IosOcxp8RSQQtfHdGwaycxNk3acKaA2ZOMV3rz0kEAUpUhm9DbUSMhe0+PqdldLHUJSe4N597glQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkEwGP03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkEwGP03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF25C3277B;
	Tue, 18 Jun 2024 12:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714696;
	bh=ZyEYVcosxY3vnFpphpWFToRNZenUswhZaiQ63RgIQNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkEwGP03lkPmkdZyag8qRwVqkc7f8euzPYcP3L3Uas7PYt687wMqEYZ+Bn2sDB7G/
	 RszZYHKMHXEXhXw2e4Tve3Uc8aoPLkbyOwsOBQ+ExVQYt5oc3kaDnIFfu+UZBRR4U/
	 UiSbK7NP+0kk4vrU8C8XWxET53dBQvu4Xu8Lr21c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/770] NFSD: Replace READ* macros in nfsd4_decode_setclientid_confirm()
Date: Tue, 18 Jun 2024 14:28:30 +0200
Message-ID: <20240618123409.488565387@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d1ca55149d67e5896f89a30053f5d83c002ac10e ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0af51cc1adba3..057cc1579f9b8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1355,16 +1355,15 @@ nfsd4_decode_setclientid(struct nfsd4_compoundargs *argp, struct nfsd4_setclient
 static __be32
 nfsd4_decode_setclientid_confirm(struct nfsd4_compoundargs *argp, struct nfsd4_setclientid_confirm *scd_c)
 {
-	DECODE_HEAD;
+	__be32 status;
 
 	if (argp->minorversion >= 1)
 		return nfserr_notsupp;
 
-	READ_BUF(8 + NFS4_VERIFIER_SIZE);
-	COPYMEM(&scd_c->sc_clientid, 8);
-	COPYMEM(&scd_c->sc_confirm, NFS4_VERIFIER_SIZE);
-
-	DECODE_TAIL;
+	status = nfsd4_decode_clientid4(argp, &scd_c->sc_clientid);
+	if (status)
+		return status;
+	return nfsd4_decode_verifier4(argp, &scd_c->sc_confirm);
 }
 
 /* Also used for NVERIFY */
-- 
2.43.0



