Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDA915B55E;
	Tue, 18 Jun 2024 12:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714705; cv=none; b=XkhSO0eR3+S/vjEaYOlo8UPO9YKTZEi3W793Ox0gYvs5HRik1KakmhEQEUPfcaJ7xhzcm4B1YEexIq/XwDoshlcJfBgYD1M7v2WjtdiLvrLD6gLsIj3jyofMzfOK7yfGeLWOrTtRMK56sIu2/LuvxDOE2RiiC5AffLRziD50TwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714705; c=relaxed/simple;
	bh=q3iBvg733+ScaIp/SkAIaiT2oyHx+0yNUO3w0l/opi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNJqxOs99KgANMQkxpaCORrjWeo4El3AEOdeLlpe1orBqetU1dqIlbzMftztl00XvYQKtLnflBEH65j7TOj9DpDtwvDMi0HaUmgaYhT9qoB+fxjToh670nxTTGgIpvluXuxL/81HPcvQWC9TwutyK32TbpqEqNDELBQJ7w7zlHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGkphTZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGkphTZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B63C3277B;
	Tue, 18 Jun 2024 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714705;
	bh=q3iBvg733+ScaIp/SkAIaiT2oyHx+0yNUO3w0l/opi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGkphTZ47tU3uSpKcDsjhuAoMT3oIoyTyIPSoTQapuBEG6GoqsRMLDuDIprjWd1rX
	 EK3+Gcr1kJiKhgL43m8hbXLrJlLZxtd5h3TMhm8iBw6BSV8TBTUVWx88R5WSana24O
	 iR92+vLNdOmqr2boaBXTE5EwkNHcEJUhgF5pPTs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/770] NFSD: Replace READ* macros in nfsd4_decode_release_lockowner()
Date: Tue, 18 Jun 2024 14:28:33 +0200
Message-ID: <20240618123409.602943262@linuxfoundation.org>
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

[ Upstream commit a4a80c15ca4dd998ab5cbe87bd856c626a318a80 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 26744b7f0e35c..cc406b7a530b6 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1418,20 +1418,20 @@ nfsd4_decode_write(struct nfsd4_compoundargs *argp, struct nfsd4_write *write)
 static __be32
 nfsd4_decode_release_lockowner(struct nfsd4_compoundargs *argp, struct nfsd4_release_lockowner *rlockowner)
 {
-	DECODE_HEAD;
+	__be32 status;
 
 	if (argp->minorversion >= 1)
 		return nfserr_notsupp;
 
-	READ_BUF(12);
-	COPYMEM(&rlockowner->rl_clientid, sizeof(clientid_t));
-	rlockowner->rl_owner.len = be32_to_cpup(p++);
-	READ_BUF(rlockowner->rl_owner.len);
-	READMEM(rlockowner->rl_owner.data, rlockowner->rl_owner.len);
+	status = nfsd4_decode_state_owner4(argp, &rlockowner->rl_clientid,
+					   &rlockowner->rl_owner);
+	if (status)
+		return status;
 
 	if (argp->minorversion && !zero_clientid(&rlockowner->rl_clientid))
 		return nfserr_inval;
-	DECODE_TAIL;
+
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



