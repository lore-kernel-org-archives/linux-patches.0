Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638002F0C62;
	Wed, 20 May 2026 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295212; cv=none; b=uFKSeYUTiwW/Bvo9pgTycYUIKzkuicBOy4oGfUTUs2/KxjF9tEoOHe7lgsN5dXdi8haqfTFRPvWGYMdAR/sOAQL2riPPl/PR6OWhv60nciHPfBuY7Q56w0qM9K24cIgyV9rsjgDbN6DvnuEiODYTHsiaydSrji6DFDrrgSkNHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295212; c=relaxed/simple;
	bh=kM6rYfdD9PMrKRMx7WhBH27Uz+vLwXwWQwPLL2xgEas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4KygodqxolsAkRm2IbF9Z5DDaktDXkPenoZNMXOR0jceo1zNG9yX8QBRjBCy8ODWWpoClVpvj2lvxGLbZpEtLJNn94DPOzzwR5z9fMdqkYAK09/lF5gidQbXitNmt/0Gr3xReImxuJXfkfQShZuCFOWdQtYZMVnuusHYlL8SEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlSX5YHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlSX5YHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F121F000E9;
	Wed, 20 May 2026 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295211;
	bh=a523uwVaIQ964yC1SFXX8lOk/xqr2Sn3NvZYD6J3b1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlSX5YHoOAru3fmlBj/xs7MU6WYHjZiP5f5U6tEPhbDut4b6K8XWcDsuivaoWNjTQ
	 McPHlFySnJEGvJvL2iNQZZfDFQT5P0OYg/W9TS6qPO2dSiYpvzwlB2gI6q2wjVOb0e
	 d5CAxzG1287fpsI8pegqhyubyi/NxVordL6cJzgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0332/1146] crypto: hisilicon/sec2 - prevent req used-after-free for sec
Date: Wed, 20 May 2026 18:09:42 +0200
Message-ID: <20260520162155.712047498@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 15174216d8c41..2471a4dd0b508 100644
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



