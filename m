Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC8C198A2A;
	Thu,  6 Jun 2024 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683377; cv=none; b=tnxBs7Rv5FpQFCb9Kuu0a7A0sCKCiqz1oyWkBfQsX5OrONjZGhd6jyJhGM27nyAwKy3t/MxJn3CQaZG4Z05B7yk9Gq6nXerBPrEqStPuKhUxTnWti8SDdUQAbWfRW3DUv9vzS9YmZ4Jeuv4KB9c556BR7eXZ9VuLnrJ8Zw0M6tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683377; c=relaxed/simple;
	bh=5w0EU1Bd9+ANALUjRhTvHi5hYK0PcK1zAhTigzuqR5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXYX0fWiVd7LNFTAEISTT7c6afnpCC/gwV408FAduKpOHO+Y0FFwtIMfBdbkwrk1JXFEdqin/yDyvm3lz0mJtqork3wAUQItFikfT8NYnaArT820gM2mLq9rWXDSp2ktmhw9A0SFumOOQb72ypa/RGKysh1g6A9eA9fszHM+AsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jA7On+2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jA7On+2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAC1C2BD10;
	Thu,  6 Jun 2024 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683377;
	bh=5w0EU1Bd9+ANALUjRhTvHi5hYK0PcK1zAhTigzuqR5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA7On+2IDk8ETB62JthvuuPS0Oy4y4L4/mY0ssgAPEkkhJYvmLfcPWz04/OQgfhzk
	 ZDiM2efiV/Z0CRH6rS6TmmTPYtEhAqAL7lwAG8hXoDIayo6yaq6SPwkNOmur/e2kkA
	 GpxuPeDjz3UxRMDCy7O0ZAuVdoikK15/ymTB5dgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 260/473] sunrpc: removed redundant procp check
Date: Thu,  6 Jun 2024 16:03:09 +0200
Message-ID: <20240606131708.557215839@linuxfoundation.org>
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
index 9b0b21cccca9a..666d738bcf07e 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1205,8 +1205,6 @@ svc_generic_init_request(struct svc_rqst *rqstp,
 	if (rqstp->rq_proc >= versp->vs_nproc)
 		goto err_bad_proc;
 	rqstp->rq_procinfo = procp = &versp->vs_proc[rqstp->rq_proc];
-	if (!procp)
-		goto err_bad_proc;
 
 	/* Initialize storage for argp and resp */
 	memset(rqstp->rq_argp, 0, procp->pc_argzero);
-- 
2.43.0



