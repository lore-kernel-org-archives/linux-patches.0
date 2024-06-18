Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5D51DA24;
	Tue, 18 Jun 2024 12:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714733; cv=none; b=mQuqDGhHXDitFd7vbjG6A3uzYOrC/RpyUUF5SCQZuaTOzItbObh5yy1ELM+jvHrzqXhhr3/6jqfUsRjpGNhxYOK0crq9q2rrfFFm56P6PtUeK+lI6puWihdT8zMlPAfbZ3gvhqFoBo4kStPNjROmp9eCn1GcZsu6cfO28zC4TWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714733; c=relaxed/simple;
	bh=/VF/gpw+fgvR0QWcraXMumHNcxyEyErajzziBeQ4DVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ge7i+E+YpOjFufxxYrkE5NsCfxKx5O7fp2uxBE88/7eAsfSpNFPC77uYWQDnXZGvJACD9xjClo/CLF7NelpUth0MLFHo5G5t+mbPu4t/oI69AcGu0SwU7Gse5Dvq0vrK9DQ93DHSP+ReA8nMGElVhQKDYcInSaGWLy0tdFTsgIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6R7RvsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6R7RvsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBA8C3277B;
	Tue, 18 Jun 2024 12:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714731;
	bh=/VF/gpw+fgvR0QWcraXMumHNcxyEyErajzziBeQ4DVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6R7RvsVZLfqnfohy7LHAVF1L4b55WLzGwy0Jk4lyn/6mRUKWrdcivbqmOv5kSgAt
	 ROx02NrZdxHfrmAbzNBTIVP8nI/HT28PVq2qv3+e9G6YLHsO2sJ7OecCvp45kLJfpb
	 /9v8aW2S8hyXS4YlrujEoEeuJkMcU1191SYqiWDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/770] NFSD: Replace READ* macros in nfsd4_decode_lookup()
Date: Tue, 18 Jun 2024 14:28:11 +0200
Message-ID: <20240618123408.763439310@linuxfoundation.org>
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

[ Upstream commit 3d5877e8e03f60d7cc804d7b230ff9c00c9c07bd ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 3c20a1f8eaa91..431ab9d604be7 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -931,16 +931,7 @@ nfsd4_decode_locku(struct nfsd4_compoundargs *argp, struct nfsd4_locku *locku)
 static __be32
 nfsd4_decode_lookup(struct nfsd4_compoundargs *argp, struct nfsd4_lookup *lookup)
 {
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	lookup->lo_len = be32_to_cpup(p++);
-	READ_BUF(lookup->lo_len);
-	SAVEMEM(lookup->lo_name, lookup->lo_len);
-	if ((status = check_filename(lookup->lo_name, lookup->lo_len)))
-		return status;
-
-	DECODE_TAIL;
+	return nfsd4_decode_component4(argp, &lookup->lo_name, &lookup->lo_len);
 }
 
 static __be32 nfsd4_decode_share_access(struct nfsd4_compoundargs *argp, u32 *share_access, u32 *deleg_want, u32 *deleg_when)
-- 
2.43.0



