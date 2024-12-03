Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDF31F130E;
	Tue,  3 Dec 2024 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238396; cv=none; b=C7dqC7C1k9ufencXyBd2oMlyYIYyTcR/ecSXHOcYKmCupENmfLxNEGSugBF3CxxgBfmkj/xX75PUh1uF017In4B3SpswF6z2MVJso7MOSPeVkY9MyS2pma4E40eVbU76wtjOqNzvKqKRA1W7SgPHf4WQTuTNCA/PAdtcieEml8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238396; c=relaxed/simple;
	bh=8vv6Ch5QOBNoHOBMZcMbz1Cj0/MXTHUtx1kZ+V3ld9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkCbsxvnvG+uS6dEXCR5QwPu+GuBwVh7SE/A8R6A9rlSnzmo6RsgweHtU/1wwPxl1Cyyt1p4dvJukW9P6OqZj/C0OzLR+3tuDnTUlTwl01SbaWXfDI2ZOgKbRkEy3zf8zIBbDYju1Q2R7xK+HNF4POv8DZD+p9zisqpQ45Pn+Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh1R3CWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh1R3CWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C3AC4CECF;
	Tue,  3 Dec 2024 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238395;
	bh=8vv6Ch5QOBNoHOBMZcMbz1Cj0/MXTHUtx1kZ+V3ld9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xh1R3CWQvO+ROgvE35P2p6U143rK3TxOhODOVlPS6r9ljJSOaLx4lnBcrW01Vt+R8
	 hrkbYdzHDHLmna4w+1NnkYl6eiURAZoXiYPSIaN/pz1HN8u58mMafJ1584Xr5PMkUg
	 U3iRzIaF+ORpRcXDWnU9J8sMlcuRUhQ0W+8rRs54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balaji Pothunoori <quic_bpothuno@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 262/817] wifi: ath11k: Fix CE offset address calculation for WCN6750 in SSR
Date: Tue,  3 Dec 2024 15:37:14 +0100
Message-ID: <20241203144006.015806047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balaji Pothunoori <quic_bpothuno@quicinc.com>

[ Upstream commit 4c57ec6c4bb9979b42ae7fa7273fc2d4a361d576 ]

Currently, mem_ce and mem iomem addresses are used to calculate the
CE offset address. mem_ce is initialized with mem address, and for
targets where ce_remap is needed, mem_ce is remapped to a new address
space during AHB probe.

For targets such as WCN6750 in which CE address space is same as WCSS
address space (i.e. "ce_remap" hw_param is set to false), mem_ce and
mem iomem addresses are same. In the initial SRNG setup for such targets,
the CE offset address and hence CE register base addresses are
calculated correctly in ath11k_hal_srng_init() as both mem and mem_ce
are initialized with same iomem address.

Later, after the firmware download, mem is initialized with BAR address
received in qmi_wlanfw_device_info_resp_msg_v01 QMI message, while mem_ce
is not updated.

After initial setup success, during Subsystem Restart (SSR), as part
of reinitialization, ath11k_hal_srng_init() will be called again,
and CE offset address will be calculated incorrectly this time as mem_ce
address was not updated. Due to the incorrect CE offset address,
APPS accesses an invalid CE register address which leads to improper
behavior in firmware after SSR is triggered.

To fix the above issue, update mem_ce to mem iomem address in
ath11k_qmi_request_device_info() for targets which do not support
ce_remap feature.

Signed-off-by: Balaji Pothunoori <quic_bpothuno@quicinc.com>
Fixes: b42b3678c91f ("wifi: ath11k: remap ce register space for IPQ5018")
Link: https://patch.msgid.link/20240927095825.22317-1-quic_bpothuno@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index f477afd325dea..7a22483b35cd9 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2180,6 +2180,9 @@ static int ath11k_qmi_request_device_info(struct ath11k_base *ab)
 	ab->mem = bar_addr_va;
 	ab->mem_len = resp.bar_size;
 
+	if (!ab->hw_params.ce_remap)
+		ab->mem_ce = ab->mem;
+
 	return 0;
 out:
 	return ret;
-- 
2.43.0



