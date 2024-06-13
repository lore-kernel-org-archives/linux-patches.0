Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E75145B32;
	Thu, 13 Jun 2024 12:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281445; cv=none; b=ol0A/LPEFDAfw6i4Uz3cKFj281dW4ip1lSKtcah1Dgc6gVjKNRaddZI5SC3H7/iiWOx8CMHsFQ4uAy1N0nTX9sDHEIJmwbzF2y56Anis4yH+b+mJ3Z7jR+5pK0sAKkPB1kIJO5quG4nC8fjg4KmWF/xx5ALUcR73RfWZV/1+55s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281445; c=relaxed/simple;
	bh=vPuGk4ar99gwQBVWAF0ehp2+dtBcMuw3ZjSYIxcw9Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdRGGi3RmJ+Je7YNVTOC7ojLz6CJla1JaG40hNo00+/xMBesq+bvr/YdBky7YUtb46w1NsKE3fVezzjd+jP5xi/RVCwNPomV7OXTnqqfqXCsWnySohBBdkJEH8qVkx9vKGsqUTgbU+8cnqTCAbCXEWcyVLRQSEuXx+2w8Rkme9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScV8HyCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScV8HyCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025AAC2BBFC;
	Thu, 13 Jun 2024 12:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281445;
	bh=vPuGk4ar99gwQBVWAF0ehp2+dtBcMuw3ZjSYIxcw9Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScV8HyCUeki/37CGsvqGzbf9Ulg63mP6SRY9DbAb5FP4BKEq+grZwjkRvLD8RXdLg
	 b63nKYpfVGkeRhdhK2qjgQ53QvJaK5RFftxga3JB8hM3mLMYfjFW/SQt3oPqOSdxmh
	 fCPmravybDDZrqLxp608p7wxzzNQkHPI5HMyebKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Dan Aloni <dan.aloni@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/317] sunrpc: fix NFSACL RPC retry on soft mount
Date: Thu, 13 Jun 2024 13:34:08 +0200
Message-ID: <20240613113256.448197620@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Dan Aloni <dan.aloni@vastdata.com>

[ Upstream commit 0dc9f430027b8bd9073fdafdfcdeb1a073ab5594 ]

It used to be quite awhile ago since 1b63a75180c6 ('SUNRPC: Refactor
rpc_clone_client()'), in 2012, that `cl_timeout` was copied in so that
all mount parameters propagate to NFSACL clients. However since that
change, if mount options as follows are given:

    soft,timeo=50,retrans=16,vers=3

The resultant NFSACL client receives:

    cl_softrtry: 1
    cl_timeout: to_initval=60000, to_maxval=60000, to_increment=0, to_retries=2, to_exponential=0

These values lead to NFSACL operations not being retried under the
condition of transient network outages with soft mount. Instead, getacl
call fails after 60 seconds with EIO.

The simple fix is to pass the existing client's `cl_timeout` as the new
client timeout.

Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Link: https://lore.kernel.org/all/20231105154857.ryakhmgaptq3hb6b@gmail.com/T/
Fixes: 1b63a75180c6 ('SUNRPC: Refactor rpc_clone_client()')
Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index a5ce9b937c42e..196a3b11d1509 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -970,6 +970,7 @@ struct rpc_clnt *rpc_bind_new_program(struct rpc_clnt *old,
 		.authflavor	= old->cl_auth->au_flavor,
 		.cred		= old->cl_cred,
 		.stats		= old->cl_stats,
+		.timeout	= old->cl_timeout,
 	};
 	struct rpc_clnt *clnt;
 	int err;
-- 
2.43.0



