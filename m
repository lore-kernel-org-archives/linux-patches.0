Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D725F14A088;
	Tue,  3 Dec 2024 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241803; cv=none; b=gbEak4lBZuVFK5rUoDaO0ecjR7b2EzqYtrYI8WVepOnVmnjChBKNSqJtc7afw7XNMB89S3Q0FKtd1jJam9aHbTU5Qr5pwV9ft7Ww+EG5/nP+xmSQMo1yjVqSvVL9YRlIgMzXv0p/HFC2hmAmVTOLPfsHEa9pmxW6wqOinVERKvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241803; c=relaxed/simple;
	bh=s/01cRAyXFeeo1kI7/75JJgyvX1DpU1/VTAxSmUNXA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co7SPBhIKrppn/Zei72sI0IcvmD+dHM/mgt9IQGJuDOX9FOvltEVmXssTRDXRn0iiJigTsNP9zM3XRoPL4BcQ1ZvwrrVfBTdCF2Pm4yX41zkiexgS3VTYhGaZUCmA2Xds5X6qONDjqXLROeHV2Th+2rI+QHaIuBK7ZakC2mrR54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3eRN1IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3eRN1IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53057C4CECF;
	Tue,  3 Dec 2024 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241803;
	bh=s/01cRAyXFeeo1kI7/75JJgyvX1DpU1/VTAxSmUNXA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3eRN1INi2YE3ew6NrEwQgOuSxHSi0UJcWTMy5BrjWupw56rp0mQ2IqoOuXcoSYd8
	 j7zylYhQ9vAmaFDv04EHopIKAxv2xVCfxIV6+cadoDjdpEp6OijkAqUxcjbR2R58iR
	 CfyVIqnFolt26QslP19xqvABsTq56tqr/DhPaxVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 522/826] rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length
Date: Tue,  3 Dec 2024 15:44:09 +0100
Message-ID: <20241203144804.123342435@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 06c59d97f63c1b8af521fa5aef8a716fb988b285 ]

The name len field of the CMD_OPEN packet is only 16-bits and the upper
16-bits of "param2" are a different "prio" field, which can be nonzero in
certain situations, and CMD_OPEN packets can be unexpectedly dropped
because of this.

Fix this by masking out the upper 16 bits of param2.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007235935.6216-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index d3af1dfa3c7d7..a2f9d85c7156d 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1204,7 +1204,8 @@ void qcom_glink_native_rx(struct qcom_glink *glink)
 			ret = qcom_glink_rx_open_ack(glink, param1);
 			break;
 		case GLINK_CMD_OPEN:
-			ret = qcom_glink_rx_defer(glink, param2);
+			/* upper 16 bits of param2 are the "prio" field */
+			ret = qcom_glink_rx_defer(glink, param2 & 0xffff);
 			break;
 		case GLINK_CMD_TX_DATA:
 		case GLINK_CMD_TX_DATA_CONT:
-- 
2.43.0



