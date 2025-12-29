Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382D0333443;
	Mon, 29 Dec 2025 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025894; cv=none; b=qccFCZQQUbvFGx32QaMo/X1tFIAvM/nZ1YPgYMT5rnPEGpnDKv0fm1W5lKVgP4PM6DVYnu2ACP7spk66x36zTiNdETWTz/QCZTKLE9dGlTDqvsSMqdWZYhKZ55l18CObSs4e+0aBc/7MeLSFnQueDewuiNnk6CRo4N96CBVc2N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025894; c=relaxed/simple;
	bh=EIWcy+4oMOT/irC9HIlle6+cPPGqh5xrqKLrSxzvrvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECQ1UwXem+Rd2PLWwoyUeNds3txW4/x/qECCwrxare+0IiBkFlUmkws4OSaCV0t+hmuQgbjQ+c/Em/UtFYGdhtDC05spYZC65722iCEeORV0Ni6Pl8CUjolzq96jWf9PszCxMLKfdVST+hB1nKTy6IyqBp4DV+yozN549g6vBPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfe/KhLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfe/KhLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE67C4CEF7;
	Mon, 29 Dec 2025 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025893;
	bh=EIWcy+4oMOT/irC9HIlle6+cPPGqh5xrqKLrSxzvrvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gfe/KhLPrXRcdWjTbDG/E0prxbxESWubW2QenuMIREgLTEckYggkoXrBQIVIoYxgV
	 kZUp8qNBXZpVlmg+QcbNfPaqykleadAeOQ265HIZEC0PxJUKXfe/S2qAFg6nSMi9cF
	 eBww5a/wW7eiNbzIdRsS4k3dX4EgPEfCTRYCBqHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 373/430] svcrdma: bound check rq_pages index in inline path
Date: Mon, 29 Dec 2025 17:12:55 +0100
Message-ID: <20251229160738.049571780@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit d1bea0ce35b6095544ee82bb54156fc62c067e58 upstream.

svc_rdma_copy_inline_range indexed rqstp->rq_pages[rc_curpage] without
verifying rc_curpage stays within the allocated page array. Add guards
before the first use and after advancing to a new page.

Fixes: d7cc73972661 ("svcrdma: support multiple Read chunks per RPC")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -841,6 +841,9 @@ static int svc_rdma_copy_inline_range(st
 	for (page_no = 0; page_no < numpages; page_no++) {
 		unsigned int page_len;
 
+		if (head->rc_curpage >= rqstp->rq_maxpages)
+			return -EINVAL;
+
 		page_len = min_t(unsigned int, remaining,
 				 PAGE_SIZE - head->rc_pageoff);
 


