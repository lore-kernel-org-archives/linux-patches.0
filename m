Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1126B1FCF5B;
	Fri,  6 Dec 2024 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497080; cv=none; b=JSpRw+jJc4g0V3rU6T5ImLF3z/foKSv5C8qAO1XdYCr6tJd09AKEhmfUYIKB7M6mAy20CCD3xYbrRZVRwwRCSaeAT6QVh8otPPmqXCM5Yns4WLXHfSn+APXHmM7GDT8nrag14yyrFBY22AOuk/9HDsCkQVgCSd5VJbSZByynXtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497080; c=relaxed/simple;
	bh=mHErOSf0DRbiYfibkJEYIFj4QYWELvKCsaXK84xImKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9dD0vi+37eVsXa7EbLDU0uf8rQXZkQujnAmxKsj7LaTSVxZXWw9WuwssqB6uILvcFQuLlSnQYVPSiXTkjO9ni6fl2AplH87qj7TS1CZnS5OuOKfs4dSjLkkw+PpzzCjnRTMN50JiMK8qvpUCnv+pPv5XoYglwGhaJG3gRZQliA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOwftHSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOwftHSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917EDC4CED1;
	Fri,  6 Dec 2024 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497079;
	bh=mHErOSf0DRbiYfibkJEYIFj4QYWELvKCsaXK84xImKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOwftHSN2F9Q1jGTbrncpxa3paQTVLbfsg/E0/2zQLrwIGnkpMV0+M6a3C3QIn4hX
	 6pXl30t87D4eD994nFU6sAHmcD+Q4AyznxG7Jk9MSCfsnlcwqwFsXFT5Hfmn0Nf5W0
	 CK1sSf7vUGf5AuP7DAW8CdbYBV6D2pmD+Jh1VUoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balaji Pothunoori <quic_bpothuno@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/676] wifi: ath11k: Fix CE offset address calculation for WCN6750 in SSR
Date: Fri,  6 Dec 2024 15:30:08 +0100
Message-ID: <20241206143700.730405675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83dc284392de2..fa46e645009cf 100644
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



