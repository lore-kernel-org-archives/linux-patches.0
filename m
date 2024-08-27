Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB291C6F57;
	Tue, 27 Aug 2024 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770305; cv=none; b=jVxUFPdeCwlAWuStxQo0hePYp8tMfBMYI5aSF+vDOOjsz3DsX/GhTA0Se/buQF5VyrIT8PMs/e9EtE4gR0gZlHlbqR3WJ50SzSb2XGLARHRArh1EBp6EYiRt6UbVGONYhRa9A0fQMIOlEdAm6hC9tMIJiaGPwbK8baBP30gMkDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770305; c=relaxed/simple;
	bh=zi73ry/AO6dNETvBSIajeF/btzY4k4OvDX24crku4qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9pNBaiHEcEF7N6+CKBzBO44HIomezRePQrdwFPNwjNrFaear71LkJJFfAfhI4Q+CVy8DB55qYQ87HVT+QpMiaT1iRpyNdqtWfWk0s/Cql7rM9xW1QtvNsBsjPgHoOJ8UhnPIIVirv/Qv+Lyu8txvUA5+7w8ZhO6cphHv9zKUMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6kMxcQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6kMxcQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F67EC4DE03;
	Tue, 27 Aug 2024 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770305;
	bh=zi73ry/AO6dNETvBSIajeF/btzY4k4OvDX24crku4qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6kMxcQNjjCFH+mwH29MewaHAz7LeHqYC8KXgkHg1SiyVoQxMY5Wi9zaNhXU4pDKW
	 n3hFLtczKYrhR58n2sN6BP80y47YF9MmmsXuFNPPbRoVn+F8KVfGQuMLtv9TbOFvI0
	 YLZ7xh4YD/0oDpupdK/bSC0ZiriB/fOdFBGdrhUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/341] wifi: ath12k: Add missing qmi_txn_cancel() calls
Date: Tue, 27 Aug 2024 16:36:29 +0200
Message-ID: <20240827143849.429327657@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit 2e82b5f09a97f1b98b885470c81c1248bec103af ]

Per the QMI documentation "A client calling qmi_txn_init() must call
either qmi_txn_wait() or qmi_txn_cancel() to free up the allocated
resources."

Unfortunately, in most of the ath12k messaging functions, when
qmi_send_request() fails, the function returns without performing the
necessary cleanup. So update those functions to call qmi_txn_cancel()
when qmi_send_request() fails.

No functional changes, compile tested only.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240111-qmi-cleanup-v2-2-53343af953d5@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index e68accbc837f4..f1379a5e60cdd 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -1977,6 +1977,7 @@ static int ath12k_qmi_host_cap_send(struct ath12k_base *ab)
 			       QMI_WLANFW_HOST_CAP_REQ_MSG_V01_MAX_LEN,
 			       qmi_wlanfw_host_cap_req_msg_v01_ei, &req);
 	if (ret < 0) {
+		qmi_txn_cancel(&txn);
 		ath12k_warn(ab, "Failed to send host capability request,err = %d\n", ret);
 		goto out;
 	}
@@ -2040,6 +2041,7 @@ static int ath12k_qmi_fw_ind_register_send(struct ath12k_base *ab)
 			       QMI_WLANFW_IND_REGISTER_REQ_MSG_V01_MAX_LEN,
 			       qmi_wlanfw_ind_register_req_msg_v01_ei, req);
 	if (ret < 0) {
+		qmi_txn_cancel(&txn);
 		ath12k_warn(ab, "Failed to send indication register request, err = %d\n",
 			    ret);
 		goto out;
@@ -2114,6 +2116,7 @@ static int ath12k_qmi_respond_fw_mem_request(struct ath12k_base *ab)
 			       QMI_WLANFW_RESPOND_MEM_REQ_MSG_V01_MAX_LEN,
 			       qmi_wlanfw_respond_mem_req_msg_v01_ei, req);
 	if (ret < 0) {
+		qmi_txn_cancel(&txn);
 		ath12k_warn(ab, "qmi failed to respond memory request, err = %d\n",
 			    ret);
 		goto out;
@@ -2228,6 +2231,7 @@ static int ath12k_qmi_request_target_cap(struct ath12k_base *ab)
 			       QMI_WLANFW_CAP_REQ_MSG_V01_MAX_LEN,
 			       qmi_wlanfw_cap_req_msg_v01_ei, &req);
 	if (ret < 0) {
+		qmi_txn_cancel(&txn);
 		ath12k_warn(ab, "qmi failed to send target cap request, err = %d\n",
 			    ret);
 		goto out;
@@ -2567,6 +2571,7 @@ static int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
 			       QMI_WLANFW_M3_INFO_REQ_MSG_V01_MAX_MSG_LEN,
 			       qmi_wlanfw_m3_info_req_msg_v01_ei, &req);
 	if (ret < 0) {
+		qmi_txn_cancel(&txn);
 		ath12k_warn(ab, "qmi failed to send M3 information request, err = %d\n",
 			    ret);
 		goto out;
@@ -2613,6 +2618,7 @@ static int ath12k_qmi_wlanfw_mode_send(struct ath12k_base *ab,
 			       QMI_WLANFW_WLAN_MODE_REQ_MSG_V01_MAX_LEN,
 			       qmi_wlanfw_wlan_mode_req_msg_v01_ei, &req);
 	if (ret < 0) {
+		qmi_txn_cancel(&txn);
 		ath12k_warn(ab, "qmi failed to send mode request, mode: %d, err = %d\n",
 			    mode, ret);
 		goto out;
@@ -2704,6 +2710,7 @@ static int ath12k_qmi_wlanfw_wlan_cfg_send(struct ath12k_base *ab)
 			       QMI_WLANFW_WLAN_CFG_REQ_MSG_V01_MAX_LEN,
 			       qmi_wlanfw_wlan_cfg_req_msg_v01_ei, req);
 	if (ret < 0) {
+		qmi_txn_cancel(&txn);
 		ath12k_warn(ab, "qmi failed to send wlan config request, err = %d\n",
 			    ret);
 		goto out;
-- 
2.43.0



