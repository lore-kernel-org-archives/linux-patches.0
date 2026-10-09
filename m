Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C744735C6A8;
	Fri,  9 Oct 2026 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555866; cv=none; b=KxDCB2PUQK/blyTHFpnIjMR0lw9Iaz/b+++pUCn9M5oKOW2Dv4iCa99rcrOruXhK1SXe+iOhYbRDKLH6bvR9uv0PeZYNoC40GxML3uvhgMEuUg15tbePPuWieG1fDaR7RxKB+21sMirycOvUZ6lIdJEo5fTCD7VACHPzu7dOPYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555866; c=relaxed/simple;
	bh=g5TyJHEERyfErM8ya8SRCTslUPYVGTcRQxyLrhpsIrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9ZiDipPGXV2DgsOmHhbpRiNDWoADw6pM03OpXkidZAaLA5g59xI3vPCo9Pd3VSEbF/nedeRsb/AFiu3rNwV/Fo+yMf102MZ12W0BH/+noJO7addRSkHo35l0ymQNHIEy0wWTEyAzdqHl6KNUDd/Cg67GurZr22ajQ0vJlMI21c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lX1IZGF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lX1IZGF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3227F1F000FF;
	Fri,  9 Oct 2026 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555865;
	bh=0CzYEbIishsPEOJSHe+yZPOYKL8W37/4GFEkrpd+JYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lX1IZGF6SwLZwDfGFpMDlkaHr7FL56Cbqr4+MqBfjiP6MC+LGiiqjgEyH3FHzZE+U
	 GEBsn0g8IMyAsjSOYOpGJ8SxXrEYEM1qf8R5U/Wku0xTEOEiBpuDpe3rAj3X7Jz27q
	 ppjVRL3nvQvtJgbVHh7oRaNgMr41zl2Ilcrofqw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 082/428] wifi: ath9k: reject short WMI command responses
Date: Fri,  9 Oct 2026 16:06:59 +0200
Message-ID: <20261009140947.975830108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 93ce8ea70451e800601bc9444aa33043de15d67b ]

ath9k_wmi_rsp_callback() removes the validated WMI header and copies
the number of bytes expected by the waiting command into its response
buffer. A device response shorter than that expectation can therefore
be read beyond the skb payload.

Record -EMSGSIZE for a short response, complete the waiter, and return
the stored status from the command path. This also prevents callers from
consuming stale response bytes as a successful reply.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Assisted-by: LLM
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260814075837.20005-1-pengpeng@iscas.ac.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 16 ++++++++++++++--
 drivers/net/wireless/ath/ath9k/wmi.h |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 44e91815a1594..4a08babb6d9d6 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -206,9 +206,16 @@ static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
 {
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
 
-	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
+	if (wmi->cmd_rsp_buf && wmi->cmd_rsp_len) {
+		if (skb->len < wmi->cmd_rsp_len) {
+			wmi->cmd_rsp_status = -EMSGSIZE;
+			goto complete;
+		}
 		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
+	}
+	wmi->cmd_rsp_status = 0;
 
+complete:
 	complete(&wmi->cmd_wait);
 }
 
@@ -300,6 +307,7 @@ static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 	/* record the rsp buffer and length */
 	wmi->cmd_rsp_buf = rsp_buf;
 	wmi->cmd_rsp_len = rsp_len;
+	wmi->cmd_rsp_status = 0;
 
 	wmi->last_seq_id = wmi->tx_seq_id;
 	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
@@ -356,9 +364,13 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		return -ETIMEDOUT;
 	}
 
+	spin_lock_irqsave(&wmi->wmi_lock, flags);
+	ret = wmi->cmd_rsp_status;
+	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
+
 	mutex_unlock(&wmi->op_mutex);
 
-	return 0;
+	return ret;
 
 out:
 	ath_dbg(common, WMI, "WMI failure for: %s\n", wmi_cmd_to_name(cmd_id));
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 5c3b710b8f319..0bb9d31f1a1cc 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -157,6 +157,7 @@ struct wmi {
 	u16 tx_seq_id;
 	u8 *cmd_rsp_buf;
 	u32 cmd_rsp_len;
+	int cmd_rsp_status;
 	bool stopped;
 
 	struct list_head pending_tx_events;
-- 
2.53.0



