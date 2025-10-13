Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A516A3081AA;
	Mon, 13 Oct 2025 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367468; cv=none; b=onGAecIZcv8YhyKI/19pdfCwhFfsnv8+3A/VO3R8H0RN7L4VqouFog/QyTtKRiZ++JGZLUvvTJnFM5GOyjCyhq1JF2BpBfmroYT+U31CtH5hWGzKcVMVmAtWpy1cMJ6Y9jTqhwB8t59qX4htmWtN2USIMeGWxN/R16XFmflw9fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367468; c=relaxed/simple;
	bh=NG+kSPl+tKoxbbWbKWDSdmtxFouarvH8wJ0z4odU+p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/6Z8uw9YMls8GqqZ0+85Gqdvba8xRrMpsN8bgjKD2thxRDeYnb+KE/EruYD4TkYdsQqtAmGf0z8518226b7Zt+IWSD/X4bncslARyHOp1KO6QRu5/h9bEiSRApyqSVl137LjPoGVqz203nyKhIBTVNCePXSyugs1D/q4oA6GxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AidcNs2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AidcNs2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E5CC113D0;
	Mon, 13 Oct 2025 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367468;
	bh=NG+kSPl+tKoxbbWbKWDSdmtxFouarvH8wJ0z4odU+p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AidcNs2kxsEp4Tgzvy1tlZi9vD8L2MTm49k7C4Vym01L6VY7GLsruCCbT+c6Vm1iC
	 t2l3eQaO0Mdmc3tc30UjgWiz57nWSGWk71J6T0H5M3mRkU049LKYAmzcoMueCAMSRO
	 VqehKOApOJw3/Y+W8PLjFTVw6aCwq652tBS0pjDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/196] soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS
Date: Mon, 13 Oct 2025 16:43:33 +0200
Message-ID: <20251013144315.999370723@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sneh Mankad <sneh.mankad@oss.qualcomm.com>

[ Upstream commit f87412d18edb5b8393eb8cb1c2d4a54f90185a21 ]

Unconditionally clear the TCS_AMC_MODE_TRIGGER bit when a
transaction completes. Previously this bit was only cleared when
a wake TCS was borrowed as an AMC TCS but not for dedicated
AMC TCS. Leaving this bit set for AMC TCS and entering deeper low
power modes can generate a false completion IRQ.

Prevent this scenario by always clearing the TCS_AMC_MODE_TRIGGER
bit upon receiving a completion IRQ.

Fixes: 15b3bf61b8d4 ("soc: qcom: rpmh-rsc: Clear active mode configuration for wake TCS")
Signed-off-by: Sneh Mankad <sneh.mankad@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250825-rpmh_rsc_change-v1-1-138202c31bf6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index 163a58eb02e0a..d0ec42ec0d041 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -453,13 +453,10 @@ static irqreturn_t tcs_tx_done(int irq, void *p)
 
 		trace_rpmh_tx_done(drv, i, req);
 
-		/*
-		 * If wake tcs was re-purposed for sending active
-		 * votes, clear AMC trigger & enable modes and
+		/* Clear AMC trigger & enable modes and
 		 * disable interrupt for this TCS
 		 */
-		if (!drv->tcs[ACTIVE_TCS].num_tcs)
-			__tcs_set_trigger(drv, i, false);
+		__tcs_set_trigger(drv, i, false);
 skip:
 		/* Reclaim the TCS */
 		write_tcs_reg(drv, drv->regs[RSC_DRV_CMD_ENABLE], i, 0);
-- 
2.51.0



