Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1902725C818;
	Tue,  6 Jan 2026 17:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721320; cv=none; b=jukIi42PrQp+XEg8Xp9EM018w0jgASuWd7Lj0wZjCtfWyJmxEzugZ2/W/Vd7sJWn8AuBWHbFePGinpx3cDLvSkBwFRcsWqaWIx2+GX9Sfb+xpLZFQOZgGqmcgGd7sBJ308h0iVHfio0gE40h7l1P2llEJKsOsSyTbhNAq4UAW3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721320; c=relaxed/simple;
	bh=Iz2OfuyBCjMqgC/C39pJB1evN3NwdLN5cT7ga2KhMo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCwAd9tgH8of4wNxrExsGPnIRDXbfbqwPQEmqv1+BcNy9oJzHEFlu75hBlv2gtO0SByn1b3OU40UW4T2/cXEWjhzx/6na87/4QvjWTQfHNg4CsUwJjLrO3gwohPz5dhR9EDPyFpyoOm1QyaDPmG7Xt6insn0GO7iDaokVv34I2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vP0OU/S8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vP0OU/S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC46C116C6;
	Tue,  6 Jan 2026 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721320;
	bh=Iz2OfuyBCjMqgC/C39pJB1evN3NwdLN5cT7ga2KhMo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vP0OU/S8RvhKKZFX4iQJMV8KnOVQ2qitrqmPb7MHrorB3yMMxyotgaqI1q7WMvRps
	 f+ID9QVP6oXcO+ICX+k+lCfpuUnoAFfD4ePtjl3o0U0NRfYFX+Hcw+viocq0cri4yA
	 tekjhMpwnjRebR7pLZiFqwmP1Rd6IrjxUJUD7FNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 502/567] svcrdma: bound check rq_pages index in inline path
Date: Tue,  6 Jan 2026 18:04:44 +0100
Message-ID: <20260106170509.939347131@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

[ Upstream commit d1bea0ce35b6095544ee82bb54156fc62c067e58 ]

svc_rdma_copy_inline_range indexed rqstp->rq_pages[rc_curpage] without
verifying rc_curpage stays within the allocated page array. Add guards
before the first use and after advancing to a new page.

Fixes: d7cc73972661 ("svcrdma: support multiple Read chunks per RPC")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ replaced rqstp->rq_maxpages with ARRAY_SIZE(rqstp->rq_pages) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -841,6 +841,9 @@ static int svc_rdma_copy_inline_range(st
 	for (page_no = 0; page_no < numpages; page_no++) {
 		unsigned int page_len;
 
+		if (head->rc_curpage >= ARRAY_SIZE(rqstp->rq_pages))
+			return -EINVAL;
+
 		page_len = min_t(unsigned int, remaining,
 				 PAGE_SIZE - head->rc_pageoff);
 


