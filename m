Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD72115FCF0;
	Mon, 27 May 2024 19:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838601; cv=none; b=Yxg74Wb7BPDZIGak7Bi4afjoHaDTWQOzzRF7/z6cnXjm4Q8jTaSIvE1LhzRQl08PZzjFBVAwyp59r61gVoup3KiFeJFT64pns3W1eMv7qJ6XTgMKssDB0RbTi1yv1i9J+P2jQFvKR0sdjUnjN1CS5B3XKEtz7Ic/PtLM6ifZhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838601; c=relaxed/simple;
	bh=s5nq+TT2kl4TFnBQWM5mDdf9dH8MwrGO8eX/aygQGZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9FkC76ppSoaU/8z0D9QgjL0fmjbUY0yIda8twqTXBBKVPXDihvAPDnHGW/2GvQ3kI8ERNx8iY6OSEg7MvDHqPyD5+EnXO0cvhOd70JPO2G9naHzGeEcmXfNXyBrEGoynBOdzD4kIrNuB2U6rjixqtC26DqjNccBceMsXb4ZwnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxUUhNjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxUUhNjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2A9C2BBFC;
	Mon, 27 May 2024 19:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838601;
	bh=s5nq+TT2kl4TFnBQWM5mDdf9dH8MwrGO8eX/aygQGZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxUUhNjXjDFnmitjjHkBQkJHkMAb+bduOC3Hf28NxGB5vMHinpOf320oOMvitf8Kp
	 fmeuBSYH2JTcnJ058M3P/R6LBUjJXwA5c/GMwsegeBwrTIVJy1uirIsG8jVjD/BtW9
	 XYtH/UzrAKtVG2Z6xk8f6anNHzYtR9iQ7SnYsHQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 456/493] sunrpc: removed redundant procp check
Date: Mon, 27 May 2024 20:57:38 +0200
Message-ID: <20240527185645.123809244@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Aleksandr Aprelkov <aaprelkov@usergate.com>

[ Upstream commit a576f36971ab4097b6aa76433532aa1fb5ee2d3b ]

since vs_proc pointer is dereferenced before getting it's address there's
no need to check for NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8e5b67731d08 ("SUNRPC: Add a callback to initialise server requests")
Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index b969e505c7b77..bd61e257cda6a 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1263,8 +1263,6 @@ svc_generic_init_request(struct svc_rqst *rqstp,
 	if (rqstp->rq_proc >= versp->vs_nproc)
 		goto err_bad_proc;
 	rqstp->rq_procinfo = procp = &versp->vs_proc[rqstp->rq_proc];
-	if (!procp)
-		goto err_bad_proc;
 
 	/* Initialize storage for argp and resp */
 	memset(rqstp->rq_argp, 0, procp->pc_argzero);
-- 
2.43.0



