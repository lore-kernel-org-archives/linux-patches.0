Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4617338597;
	Wed,  3 Dec 2025 15:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777365; cv=none; b=GkbhC9ysK++oYcEBny6t60U18/Lbr6upH1rLE6NSCJ6G6vTe7QDfDFXByRv7PIr50L5KfZhG+7MgUDmWpaQ/aplsJDqWUg/RbLV7WBsR16q9XT8yEl/nI6V2+JSiWMQ8pCanCYtwyfvPc6/aQXsIaPdzNqokRuYkysA+SCm9At8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777365; c=relaxed/simple;
	bh=IGmVbmz/bgG/tQl07ZzCv2domSSrwxY9Q06+V8YlWTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adlf36ZgyulJpF5z9Bk7x+8NOpZGOaQr+gmR9L2GrDeiH0R9jYZReIR54C106KMj6GlGHe2jWmApGzkohr6JUJFb9wwHSxLB2YJDj87T0Vb0/j6i73sL5jvpSZwXWEG5RY+3Dapv7ylP/F8Y2genNSyvv0gEyZjuHd7xHMYPn2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFWIV1As; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFWIV1As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031B5C4CEF5;
	Wed,  3 Dec 2025 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777364;
	bh=IGmVbmz/bgG/tQl07ZzCv2domSSrwxY9Q06+V8YlWTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFWIV1As8Tg328P4QxnLAshhdmyrn9Rh1KzGLMAfIi30Br8E+iIo45Q3Z8xj70Ttc
	 cArFRVi0bkixqhQ/LGWvnBU6zpx0xRQBAMWFlSkiJ7hDgSqAffs88dwaxtVvlATerz
	 Sk/V+IsiKg5/zsQ9k3nZ8y9hxe8yPLKNB24WgMQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/392] wifi: ath10k: Fix memory leak on unsupported WMI command
Date: Wed,  3 Dec 2025 16:22:46 +0100
Message-ID: <20251203152414.701738440@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 2e9c1da4ee9d0acfca2e0a3d78f3d8cb5802da1b ]

ath10k_wmi_cmd_send takes ownership of the passed buffer (skb) and has the
responsibility to release it in case of error. This patch fixes missing
free in case of early error due to unhandled WMI command ID.

Tested-on: WCN3990 hw1.0 WLAN.HL.3.3.7.c2-00931-QCAHLSWMTPLZ-1

Fixes: 553215592f14 ("ath10k: warn if give WMI command is not supported")
Suggested-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20250926195656.187970-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5817501b0c3fe..f07788092b269 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1935,6 +1935,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	if (cmd_id == WMI_CMD_UNSUPPORTED) {
 		ath10k_warn(ar, "wmi command %d is not supported by firmware\n",
 			    cmd_id);
+		dev_kfree_skb_any(skb);
 		return ret;
 	}
 
-- 
2.51.0



