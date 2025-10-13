Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98529311945;
	Mon, 13 Oct 2025 15:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368153; cv=none; b=AYEeslYhiAvfG3iLSTIYTeMbgNHFFGLycbqWEM8Q2DXmCLofL1pPngC8jdPurO9CgfuEBelldIZQQK1YFX14zQWVl9fBPf5nx+kwk/2QH/Vh1zpR3/Y8xPwF3fyxum5HkMcsRNoVebxuRiDbs4/v1wh5Fz8v3np6dCVRXPbyQwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368153; c=relaxed/simple;
	bh=yLHX+tCEAkzMlUx6ZnXWpRIuxACtz0XSb1zqMiYflTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6iiwNq2kLhT3bFuTkUXhmkMOzCKXEJP2j3QueFH/4QfuG0A15CnbnZmV99hDwbq+Gy5pF/UapxqRLx35jKJZcA8EErCeFfCQs7y7ABvVpDRIF320etV5mg1b99CNC0uUVOQc7/uDS8IKBpC8GtifaynthtboZRSVMVCDdFMi9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fv5R8t+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fv5R8t+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B76C4CEE7;
	Mon, 13 Oct 2025 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368153;
	bh=yLHX+tCEAkzMlUx6ZnXWpRIuxACtz0XSb1zqMiYflTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fv5R8t+eze5DP32hwU1Hf68qaPYvdYcBIGd4/yzeUKrDh9RRtlIna7/OyEPaCi1NT
	 WDID9E0G1U42EGsLZA730xHCe6U8HBCDFmaKI0fTy3kMfHSikzvib1n7yw/KAdwBz4
	 fRFToQSPC7U7QtZWidaqZAoAQJL1+JVlrkWJVM7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/262] mmc: core: Fix variable shadowing in mmc_route_rpmb_frames()
Date: Mon, 13 Oct 2025 16:43:23 +0200
Message-ID: <20251013144328.326001766@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 1d08009f2bd83..08b8276e1da93 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2876,15 +2876,15 @@ static int mmc_route_rpmb_frames(struct device *dev, u8 *req,
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



