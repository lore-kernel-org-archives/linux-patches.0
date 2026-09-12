Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2936A37E;
	Sat, 12 Sep 2026 10:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208021; cv=none; b=QR/0XrtGfZnO/Uq6S5yG1DHHtaUnoU/kKt5sJ3wNcq84FDs9zzmbYMT+3Mmmxy1hdEhRCnXEbd1Wz+LUBaQSVIzYl+ipLQcXHajVc6dk3Hq1bsiadZRstuElM5pPJKtPjeysop/ZNuy+f3DRNOrJh8q6LUS+trHyzcAVO38LcFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208021; c=relaxed/simple;
	bh=P/4vB1xTi3Jqnn4SA4xvAdoCe/IrtoA7tTz51dLVTOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsjelAaGTXzO05gzRyEIa7i1q7ceRf+2R2jexvy1rO6m0kkPmjkg+qkMk0mo14+ASsr7j1zzvnWZjuR4QdmCJsGskCQ68fnKdArwPyPDhb4I1mfPLuQ8df1HhIQIlkZ70tU8R+I4uL/xpoh8zC99mCe6JZw3WwM8kWSyZuf1Ieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSS6WhX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSS6WhX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC1E1F000FF;
	Sat, 12 Sep 2026 10:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208019;
	bh=GIllzURTH3JMfkq8Pjexv8+jkQYEBhauI8jFxq1tu90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSS6WhX9enfzw3NOAmaMdDtb+yTgS4jusrpLqsbTq0a8deaVtr/bYsezVvYSr5uPF
	 P13Xtp74miLd3EiG1FO/UmuMWvEgDMEHjKoWYhrFeTLzyM2hHfyXZywrjcN6iLfclD
	 0COgtxq/1C1iC4TqH+2dmD1SPgMJzC/LcVQXFQXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0532/1518] wifi: ath6kl: avoid buffer overreads in WMI event handlers
Date: Sat, 12 Sep 2026 08:45:01 +0200
Message-ID: <20260912065635.478759432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit f57314aade9d74d30f3360ec5ef85a83654748be ]

The following WMI event handlers currently read from the event buffer
without first verifying that the message was large enough to hold the
expected event:
ath6kl_wmi_scan_complete_rx()
ath6kl_wmi_addba_req_event_rx()
ath6kl_wmi_delba_req_event_rx()

Add length checks to prevent overread.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260711-ath6kl_wmi_scan_complete_rx-v2-1-22dc0f7f45e7@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 0cdcbc3c77966..2353b6d18c6c4 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1296,6 +1296,9 @@ static int ath6kl_wmi_scan_complete_rx(struct wmi *wmi, u8 *datap, int len,
 {
 	struct wmi_scan_complete_event *ev;
 
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
 	ev = (struct wmi_scan_complete_event *) datap;
 
 	ath6kl_scan_complete_evt(vif, a_sle32_to_cpu(ev->status));
@@ -3372,7 +3375,12 @@ static int ath6kl_wmi_get_pmkid_list_event_rx(struct wmi *wmi, u8 *datap,
 static int ath6kl_wmi_addba_req_event_rx(struct wmi *wmi, u8 *datap, int len,
 					 struct ath6kl_vif *vif)
 {
-	struct wmi_addba_req_event *cmd = (struct wmi_addba_req_event *) datap;
+	struct wmi_addba_req_event *cmd;
+
+	if (len < sizeof(*cmd))
+		return -EINVAL;
+
+	cmd = (struct wmi_addba_req_event *)datap;
 
 	aggr_recv_addba_req_evt(vif, cmd->tid,
 				le16_to_cpu(cmd->st_seq_no), cmd->win_sz);
@@ -3383,7 +3391,12 @@ static int ath6kl_wmi_addba_req_event_rx(struct wmi *wmi, u8 *datap, int len,
 static int ath6kl_wmi_delba_req_event_rx(struct wmi *wmi, u8 *datap, int len,
 					 struct ath6kl_vif *vif)
 {
-	struct wmi_delba_event *cmd = (struct wmi_delba_event *) datap;
+	struct wmi_delba_event *cmd;
+
+	if (len < sizeof(*cmd))
+		return -EINVAL;
+
+	cmd = (struct wmi_delba_event *)datap;
 
 	aggr_recv_delba_req_evt(vif, cmd->tid);
 
-- 
2.53.0



