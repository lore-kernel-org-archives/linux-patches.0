Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C0222969E;
	Thu, 12 Dec 2024 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022523; cv=none; b=HnY50GOrijiKSyPUW1DheAh0aU46QSZtE441MRGyrQFhCs6Yi5xvgdUK/Xu+CM9hWQGMwcvMNgqAJ3FY5Hlp5iTTwLQuFRDBWpMUO9DRJAo9hjFA60oWqP5EI0WWbBsu6wEaqJl4ARjt138h+TRtB7slkTbYwE+6rwnXkbZlH0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022523; c=relaxed/simple;
	bh=N7o0i0QyGuHNIOQFoRUnaC/yr9/5viZgsjfg9zxxwk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4M05qr+fnajrxH7ksgSSlJeiOBRBVdV3fGEEKShb3ii+h/wzmTYSJnQIKOWXia7lovUNnwYgsbjNmBJadXZReTXXNOiMlc49lPJzLwDxAkNMeBbzZUpWOPZ0zj7YvGbi1ZCxjKe1ZOWLmBOAyk/GRfIa1wR4gbp9fgZM7kTgG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIAlyecH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIAlyecH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DFCC4CECE;
	Thu, 12 Dec 2024 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022523;
	bh=N7o0i0QyGuHNIOQFoRUnaC/yr9/5viZgsjfg9zxxwk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIAlyecHvoqxq6UlJt965O8Dcsjpvvm1OYNdI2Tz9wTb9FkEYUcd0hTC2Dp8MyD1b
	 /UCbdXW1pdim2A4Qn60Gcz7m5JGz/MNqHxk9wrFTc3q7oHFmK9yTMJvJv/jNG36h+n
	 ova+9Da1kH+e4sMHXk8/yLV5UwEjqr+qLLR7CdWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/565] sunrpc: simplify two-level sysctl registration for svcrdma_parm_table
Date: Thu, 12 Dec 2024 15:57:40 +0100
Message-ID: <20241212144321.940792702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



