Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B72B1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9649CC433C1;
	Wed, 23 Nov 2022 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196597;
	bh=KqR3IwAImF6SSQJBFCNKIYOr1z71vch5MANtyqJIblM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVo2ZxTS2J5xKUUxU1ZomoB69xbbQqNZczyIeS9Ud83CETPj7nd7yYQDkIWogaOmP
	 C5CFItRWORGVqVZdwaMYSXV7Ng2GFxYvR0muftGeLNRLzeEo2WnsedOf8DgJPKdAV0
	 CCMpsqPCxsN9wxUftJ2GtoO0T88wGF29qv7cw4wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 036/314] SUNRPC: Fix crasher in gss_unwrap_resp_integ()
Date: Wed, 23 Nov 2022 09:48:01 +0100
Message-Id: <20221123084627.155148724@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8a0fa3ff3b606b55c4edc71ad133e61529b64549 ]

If a zero length is passed to kmalloc() it returns 0x10, which is
not a valid address. gss_unwrap_resp_integ() subsequently crashes
when it attempts to dereference that pointer.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/auth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index a31a27816cc0..7bb247c51e2f 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1989,7 +1989,7 @@ gss_unwrap_resp_integ(struct rpc_task *task, struct rpc_cred *cred,
 		goto unwrap_failed;
 	mic.len = len;
 	mic.data = kmalloc(len, GFP_KERNEL);
-	if (!mic.data)
+	if (ZERO_OR_NULL_PTR(mic.data))
 		goto unwrap_failed;
 	if (read_bytes_from_xdr_buf(rcv_buf, offset, mic.data, mic.len))
 		goto unwrap_failed;
-- 
2.35.1



