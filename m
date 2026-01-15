Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924C43D1CB7;
	Thu, 15 Jan 2026 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498496; cv=none; b=E3YNnNcCKwYJ/HOxbh3XWFT5T3pUyQ+zRuiJyenrAiH6a82XX1rOSX/M78q5ayPlHNnpsAnvTepMvD859QWmXeSaOAkQuuQZm8V6MwNN2SZCQ77z5SI3LXew++HwBEArGTUxWUMMfH0Pa8LAERW3GE5LC5GbYWjrSfOoLxWHJsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498496; c=relaxed/simple;
	bh=ysOhnYgZchjQaDnAmcGIT+Jo6btsaJUKJqba6AMbfyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6Sh6Bdfl0FONz9c4PeaMcKQuGI3Pkwu/vtV1u/gpE2UUyf8/KTUmlWFPN3e1mQxdM4lHyUAvrMyLCaVkgj4swK18ONXMv7MMHj9iJ1r9s+FOTDDcvN0v8ZmUjMjLb73JGUh5P3Ka8HJb38nO8DDxeD2aDjl59uWt6bKdjYCzpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOkGIcZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOkGIcZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFDFC116D0;
	Thu, 15 Jan 2026 17:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498496;
	bh=ysOhnYgZchjQaDnAmcGIT+Jo6btsaJUKJqba6AMbfyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOkGIcZ9YcFotkDHNC900TqF3h7S89J8Jc8hnJfuWCeq64Yvpn6u28Bd6c2v5+VmO
	 ZaDiY6yhp7t7qCEv3pffnI/w9vZYIsY/NNReO1lKHfO2xpMdOs1lFIkyKgXJRZ4n2s
	 NCWLVYk0srM5kCbU8RUiP8dFJFe8/zSLC6Dbiajc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/554] svcrdma: bound check rq_pages index in inline path
Date: Thu, 15 Jan 2026 17:48:37 +0100
Message-ID: <20260115164302.595433406@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -789,6 +789,9 @@ static int svc_rdma_copy_inline_range(st
 	for (page_no = 0; page_no < numpages; page_no++) {
 		unsigned int page_len;
 
+		if (info->ri_pageno >= RPCSVC_MAXPAGES)
+			return -EINVAL;
+
 		page_len = min_t(unsigned int, remaining,
 				 PAGE_SIZE - info->ri_pageoff);
 


