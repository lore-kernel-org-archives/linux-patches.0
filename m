Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856112EF652;
	Thu, 28 May 2026 20:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000971; cv=none; b=flgWMXkE7ZsdI0Pdu4sThKaiO4GKKC9UjrerXjZ+c6tWrxBexc4oUKVXjhpBOQMgZBuZeHJPuSJcUvbqF6yhqoWCO1Lnlu1yEwxX4D+duH0nVzJsHCYi/t1paXZ0m39m41QGRv8HSjG75hTbiqY1AJkW96suu6n+AZzIetuaVus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000971; c=relaxed/simple;
	bh=rfTkvntvzUiE2To70zCPvtG3mi2xpskstb97oMzEILw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjkQxRDCbV4qtScfXXxlHdJu70RfcKayoXepUB98q20vYgBreG0wa9OVOfM4Wh8CAyyMxr4olJTlLb8GyIfNE5OWzwB9eQHmuhyVduxpbLN33yaWCpfr3qEnvF+xi3D3FRPLK8xWh4sWVqia7tenjdkJYYkahY3UHPS2VYzPIok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaL6eT4O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaL6eT4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21321F000E9;
	Thu, 28 May 2026 20:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000970;
	bh=+DOSbeTuhYR/2teRsfQK8jZK3hWBf+jze9h0lQR4NOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GaL6eT4OjL64lrgiwEIZtwK/6co+5lIacfuwQRZrtBm7csuxV8oSrZ0umFuwqf4DS
	 IZorXdIsY/p+yz3+uJzINV5ryPro6yp7hbuezn/EkzZnB0p9OqyGdXtR9MxqXG+lSi
	 c3ju7ALfuxI1n3U6YAdzPORLV/MiM/YLlIaq/Z90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/272] wifi: ath11k: fix error path leak in ath11k_tm_cmd_wmi_ftm()
Date: Thu, 28 May 2026 21:49:41 +0200
Message-ID: <20260528194635.031642966@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 7320d6eb861e9913193a7801834c661381756a79 ]

This is similar to what was fixed by previous patches. We have a call
to ath11k_wmi_cmd_send() which does check the return value, but forgot
to free the related skb on error.

Fixes: b43310e44edc ("wifi: ath11k: factory test mode support")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260506134240.2284016-4-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/testmode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/testmode.c b/drivers/net/wireless/ath/ath11k/testmode.c
index 302d66092b973..7aa62a7d9a272 100644
--- a/drivers/net/wireless/ath/ath11k/testmode.c
+++ b/drivers/net/wireless/ath/ath11k/testmode.c
@@ -457,6 +457,7 @@ static int ath11k_tm_cmd_wmi_ftm(struct ath11k *ar, struct nlattr *tb[])
 		ret = ath11k_wmi_cmd_send(wmi, skb, cmd_id);
 		if (ret) {
 			ath11k_warn(ar->ab, "failed to send wmi ftm command: %d\n", ret);
+			dev_kfree_skb(skb);
 			goto out;
 		}
 
-- 
2.53.0



