Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E953A2576;
	Sat, 12 Sep 2026 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243397; cv=none; b=dvfCe6m5MFNG2G7H/B0WJz1IO9mHFBkIF6L/RBZmanBncGfUMa+rz/h7m2tM9y4UvGd7CzsT5NgH+zMgiP7SrxPIPrve5KxfC4gi87sEWQxCNtw2e+shll1gjSnx+AVIAyIHQrA445WOJntcdKPrW6GSOwZFjnDdbpL7uCiO3D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243397; c=relaxed/simple;
	bh=IUK4Z+hffcZOjaeFpSlav2lp/uVNhtdU/dj+cU2f8qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfNwzuC+NGCK4pvVLFMDcjoxgYEMWleTQsd1PrbZQfbLs3+LoyQ9AG3PcT0f4MrJV0a5Aixz/pvNt102pyQFRYF01dtYty5ljbso1XKrStG8johRkHVa5/TxRGk5JrWN7jRe1wrqfv3GwBcKL+AzmTmjs6ldBLv2zHx9mq0yLFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWIlLIaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWIlLIaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0CF1F000FF;
	Sat, 12 Sep 2026 20:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243396;
	bh=n207kSqf+FWz5W+5Qs2C9EnWQXBGs8l4G0SlNmgorew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SWIlLIaaE06rcwzhYI1SMyC9iUYbkwLXPkF1uWt/2Qk+UKjmOk4SippQyZNc/Xebx
	 iTFUArfEIPd5VB9XKPNQLsh2RrCrkOxDUNGPwwTzRnHUUHGY4/QEsiJAdk2rNSm8j4
	 Mu4WmiwEEdHZ02gnMu4/RHwdlyiNc5ocNqP2ggXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 739/798] RDMA/ucma: Allow path records to exactly fit the output buffer
Date: Sat, 12 Sep 2026 09:06:07 +0200
Message-ID: <20260912065534.012257561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 8049741ac93acd3a590dac070e12571fddf0e294 ]

ucma_query_path() emits a path record only when the remaining output
buffer is strictly larger than struct ib_path_rec_data. A buffer sized
exactly for the response header and N complete records therefore gets
only N - 1 records, while resp->num_paths still advertises N. A caller
sizing its buffer for a single record gets a header claiming one path
and no path data at all.

ucma_query_ib_service() in the same file computes the record count with
a plain division and so accepts an exact fit; make ucma_query_path()
behave the same way.

Current librdmacm is unaffected because it always sizes the response for
six records while the kernel currently reports at most two paths. Other
users of the UAPI that provide an exactly sized buffer can observe the
truncated response.

Fixes: ac53b264b2f3 ("RDMA/ucma: Support querying when IB paths are not reversible")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20260806201358.147478-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index a0dbad0c00b2c..bd3a05a9674d4 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -923,7 +923,7 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 
 	resp->num_paths = ctx->cm_id->route.num_paths;
 	for (i = 0, out_len -= sizeof(*resp);
-	     i < resp->num_paths && out_len > sizeof(struct ib_path_rec_data);
+	     i < resp->num_paths && out_len >= sizeof(struct ib_path_rec_data);
 	     i++, out_len -= sizeof(struct ib_path_rec_data)) {
 		struct sa_path_rec *rec = &ctx->cm_id->route.path_rec[i];
 
-- 
2.53.0



