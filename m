Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EEE157048;
	Mon, 29 Jan 2024 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548032; cv=none; b=tQVLOkbtODSibalefJGITQra4riUjOWjvIY/V+99KBXZUdNN+SKYSqjVMOZyNXuCG7me9fc7mVA41DJbGANOiOdP9pAcKhN9xJq1HxvXJSHhTXdcHcS/pjaqz53wL6uiOpWrBGrLfatajv97cVlfODHgBKrgKKpjsIlmzpkSGQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548032; c=relaxed/simple;
	bh=THt3vluOXHuSecD3+3RS+kDRTCiDclJz+Sn1jOo3T6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV5W9EZhYW8Nvr90Bez1QdegusN9+C3CnlIV8nhd7+Pr/QnAwb0gXp1OwO25nnLehF96SJeoic2WZjkg6w7bKQpu4zESEIBS5kDLjcHuSaiGkUOuwbIM7SNM9SBpbM3vmIG9BZxKK0S/NPD5WYxL23tLVyOKRTz6XJeQwhQB2eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQK3eNKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQK3eNKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A122DC433C7;
	Mon, 29 Jan 2024 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548031;
	bh=THt3vluOXHuSecD3+3RS+kDRTCiDclJz+Sn1jOo3T6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQK3eNKiGhWLfB/4QdUc5Oa8igJBAHQ2+l+nPWNFJbeS8il60EZvjFfLAddX+n/PY
	 +ZfPOmUE0qNw9vA+lajvCNNMpxS/JBZ/j+I8E4zsApoV44XBdP4w52uADz5MSR/Jyv
	 HFEUUQGzmu60v31rQCsnKmTIqxT9y3kEAq2M0Srs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 027/346] soc: qcom: pmic_glink_altmode: fix port sanity check
Date: Mon, 29 Jan 2024 09:00:58 -0800
Message-ID: <20240129170017.177619990@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit c4fb7d2eac9ff9bfc35a2e4d40c7169a332416e0 upstream.

The PMIC GLINK altmode driver currently supports at most two ports.

Fix the incomplete port sanity check on notifications to avoid
accessing and corrupting memory beyond the port array if we ever get a
notification for an unsupported port.

Fixes: 080b4e24852b ("soc: qcom: pmic_glink: Introduce altmode support")
Cc: stable@vger.kernel.org	# 6.3
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231109093100.19971-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pmic_glink_altmode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/soc/qcom/pmic_glink_altmode.c
+++ b/drivers/soc/qcom/pmic_glink_altmode.c
@@ -285,7 +285,7 @@ static void pmic_glink_altmode_sc8180xp_
 
 	svid = mux == 2 ? USB_TYPEC_DP_SID : 0;
 
-	if (!altmode->ports[port].altmode) {
+	if (port >= ARRAY_SIZE(altmode->ports) || !altmode->ports[port].altmode) {
 		dev_dbg(altmode->dev, "notification on undefined port %d\n", port);
 		return;
 	}
@@ -328,7 +328,7 @@ static void pmic_glink_altmode_sc8280xp_
 	hpd_state = FIELD_GET(SC8280XP_HPD_STATE_MASK, notify->payload[8]);
 	hpd_irq = FIELD_GET(SC8280XP_HPD_IRQ_MASK, notify->payload[8]);
 
-	if (!altmode->ports[port].altmode) {
+	if (port >= ARRAY_SIZE(altmode->ports) || !altmode->ports[port].altmode) {
 		dev_dbg(altmode->dev, "notification on undefined port %d\n", port);
 		return;
 	}


