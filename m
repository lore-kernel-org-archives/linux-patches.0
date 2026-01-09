Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D63632AAB5;
	Fri,  9 Jan 2026 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961142; cv=none; b=ZGBJRMGGVqfRiYQtxo7StarbsoEHCD+OljF81HPjblfZZTQEz5WP48VFu8dxxjHuHvWg+NQjUUEiDT4rpfLalrLb/hZDRkVdwMd3D+Mv2Ku9r8TwBZ+kBtLEgKV6Tatc6t0UQh8omzrREoLCzirWJaC9lq1yuYuKCEKlwe5u1n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961142; c=relaxed/simple;
	bh=FGQQYItcNKNyD/QRCY8pkPRPZTuJmrEnbWjgZd4eYGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGgvE/4PCk/IvyuLkyjUy9nnocpeji0FNNWi/Y0/y0OBNanxqLMCdu5AASai+CEbrC3/aqo+zdVu1f1Dx6ocoWMewK7NPksNx6ihhwkMXowKlo8CVY57TpdVv+FIa/kBUVjP3+33hFaBMz4z2eQQ5fWQhAQShPh3q9ul5Ltojqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BNj0Hsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BNj0Hsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2975C4CEF1;
	Fri,  9 Jan 2026 12:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961142;
	bh=FGQQYItcNKNyD/QRCY8pkPRPZTuJmrEnbWjgZd4eYGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BNj0Hskb3Q1nk1rHRCNdpOX9fdhEDMY7vm5eAZRS9c6pYIAZtbHKJ2Y9hBk2SLrk
	 UsHs3GXOZ5uA+XnFwSmEvwz16KKgl8wkVZ/xz8OIUnMRDsod3of5PSjyekc8uAD0XJ
	 qdIP5oWdC61QgsI508FarNkcUd22qTe1ZS0/KYXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 650/737] svcrdma: bound check rq_pages index in inline path
Date: Fri,  9 Jan 2026 12:43:09 +0100
Message-ID: <20260109112158.472084245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted rc_curpage and rq_maxpages fields to ri_pageno and RPCSVC_MAXPAGES constant ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -815,6 +815,9 @@ static int svc_rdma_copy_inline_range(st
 	for (page_no = 0; page_no < numpages; page_no++) {
 		unsigned int page_len;
 
+		if (info->ri_pageno >= RPCSVC_MAXPAGES)
+			return -EINVAL;
+
 		page_len = min_t(unsigned int, remaining,
 				 PAGE_SIZE - info->ri_pageoff);
 


