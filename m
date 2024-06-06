Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B262C1BF8E3;
	Thu,  6 Jun 2024 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683549; cv=none; b=XV5/m4PAAuqBxr7/nPbc2xMF9TwMIE9hM61TLtgcQoFH3sXbUfclzrZyvfdn77ymdl843/4IKnBSBC7l4EKz6e0i4GfPAw87B/lGCPNNs9SgDyuHn/xT4CXjYNz0B9tlVCCpS0f1Mda3VwuwEwMsP2YMkVyzBZLEsCAFU+fgE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683549; c=relaxed/simple;
	bh=hB4L/tKX3x+2sede49v9sPCtiukCIQpd6HkRrQ9R3G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUQO0gGsjCc5UnzPPaCxOG5l9402f4aCDv8bqVNxesjuq8fwC67ihbb3F3boybUZ/dOZ/P6qHlohpipw2Mdc94XjhgTz2LJZoiD1NpDLzgDDg2csgG476F153VWsVs8mjEuGMwS35TdBs1+Lh0BL8xzinZd3cvE37z4/olIKyaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft0Uy8y6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft0Uy8y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92699C32782;
	Thu,  6 Jun 2024 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683549;
	bh=hB4L/tKX3x+2sede49v9sPCtiukCIQpd6HkRrQ9R3G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ft0Uy8y6m09PKIx7C5qQYWmmhvM0BJ8Ib00qlQ3wfSpHt5MJ1eGoy5d2G2ADwRFmT
	 81wQxYY+LnIxCK0qIcVbpxDm2q5s1bhlFhw5tBnW69pA6apY5J6G+WsI1dufpSeBW+
	 wN74FHmr6UpYENnpE9sqFtj3SeOe+pdIKyR02Z9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Dan Aloni <dan.aloni@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/473] sunrpc: fix NFSACL RPC retry on soft mount
Date: Thu,  6 Jun 2024 16:05:38 +0200
Message-ID: <20240606131713.322161580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index b774028e4aa8f..1dbad41c46145 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1047,6 +1047,7 @@ struct rpc_clnt *rpc_bind_new_program(struct rpc_clnt *old,
 		.authflavor	= old->cl_auth->au_flavor,
 		.cred		= old->cl_cred,
 		.stats		= old->cl_stats,
+		.timeout	= old->cl_timeout,
 	};
 	struct rpc_clnt *clnt;
 	int err;
-- 
2.43.0



