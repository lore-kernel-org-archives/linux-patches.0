Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F50F30649D;
	Mon, 13 Oct 2025 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369153; cv=none; b=BGrpAMXOWQFZIUbzczAAnGfrJya7RKfaj6BNq9nLlZz5VGJJOgHIa3nPDXFqhwVwfRJP+sjPDm5YYCH1zFQX2fUcVNcXF+uqkLUF7u18I0A1cvADebIC6jtP9eVnUgEnLvSsG4KSFjBXnw6U8EYmiv419i6ryL7aIv5247tNl40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369153; c=relaxed/simple;
	bh=CFgMW5eP2rhhUs1JU8wMr3H4k0+aZZTxs7QDY5Yyri8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g00nyUFJvzs5Jo+75zY0o4GM0siOqDWlmewXiTmqW6lZY/XSAQcKDVmw61IWoPnm5mH47i1SZDfTILFrGGkG11aJLeGqlMlLOEzVmNqZuEgX1o7kGGGkfSpieMeRnbmpMYwERY1AaLSLL2o12hppjJIj6R7zyg8gwW2iVNtkH+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvGh7OpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvGh7OpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A37C4CEE7;
	Mon, 13 Oct 2025 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369153;
	bh=CFgMW5eP2rhhUs1JU8wMr3H4k0+aZZTxs7QDY5Yyri8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvGh7OpPIIO0qSrBYXU5OHctWfMuScPQT1iyX07oIwy/eidqwpl+CpOt/IwRrphC2
	 FBY+Q3nNyCzIzc3zlNgGSvW3lbTdRNuoTgKRlni2e7m9+LdUcxtxoEJ55WZdCz/LJH
	 msLsNf/1u5nWnEU07TQaepyfZABYa3EheKJVGCJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 146/563] mmc: core: Fix variable shadowing in mmc_route_rpmb_frames()
Date: Mon, 13 Oct 2025 16:40:07 +0200
Message-ID: <20251013144416.580088376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 072755cca7e743c28a273fcb69b0e826109473d7 ]

Rename the inner 'frm' variable to 'resp_frm' in the write path of
mmc_route_rpmb_frames() to avoid shadowing the outer 'frm' variable.

The function declares 'frm' at function scope pointing to the request
frame, but then redeclares another 'frm' variable inside the write
block pointing to the response frame. This shadowing makes the code
confusing and error-prone.

Using 'resp_frm' for the response frame makes the distinction clear
and improves code readability.

Fixes: 7852028a35f0 ("mmc: block: register RPMB partition with the RPMB subsystem")
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 9cc47bf94804b..dd6cffc0df729 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2936,15 +2936,15 @@ static int mmc_route_rpmb_frames(struct device *dev, u8 *req,
 		return -ENOMEM;
 
 	if (write) {
-		struct rpmb_frame *frm = (struct rpmb_frame *)resp;
+		struct rpmb_frame *resp_frm = (struct rpmb_frame *)resp;
 
 		/* Send write request frame(s) */
 		set_idata(idata[0], MMC_WRITE_MULTIPLE_BLOCK,
 			  1 | MMC_CMD23_ARG_REL_WR, req, req_len);
 
 		/* Send result request frame */
-		memset(frm, 0, sizeof(*frm));
-		frm->req_resp = cpu_to_be16(RPMB_RESULT_READ);
+		memset(resp_frm, 0, sizeof(*resp_frm));
+		resp_frm->req_resp = cpu_to_be16(RPMB_RESULT_READ);
 		set_idata(idata[1], MMC_WRITE_MULTIPLE_BLOCK, 1, resp,
 			  resp_len);
 
-- 
2.51.0



