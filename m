Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFFA361977;
	Sat, 12 Sep 2026 19:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240633; cv=none; b=uxk3rE5ds6A3ssNbnbgfG2WmgtWnHSZdQ5S4Z2HnPQao0tVW1QTnw8vrnu7dQqEVo8Flmgec0ELg3DI5RGulwtVEpmyzUO1rWsu35oW1Nl3L0k8L4alM68513sXJgZtoDObfz13OiwFOVcy3jc+JsVAAw8WArd4vM+jQJIg4Vpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240633; c=relaxed/simple;
	bh=ivgXP/p718KiOwl9HIhdH+JbF/nGUraxeNrDz20As3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkE6R6zfoxKveZoKVvpt9z7cfDH8tj/tq9r0Ci8mJl2SfsyQwJlIHrCTmHDnAg/vCbStPoYUBHvBUwNiEDfUeqPguqM8GGX4xnK1ycwwjb8RYHK2obfF49xAkdZacovsfEc0BkkEblHPH+a7I99W/JvU3GNZ0pS2J0Uh6noRN+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pY91yU4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pY91yU4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A2C1F000FF;
	Sat, 12 Sep 2026 19:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240632;
	bh=cH4p98u/DX0F0P9WZyaKaQk6+i2EGg5V2njJNtr3edA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pY91yU4fuHKz+iq1QWVKloFmV72mLN+Nnceb4AJsmTHHeZ0EnMzpqN2/6YNmDDFbm
	 ntQyuPeNLyh8aZv2YrzgSZTYbHwCSE9DJ1Tf+u5eIslQP9/8O95JOFddoT4e6+HeP5
	 rd/h/Yj4/odGjm7CXTcSfcC7kx75SFcWT7loKvQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 866/935] RDMA/ucma: Allow path records to exactly fit the output buffer
Date: Sat, 12 Sep 2026 09:04:56 +0200
Message-ID: <20260912065546.682275393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index a5a012fa669ed..83850d4df80f1 100644
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



