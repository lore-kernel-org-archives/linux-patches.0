Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03AC3B38A4;
	Sat, 12 Sep 2026 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239120; cv=none; b=dx+Q+QW591/6yDYpd5OmQa3EQzXqok0A/8kJr3Y/onkkj11IE7oPBj3i91BqYUYrrr14AfMQiZNv7rzfaljf40XWKoldCbW4WfXc2rZtU5iR9YXoTQda56xlRV5Ek2UTpGFP9b83KLJQw1ePHRQoZvtmkXnuYMPcY9i+xwfcXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239120; c=relaxed/simple;
	bh=LjKdhO9pXRg1AMP+Kzrnsy6l3XUXDV7Zbv/TN6HrSdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW8O/VbUJD18FAu5xvKXaIUMiC0/XjvCBNghv/Xpsz8pQ9PF53Kp14PTsCb+RrzIwV0tKvIRcWKTCEURo+Mvyg30f6IUDscDNVuzy3KYRqzkPJL5zo9Q9rkJPe1RR53kT/V5e6aIa6scYjLFXKF8i7yIDp2xJNdeO5XmcjGYJqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7BDs0sN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7BDs0sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FB41F000FF;
	Sat, 12 Sep 2026 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239119;
	bh=xyHzT3+iw04pN7NNjx3pMsfliE2+2DYxA7qAy+zuifw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7BDs0sNj+s9h+1zATDhNnaaA/KwIXT38GqdD/ZB7sd9EE5L5l497b17DswCgPDt1
	 Wv28NbCWRCFUmj0MqXRihSTehTfG1OihP5y/CjDUIORZIY9rvYgpieRzSjlLPXknpW
	 Utds0rwMZFl/Pfb2zjLDN0A9t0hKGu8UdxevQxAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 583/935] wifi: ath6kl: avoid buffer overreads in WMI event handlers
Date: Sat, 12 Sep 2026 09:00:13 +0200
Message-ID: <20260912065540.211166764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bae12143eebb6..632cdd57a8ae7 100644
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
@@ -3386,7 +3389,12 @@ static int ath6kl_wmi_get_pmkid_list_event_rx(struct wmi *wmi, u8 *datap,
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
@@ -3397,7 +3405,12 @@ static int ath6kl_wmi_addba_req_event_rx(struct wmi *wmi, u8 *datap, int len,
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



