Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746F53D75DA;
	Wed, 20 May 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298029; cv=none; b=Bw+DG0zsqf9FkbdlGPQ9othwVyyFrv+CFjHia+/sysnm2dPWuk4mDODPrQ/ESrcSwOdiMv74I3jTJ7loqEBB6oWje8PYYuxHBr6AL0Od2V+/bGMGjN5T3jtditcJuaWossEK0AncwnLlgM+/7mhDEXsvbggpAoqv9GNZr620QBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298029; c=relaxed/simple;
	bh=6lTilhFJUACOG1QW5K/hsvHR7TEcC8dVe2GhORPYvyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHlREopQ/0dSZzhTbgcnVimsOUMD0/+QWBlYui3lbZ0OC9WGn+sgmplAVxC7vH696J1GI5THb1Nnv7uo0bqgLy1FsStk+P3Pqz5TEap+EJhrTMKoOieqRXL682zKScdoa1S5nno5lEtPMy4L8cL8o/B3aPJCDWOJ0fRuqm+xoFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyIRE4I3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyIRE4I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E101F000E9;
	Wed, 20 May 2026 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298028;
	bh=IDirwOMY8xXSKlqWzIU4d6EtxpFGW9P8n5ZwszIllbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyIRE4I3UEXyNXN0FdMmta4xf1OSz9miRS9P8QzeOR2hT5booyg1qHZUQXecM6fsy
	 US/ucQYLZQHaNbqhblzy+KVnPpcDjDfjXeAxpwtNUyl/nyh2jg+TIF72BRjpXLnrAp
	 W0SWoKnFdsA3rpRW0bXx1Cqe/qTKOPHhBv0qczQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/957] crypto: hisilicon/sec2 - prevent req used-after-free for sec
Date: Wed, 20 May 2026 18:12:17 +0200
Message-ID: <20260520162140.051933147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Wenkai Lin <linwenkai6@hisilicon.com>

[ Upstream commit 67b53a660e6bf0da2fa8d8872e897a14d8059eaf ]

During packet transmission, if the system is under heavy load,
the hardware might complete processing the packet and free the
request memory (req) before the transmission function finishes.
If the software subsequently accesses this req, a use-after-free
error will occur. The qp_ctx memory exists throughout the packet
sending process, so replace the req with the qp_ctx.

Fixes: f0ae287c5045 ("crypto: hisilicon/sec2 - implement full backlog mode for sec")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index c462b58d30343..2d0b248c59ebd 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -230,7 +230,7 @@ static int qp_send_message(struct sec_req *req)
 
 	spin_unlock_bh(&qp_ctx->req_lock);
 
-	atomic64_inc(&req->ctx->sec->debug.dfx.send_cnt);
+	atomic64_inc(&qp_ctx->ctx->sec->debug.dfx.send_cnt);
 	return -EINPROGRESS;
 }
 
-- 
2.53.0



