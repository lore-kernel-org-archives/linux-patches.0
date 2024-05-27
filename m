Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED271DFED;
	Mon, 27 May 2024 19:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836722; cv=none; b=pOD70TC0LRHvFkpBYqv/F+pshTFkb48Q7DQZXbp1+qER5teOVvGY5R1MT23lrObok35qXfio0ln9xbt9WAK4o2rX1luWWd2oVCpv7t+HdaMHSyicEHcUnJj4tJsDABOH8BvrKjputnAxdAS3FAn5HBRx/hFhykh8eUQa6PhjKVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836722; c=relaxed/simple;
	bh=NFznIkf4aELEf+vf344YLYZfMQmCpvEuavr58VrubrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or78ZOL2ltnBMbhRGSJI0UtL+rqRMQzh9oM02iHIKVKJq3X9wKI1lrgR53fh2oRqJLtdTq8c68QvTVIWK04Wqd4hXgbzMu6gUAjjPwdYdt0J0hJ+GKHZi/LtUuDkBxskGCZXzt8OsOG4cR1B0Hs/QKoCreivuebD23KwYVCRfo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbLCAw1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbLCAw1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67D9C2BBFC;
	Mon, 27 May 2024 19:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836722;
	bh=NFznIkf4aELEf+vf344YLYZfMQmCpvEuavr58VrubrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbLCAw1R9emWp60cLY0jzgnrvxa1N4SCFJSKhy+ryyx9ayZxmKIf42L6NnDnI1YQx
	 1s8f0cOq555C4fUWz7aGOVaoxTCxxEmESjir6dD55FAFhRDn2BnDXeMBaJRaXiN1Ue
	 /YicZyvk5FB/mEJ2Y/7wbKw2VwroOcveMgS+60nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 162/427] wifi: ath12k: fix out-of-bound access of qmi_invoke_handler()
Date: Mon, 27 May 2024 20:53:29 +0200
Message-ID: <20240527185617.497101763@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>

[ Upstream commit e1bdff48a1bb4a4ac660c19c55a820968c48b3f2 ]

Currently, there is no terminator entry for ath12k_qmi_msg_handlers hence
facing below KASAN warning,

 ==================================================================
 BUG: KASAN: global-out-of-bounds in qmi_invoke_handler+0xa4/0x148
 Read of size 8 at addr ffffffd00a6428d8 by task kworker/u8:2/1273

 CPU: 0 PID: 1273 Comm: kworker/u8:2 Not tainted 5.4.213 #0
 Workqueue: qmi_msg_handler qmi_data_ready_work
 Call trace:
  dump_backtrace+0x0/0x20c
  show_stack+0x14/0x1c
  dump_stack+0xe0/0x138
  print_address_description.isra.5+0x30/0x330
  __kasan_report+0x16c/0x1bc
  kasan_report+0xc/0x14
  __asan_load8+0xa8/0xb0
  qmi_invoke_handler+0xa4/0x148
  qmi_handle_message+0x18c/0x1bc
  qmi_data_ready_work+0x4ec/0x528
  process_one_work+0x2c0/0x440
  worker_thread+0x324/0x4b8
  kthread+0x210/0x228
  ret_from_fork+0x10/0x18

 The address belongs to the variable:
  ath12k_mac_mon_status_filter_default+0x4bd8/0xfffffffffffe2300 [ath12k]
 [...]
 ==================================================================

Add a dummy terminator entry at the end to assist the qmi_invoke_handler()
in traversing up to the terminator entry without accessing an
out-of-boundary index.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240416080234.2882725-1-quic_kathirve@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 92845ffff44ad..40b6abccbb508 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3178,6 +3178,9 @@ static const struct qmi_msg_handler ath12k_qmi_msg_handlers[] = {
 		.decoded_size = sizeof(struct qmi_wlanfw_fw_ready_ind_msg_v01),
 		.fn = ath12k_qmi_msg_fw_ready_cb,
 	},
+
+	/* end of list */
+	{},
 };
 
 static int ath12k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
-- 
2.43.0



