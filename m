Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A0F4C97;
	Tue, 11 Nov 2025 00:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822153; cv=none; b=Jis1fNh/I6vHeam5vg/xZV7RiwHCgIcCaBZ0t2SLk1VA+uuvT84Qkb36r681Lt8OUvCf4Xur80HY4d6x1BHGBRNLGO/PqMDZ78LGbogoVJdn3pFOb+jUM/b8lrtpztbX6A0gSK9LMeH9jJkYTN6WXy40bUKk/vs2gcfpF0CzHYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822153; c=relaxed/simple;
	bh=aGgj0TGavz8ywxZU6/WinFwAdp8advH+1UmKTM1HQqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP3KDCCNUwIrj6fkxb7QGAFBp9ISGDFB7AOzHlM2kxYqnvFz8oA2IsU8V7c5e9fV1sjWXTx7GmbKTrXIsIqrcxUXV37bliSvkwdUFdFINVrHr9eKy0zR6pyNcsvSdaQDBQze2HJcrptWMuftpf6SliGVkNhjT5zZDYXzJTg/n/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9wW/7ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9wW/7ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360DAC113D0;
	Tue, 11 Nov 2025 00:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822150;
	bh=aGgj0TGavz8ywxZU6/WinFwAdp8advH+1UmKTM1HQqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9wW/7nscN69yC7br7bb3ifz2qqWK7GyqdXJ2t05WygGLkwTv54bkIVlUrt0iD1W4
	 ZDnZbsQEFOhYv8K2y5dbRlSpDslueQ1hUFeOBqg/B/mr4up8MYCvb7w/Kpyd+poEWG
	 soDgq2DSu8lbnxQyKO7xdIPtt6S7HkeVjcldaweY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 029/849] wifi: ath10k: Fix memory leak on unsupported WMI command
Date: Tue, 11 Nov 2025 09:33:19 +0900
Message-ID: <20251111004537.152381372@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index e595b0979a56d..b3b00d324075b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1937,6 +1937,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	if (cmd_id == WMI_CMD_UNSUPPORTED) {
 		ath10k_warn(ar, "wmi command %d is not supported by firmware\n",
 			    cmd_id);
+		dev_kfree_skb_any(skb);
 		return ret;
 	}
 
-- 
2.51.0



