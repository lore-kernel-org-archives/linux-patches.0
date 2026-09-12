Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364CD38AC72;
	Sat, 12 Sep 2026 19:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242718; cv=none; b=ZVulyLr3Q8S5Xvi0Pn3fVn8OvrYNw0gd/9IhqRNCqDpJRnZfyFzDh8JqDw6fpGvxqV/y5yZ+3iaMXmyuL6P9y8RXd0i6vcZIvcyy1JNijAFK/xFf1SVneXahHB36da0HTHG3ZRj5TqC5vAKgg4uFYRkC/YU7PUaDjuXOBJ24ay4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242718; c=relaxed/simple;
	bh=sRsJJpJKLLqr66CIisdnxXN6KYvQg0aKcGcVV38w1bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQAwBW5kQj1gE5qp977mBsjZkTp79RpXfVjh4cmBcc5oAbxSwbZRFQvnC07fjhuIi9Nf3bvYoSwbHBWCzYUl7IoiHPZekqRJ0f4Pg0hItYXQEyqCMmCj4VVAGAPhJaBWNgrnfiMKhjMRGXsXa9O9WSMCfj5k3/EtvcGoUYi7w1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rInUaobA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rInUaobA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A0F1F000FF;
	Sat, 12 Sep 2026 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242717;
	bh=+9LLWVz+ASb6n1TMUkRdYIv0VFQZlU0obvbvwl+dLv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rInUaobAf1OfE7Mh0kYLhz40+G6stpoIxV5dZBqLt4gGTECMr+O23CQ0gQWTjKCyh
	 eUTcWVmkPdj+MKWd4Y+h7oCedB/ZwYYB3MVDL3E3HPvRHIRxZ9rIAh2iORo16sTtLZ
	 U0dCFoY8WJvx7ig3L12Mnyp3X+Mtkkqb31xEVM2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/798] wifi: ath6kl: avoid buffer overreads in WMI event handlers
Date: Sat, 12 Sep 2026 09:02:09 +0200
Message-ID: <20260912065528.620117232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7aa4de770f663..25d7bed49dba3 100644
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



