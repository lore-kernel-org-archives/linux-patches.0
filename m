Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2291494D9;
	Fri,  6 Dec 2024 14:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496155; cv=none; b=JB9mE7aE9LOj3ETLVkKy9w5U/kr6OPxF9pHBsMsnXotim/vB7yoij8oa6QMtKAu1Y8iKHdp+ucsM204w/RP7KH5CnV1Zgp6QnUuwuHoY1bBL27q9dioY7JCfnkfoyYPf87lU4glWmEXcg6AfZ9Af9btxL7EKsyUBQAjfXv0V/Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496155; c=relaxed/simple;
	bh=ddbBwfIdwpOJ0/iFCTD4KmIWHIXb8i6sfOGuxQqHuAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6V3svLqgQO2Cfoj12fMqCPrn4Daj2K0vEk0LmXBlnA0FBTNFIXroSvjTKkIKIKReXMGI5jaE7xiaF3ft0lwx6lZpuCkQddYj2CZhFpE1CpNdNLBhk9aH4TWM7CGGatSnRwkIzsL1ff6tZ8psVP23Hxb34DyydVPiiHXL7K5lek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slpo63U7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slpo63U7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748D0C4CED1;
	Fri,  6 Dec 2024 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496154;
	bh=ddbBwfIdwpOJ0/iFCTD4KmIWHIXb8i6sfOGuxQqHuAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slpo63U7e9lrgTWcCrzurVHUn11Qhrl6S18jXVHmpZCuTnLf7MCaUmQsApYGSf8bR
	 4Bz/eDl/yk4hfreQWnvP05bL6q/0zftyLsBM4PIlvjokuaBzGCOGAeisyLA4SDP0eE
	 mIsrKmrYKcE7dYxMByds5w2w3CyE15kx8OaJwAQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balaji Pothunoori <quic_bpothuno@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 067/146] remoteproc: qcom_q6v5_pas: disable auto boot for wpss
Date: Fri,  6 Dec 2024 15:36:38 +0100
Message-ID: <20241206143530.246332139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Balaji Pothunoori <quic_bpothuno@quicinc.com>

commit 8a47704d64c9afda80e7f399ba2cf898cfcc45b2 upstream.

Currently, the rproc "atomic_t power" variable is incremented during:
a. WPSS rproc auto boot.
b. AHB power on for ath11k.

During AHB power off (rmmod ath11k_ahb.ko), rproc_shutdown fails
to unload the WPSS firmware because the rproc->power value is '2',
causing the atomic_dec_and_test(&rproc->power) condition to fail.

Consequently, during AHB power on (insmod ath11k_ahb.ko),
QMI_WLANFW_HOST_CAP_REQ_V01 fails due to the host and firmware QMI
states being out of sync.

Fixes: 300ed425dfa9 ("remoteproc: qcom_q6v5_pas: Add SC7280 ADSP, CDSP & WPSS")
Cc: stable@vger.kernel.org
Signed-off-by: Balaji Pothunoori <quic_bpothuno@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241018105911.165415-1-quic_bpothuno@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 5034d214ac13..96da94b5d2c2 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1356,7 +1356,7 @@ static const struct adsp_data sc7280_wpss_resource = {
 	.crash_reason_smem = 626,
 	.firmware_name = "wpss.mdt",
 	.pas_id = 6,
-	.auto_boot = true,
+	.auto_boot = false,
 	.proxy_pd_names = (char*[]){
 		"cx",
 		"mx",
-- 
2.47.1



