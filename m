Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCF3386C21;
	Sat, 12 Sep 2026 09:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204651; cv=none; b=Vz51bKbGA+PAv2RFvKQfBA8WrSNl6Gd2Rt80WQsLRu3F/DKeCp4HIAyuIO5SKqju8T4ay+PRqnYFbBbpL0ECMlkiuGRmgVPIzRBmxkTzIBS4hMxwZ8ANbVK7BkWCiBGz7ojeuNJNyR12JlmMxKUiG3vC9vo9HjGELgvfBotfC9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204651; c=relaxed/simple;
	bh=+jq5vzW/dSUi+cWikD+wKHh6/bl4IbrfLfYm1CiboFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAiPUy/37vzcUMsl2vbp9hnDkWi5vMOv+ZvIbJ1KAup070DvdSyN8tr4QTyGMxvrJVtfClO1Q4WxonW3kFXKBIoKAEOWgEF3oXaBCfwMQTlF/h/kgTJ2aKXhA1I4gY3nxl28uP4rXSQCLgH1/Y8WCPV1xk6oFcmFkiuvvZrkKdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9wfqLdd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9wfqLdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9511F000FF;
	Sat, 12 Sep 2026 09:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204649;
	bh=iUM+oeLbxN+KQayPdWHm8mtl8d6UlpB+apOzoKHtfvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9wfqLdd9/NeTqr5QxknRkKnOBVu60ntOdwG+AXrAnx7vLgvJTwR3crrjqiDohmes
	 HQuBw8XBfMVOWxrWthiZ/SAuUV1YUwbYJw1PRwOErkhDfsNVd0o1UOHBugxlHszmSA
	 Fz+yeR90SlVGpO2nnAtHpAwb9cHYsw5pFO6Uwq1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1657/1815] RDMA/ucma: Allow path records to exactly fit the output buffer
Date: Sat, 12 Sep 2026 08:56:47 +0200
Message-ID: <20260912065727.892230392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ac29dfa69bb3a..4929636f7c531 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -951,7 +951,7 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 
 	resp->num_paths = ctx->cm_id->route.num_pri_alt_paths;
 	for (i = 0, out_len -= sizeof(*resp);
-	     i < resp->num_paths && out_len > sizeof(struct ib_path_rec_data);
+	     i < resp->num_paths && out_len >= sizeof(struct ib_path_rec_data);
 	     i++, out_len -= sizeof(struct ib_path_rec_data)) {
 		struct sa_path_rec *rec = &ctx->cm_id->route.path_rec[i];
 
-- 
2.53.0



