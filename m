Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDCE3081CE;
	Mon,  1 Dec 2025 11:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588381; cv=none; b=bAkEjHnaKDkcPeZHVrl9UoBrTg9eByamgIgl+2RcS7zfQMPVkcujVQ6Zd8n7PuWawgNMMU7USsXWgnEJhMj3bOxaRdjnDRzfafsoFbf+vH2QvHgBKKJx9gas/ZS7eGvr3In4edOnCKfY9N0yHXqu1Kun6e4PVPUFYBAy/FUJ7KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588381; c=relaxed/simple;
	bh=Cztz3bi8K8JWVpshrqKSOacTHTmAduUtY+nbjGx1MnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgYok6J8tkqqZygpaI36S8K/4e7ef28/rv6Hs64Yv5srTOAGlw4hkpvawu6eA2X8Z/WZhmp25juyAy/capud4VinB5FHxPoU1XSpEHkcY0OTIxJSibD7VmjNOK7ByaS/j8nNbR7fcQNBGuCzpkwo+74oGmTlR843Oxw2LXg3K5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TO1ew8lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TO1ew8lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DD1C19424;
	Mon,  1 Dec 2025 11:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588381;
	bh=Cztz3bi8K8JWVpshrqKSOacTHTmAduUtY+nbjGx1MnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TO1ew8lZcNx1R/4ZcWoJMf/Cume1/KTlv1azjnTVxos8pUlg/C2QfGvicJaafntPB
	 i77Wl0AeGr4xsLxWIrrEplcC65vevru3Dk7kIJtL1M6slFXq1ot0Ka/WWNOmHurmgs
	 r894Ttp03CrLp6X8IJQewZT4N3BShewqTx9D2gyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/187] wifi: ath10k: Fix memory leak on unsupported WMI command
Date: Mon,  1 Dec 2025 12:21:59 +0100
Message-ID: <20251201112241.658379809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ed6316c41cb78..a445a192b30f3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1894,6 +1894,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	if (cmd_id == WMI_CMD_UNSUPPORTED) {
 		ath10k_warn(ar, "wmi command %d is not supported by firmware\n",
 			    cmd_id);
+		dev_kfree_skb_any(skb);
 		return ret;
 	}
 
-- 
2.51.0



