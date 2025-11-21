Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B057734B69B;
	Fri, 21 Nov 2025 13:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732137; cv=none; b=X4qcoaDJ/aM/N7de3IxK0Qlh1fdK3PhNgUGb5Kddea5mW0vj+7kUm3jlBykG/LLs+cEd4p6G9MGN1wGD12zI5g+frGvaiOmr/xL8d7zl/xlMNx/uGOvONsZxBtsHJzabtrZzBqCFI71vgmmurQ8WiWPURaO/Tm6aPX8uvhSe0QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732137; c=relaxed/simple;
	bh=9U7hToCMwbTPZhoktmyRUZggMYn7IqNB7Du/zC7p4k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd7N+mm3qJBYLjsxYX62I2XEGUhgFKJ2b0kXvkXI0xwBKCbXdzTWRKCpHW4pxy7/5cVEnVh8i1iQOt6EKQE9wNGsE+YZFvC/645tyqg8Nc/EL9fypK/NKujHZFMlFZGOOD3NTsVGBFfVst1tDcv4DgPPfHijMAW46MYiB4EYwos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N57Gotx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N57Gotx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36752C4CEF1;
	Fri, 21 Nov 2025 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732137;
	bh=9U7hToCMwbTPZhoktmyRUZggMYn7IqNB7Du/zC7p4k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N57Gotx38i0mAh7z6QdNrlJM5YHq72FNTG5Z9Un5EhVM5l1RJuA3HTc+dpkXTXZZv
	 pLIKF+HZYG/M+mXkD4rXV/Elyln0t6PuqbqxWetXUzKW9M9Hs613HwBL1cpvgSjzW0
	 lz1f5OM54l+hWQENTlht2CKESIOjFIYZ3lc3cibo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/529] wifi: ath10k: Fix memory leak on unsupported WMI command
Date: Fri, 21 Nov 2025 14:05:16 +0100
Message-ID: <20251121130231.615240007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 340502c47a10d..a15b73d502c0d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1936,6 +1936,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	if (cmd_id == WMI_CMD_UNSUPPORTED) {
 		ath10k_warn(ar, "wmi command %d is not supported by firmware\n",
 			    cmd_id);
+		dev_kfree_skb_any(skb);
 		return ret;
 	}
 
-- 
2.51.0



