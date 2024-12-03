Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A410E1FA16B;
	Tue,  3 Dec 2024 15:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240786; cv=none; b=TN4BuM3ZPW72vqvnKNtTbrurbvPNVUiKYliNCK1oXanwjWPALFK8mFkYmrFuqvu+JZ6ZFpQCmh4utc3Ipb1XoZKitEo00KXiWOxVZS7tts4EnKxsGZ0L7S2eheACEaxhKBh9XtbtPxS3rQ/XUJ6KA3PZzGWIsIaukF+BQhSZQZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240786; c=relaxed/simple;
	bh=gbA80Bv/j88v4Jl/c3eDtPCUe+o4Y1DXGjY3PgIeRtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbA0xsED1HgI8WNvku2FYCKpW139Dn2rNm/PbtYN3kyG/OzcMFbDYkw9aBEQaIGO9QGwidQUyZ4nqz+wOsNntek8/mZDIa7HbcqdUAzJATv4BQyVPIuj3uLMKnBI3H8O11X6KI0ooxGEb6f1jcBluMcBwYmKbgDVY8iSiXrVGy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUg1fgXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUg1fgXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D96C4CECF;
	Tue,  3 Dec 2024 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240786;
	bh=gbA80Bv/j88v4Jl/c3eDtPCUe+o4Y1DXGjY3PgIeRtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUg1fgXp7/4NmxP4Ke2IbN/G3n4i0u6m4NRXpkNfBwUNPeGqzn+WULb1lRE5nb9kw
	 Jj81YOmVq4dM76/yUS4fADXiAxXkhoElNzknCsEd0S/5NT+XB47VlCpji6x05/tTIk
	 zqTt8ZNNCdTssBjCvoucg7+UJ6jQjwPER8tAISQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balaji Pothunoori <quic_bpothuno@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/826] wifi: ath11k: Fix CE offset address calculation for WCN6750 in SSR
Date: Tue,  3 Dec 2024 15:39:20 +0100
Message-ID: <20241203144752.839825240@linuxfoundation.org>
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



