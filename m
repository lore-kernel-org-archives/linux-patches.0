Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89D134CFD6;
	Tue,  6 Jan 2026 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720484; cv=none; b=KJciMJ5buXe+O9D5G1h8HC99kq1VTxEcIwVjPHCXBQuYkrX2dvmpRzOD8zqlUEFmb3wPWNOo0KhN+ZI0J4OtqLxx23I9zqvpRaAUYOGw16EtQec2T47kSiwvN5Tl6VYEhpaxFUkBhhOTpJSWJk560RPLR93zAYHPOtcciLi6AYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720484; c=relaxed/simple;
	bh=Ldt1GJ18TmkIoNIhTPPk6vmtYI0lvQLJ85IZ38UBNO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD1sU8c2LcDJZVZ2nSPRYQ+grGWVD4rE8lIcsiW6M2jyUEk+wLj3kCUgbcoxrvaVl0W5uccJPR9y6fsbcL/1A3DACdYVOPIF5W9o8xDMrTOfAp/gIjwsPecNT8gBZhfPqkybA2TBOO+dQLwpnleTSN1YfPDi+1x65CNHHVOZTVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znJCbD71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znJCbD71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E32C116C6;
	Tue,  6 Jan 2026 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720483;
	bh=Ldt1GJ18TmkIoNIhTPPk6vmtYI0lvQLJ85IZ38UBNO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znJCbD71LeJq4RcvpDhz4VV565YQPRMnLMzxqj7FBFVTmylsRMcU5W4b2awo448C+
	 0kgMLb/2fg+tbhfGecDxcj/mSEHs4V9hVVbnXrmeTes7RGIb0MPtT1bcEBLEDvjRdI
	 t2EQvxmmhu+gE0UouUHbgboWxVP3blnb7skkUB18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 243/567] svcrdma: use rc_pageoff for memcpy byte offset
Date: Tue,  6 Jan 2026 18:00:25 +0100
Message-ID: <20260106170500.304811729@linuxfoundation.org>
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

commit a8ee9099f30654917aa68f55d707b5627e1dbf77 upstream.

svc_rdma_copy_inline_range added rc_curpage (page index) to the page
base instead of the byte offset rc_pageoff. Use rc_pageoff so copies
land within the current page.

Found by ZeroPath (https://zeropath.com)

Fixes: 8e122582680c ("svcrdma: Move svc_rdma_read_info::ri_pageno to struct svc_rdma_recv_ctxt")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -851,7 +851,7 @@ static int svc_rdma_copy_inline_range(st
 			head->rc_page_count++;
 
 		dst = page_address(rqstp->rq_pages[head->rc_curpage]);
-		memcpy(dst + head->rc_curpage, src + offset, page_len);
+		memcpy((unsigned char *)dst + head->rc_pageoff, src + offset, page_len);
 
 		head->rc_readbytes += page_len;
 		head->rc_pageoff += page_len;


