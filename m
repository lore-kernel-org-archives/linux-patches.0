Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6567881AA7;
	Thu, 13 Jun 2024 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281042; cv=none; b=eJnH4iIPiTc4uQDEvIKRfsCRiIp+ZyVG85+bdWo4XYDaqteTc08ecKToLtvoabn2NtEHuNmXuw+YmKQliIrxVagWE2Rh4A8zBg/baUBtAExuPlSxIfuV5tPF8I2n/DwSoElAbkm4wReFYPOllUOOS5gPVHDluM2tN1cK3PbSwVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281042; c=relaxed/simple;
	bh=mE5Vnw7Or0uU6cn+eT6l9tdeDXoFiW2+tEFeJr8uDWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQKRD4RHKef5e7HGV7vmoJztoiBiPYlt+8znxVGyVvYyKe28iJk3/VWxfJPTeth3kZw5s8+0eHmaYepSEjljnrMi6pw+D8HTmigwB86OROH0Wq+7f57dfMH8201zPp0wsCCKdifZcD0fmH6PPmaDEYCVdy/eiZDuzsPSgg/9SH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh23qeGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh23qeGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F6BC32786;
	Thu, 13 Jun 2024 12:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281042;
	bh=mE5Vnw7Or0uU6cn+eT6l9tdeDXoFiW2+tEFeJr8uDWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oh23qeGxfaTlwneKvLCj5oHIECDfgq5I1DT3S0FbLEMX7vMAadVNJx7JWOe2nF4/r
	 6T6qNpv29hwncVPJa+OFg/kKBQf7n5qFd3LS3v8O/af9oILaq+b0vjfIgwEbzXjSNR
	 aGog89VN9TbmazYAeG5wqV4MYucXeOZYBC/17WT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/317] sunrpc: removed redundant procp check
Date: Thu, 13 Jun 2024 13:32:18 +0200
Message-ID: <20240613113252.193390352@linuxfoundation.org>
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
index 495ebe7fad6dd..cfe8b911ca013 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1248,8 +1248,6 @@ svc_generic_init_request(struct svc_rqst *rqstp,
 	if (rqstp->rq_proc >= versp->vs_nproc)
 		goto err_bad_proc;
 	rqstp->rq_procinfo = procp = &versp->vs_proc[rqstp->rq_proc];
-	if (!procp)
-		goto err_bad_proc;
 
 	/* Initialize storage for argp and resp */
 	memset(rqstp->rq_argp, 0, procp->pc_argsize);
-- 
2.43.0



