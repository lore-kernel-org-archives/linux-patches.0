Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F9B237FFC;
	Thu, 12 Dec 2024 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019881; cv=none; b=k6XUK26oJjADZpVY0+B1Sj5IR8Ml8NwdhQ2is+jrvY2NmHJ8imgAoyuSuoymnX6yEx+KTQF4k91pw4fRCEHh9Ag6Tjmzpn0eURK701D3mQXQjZmY6lfwSTr60gwRX6ot9VmmpTFAyhLWBQ2NoVH+jIRj+PCctkz3u4RtvvKT76E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019881; c=relaxed/simple;
	bh=FVdabs88ARBb6IsdLajudDRZ53g3cpZUfypd/1jD2oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/oN0nntD4nI2YovKr77Kp0ztxzT+YiWQKaU94LFZ2xOr3mPJVn3rwrsJ1NqY5SfYGmWCCD6f3K9hucWJG+EHK0YJDeF7IIIJHzRrOC2qVMDi8nxvJ+h7g3sGi1AwT9aNVmGJorzExOsORd8BLftzdUfDD1P2FnnMuG8zsf49n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0XNBa7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0XNBa7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC0EC4CECE;
	Thu, 12 Dec 2024 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019881;
	bh=FVdabs88ARBb6IsdLajudDRZ53g3cpZUfypd/1jD2oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0XNBa7xVKUz/l9y6mrj/Ce8B2/mELeMU9vcQWpamLMZIEwiKUj0T/m1a/BSEoFQw
	 7OM6LNYTuF5GCNcxQpKEiNyN62EmLLXemgxRg1RqX1N3uQtAkilLGT2j4HR3SigKWZ
	 Nfzt8D9Yv2rdi0MgRD8ry6rnMMCndNZ1AX+exfoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/772] sunrpc: simplify two-level sysctl registration for svcrdma_parm_table
Date: Thu, 12 Dec 2024 15:53:57 +0100
Message-ID: <20241212144401.970100784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 376bcd9b37632cf191711a68aa25ab42f0048c2e ]

There is no need to declare two tables to just create directories,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: ce89e742a4c1 ("svcrdma: fix miss destroy percpu_counter in svc_rdma_proc_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 5bc20e9d09cd8..f0d5eeed4c886 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -212,24 +212,6 @@ static struct ctl_table svcrdma_parm_table[] = {
 	{ },
 };
 
-static struct ctl_table svcrdma_table[] = {
-	{
-		.procname	= "svc_rdma",
-		.mode		= 0555,
-		.child		= svcrdma_parm_table
-	},
-	{ },
-};
-
-static struct ctl_table svcrdma_root_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= svcrdma_table
-	},
-	{ },
-};
-
 static void svc_rdma_proc_cleanup(void)
 {
 	if (!svcrdma_table_header)
@@ -263,7 +245,8 @@ static int svc_rdma_proc_init(void)
 	if (rc)
 		goto out_err;
 
-	svcrdma_table_header = register_sysctl_table(svcrdma_root_table);
+	svcrdma_table_header = register_sysctl("sunrpc/svc_rdma",
+					       svcrdma_parm_table);
 	return 0;
 
 out_err:
-- 
2.43.0



