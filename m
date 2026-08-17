Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6CB2E8DEC;
	Mon, 17 Aug 2026 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979239; cv=none; b=H7AjUMkRj4B8nJnDGqvfLay4kqEA5BRX6EXEYuSDQXcZRzsLKbNLIZ3Ca4mRudfcRMjOhSqBpzTIuUgI3kwMy0Bj8AKOoqcC3vSCssm+OI3J4Pmv58BnkNBWlE1y/xRzzrihV/QBTDO/X7kIyFnCfoNnYve3bUCB0LPPdhzlgj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979239; c=relaxed/simple;
	bh=D8eoJGj8lhjvmgQn5DtoKKjBWneXomHrQGh2rLTQyGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0g4NhOJ0ziqt32T6PpL1TGgxYw9KjVoyItGkwb1S+lVGh1CHe8misVR9KY7v/wlk46HFQnn1QQVjqIIYU7vWr+g4gyu3EqCPHQNY+hZKCvWk4av3P6NOF1TEtgcdvkLrBKueEmE19utUpIn59AgnibMcXGdXNcZ8dfNdX/PCKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trC0BvLH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trC0BvLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675AE1F000E9;
	Mon, 17 Aug 2026 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979237;
	bh=DiYP4HE9nZd+7+eXT7tnJPec3GKhCyZ2mlRjwCCa9jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trC0BvLHMl7r6OADXl5AvUaZxyx1raXu0Vhk9oHA7FHPNzW+tHO4HYneJoj8f0FD+
	 ayHi0WT5wpkI5zhzoDAz8zdavtFzs4hWsN1djYJKJpRcXfEDMOmvdexNfX7e9r/3Fr
	 zGKbk2meMN0AvKORV+4pgimYx3YJ9AeiKk44APW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/609] wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler
Date: Mon, 17 Aug 2026 15:26:43 +0200
Message-ID: <20260817132547.316439403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 3a21c89215cc18f1a97c5e5bfd1da6d4f3d44495 ]

The firmware-controlled num_msg field (u8, 0-255) drives the loop in
ath6kl_wmi_tx_complete_event_rx() without validation against the buffer
length. This allows out-of-bounds reads of up to 1020 bytes past the
WMI event buffer when the firmware sends an inflated num_msg.

Add a check that the buffer is large enough to hold the fixed struct
and the num_msg variable-length entries.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260625232907.3620746-1-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3787b9fb007559..a572952dd4b903 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -484,6 +484,18 @@ static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 
 	evt = (struct wmi_tx_complete_event *) datap;
 
+	if (len < sizeof(*evt)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d\n",
+			   len);
+		return -EINVAL;
+	}
+
+	if (len < sizeof(*evt) + evt->num_msg * sizeof(struct tx_complete_msg_v1)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d for %u msgs\n",
+			   len, evt->num_msg);
+		return -EINVAL;
+	}
+
 	ath6kl_dbg(ATH6KL_DBG_WMI, "comp: %d %d %d\n",
 		   evt->num_msg, evt->msg_len, evt->msg_type);
 
-- 
2.53.0



