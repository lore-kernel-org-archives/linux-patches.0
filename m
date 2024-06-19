Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCDC146586;
	Wed, 19 Jun 2024 13:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802674; cv=none; b=C9oQKFo52Tqk35G+VS7L6Kj9tj0Jt1knvujH61SSKLbqijV4AmJLVIpdsvLabpNghDPLGJbeqXRVdCx0n/8xUo9bFflzl3IT2JohwaHPa+7P0/AZ3XkkOeuWuoXHdVJkvVkNeX0GeqfJCa4Bbj4qxbFtF7a2EMl0gbD26Bsy2/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802674; c=relaxed/simple;
	bh=Swq9PdJ4jPr5Tqzs3j4dfEHAAGq7sWUZvhktKW0yPPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO74zNudvuVrJfPnUO5WJYR2L3asmFb16xhFG4GUG6+hPdDBPSBiwPSA1YfLbjm1ofNxTq8u9CT3Vji+ZZuePde3BSvMadmob13rywMDW5Eqd+mNv+hHQIeFoKiFCk/8qdd7QOTrCwI9o1AXgps37QT8nRNdB5WXkRTBXUr/eY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZHNynUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZHNynUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E07C2BBFC;
	Wed, 19 Jun 2024 13:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802673;
	bh=Swq9PdJ4jPr5Tqzs3j4dfEHAAGq7sWUZvhktKW0yPPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZHNynUz0g5TS4/HDqNh1NCtw4I/u/9fptfW6yKl6eh4QxHD/NGNVOJzgwbDjK4N6
	 7Ueq+In7no3pOoifZQgT453Je9B/cp7toL5dvSzQSmSGoQxBIF9lQd2bi+MdZ/1VnF
	 +2WP/Y3nocfS01tCQfd0/Li8M2Cmkup8DNh2mH5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 001/281] wifi: ath11k: fix WCN6750 firmware crash caused by 17 num_vdevs
Date: Wed, 19 Jun 2024 14:52:40 +0200
Message-ID: <20240619125609.896893706@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carl Huang <quic_cjhuang@quicinc.com>

[ Upstream commit ed281c6ab6eb8a914f06c74dfeaebde15b34a3f4 ]

WCN6750 firmware crashes because of num_vdevs changed from 4 to 17
in ath11k_init_wmi_config_qca6390() as the ab->hw_params.num_vdevs
is 17. This is caused by commit f019f4dff2e4 ("wifi: ath11k: support
2 station interfaces") which assigns ab->hw_params.num_vdevs directly
to config->num_vdevs in ath11k_init_wmi_config_qca6390(), therefore
WCN6750 firmware crashes as it can't support such a big num_vdevs.

Fix it by assign 3 to num_vdevs in hw_params for WCN6750 as 3 is
sufficient too.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-01371-QCAMSLSWPLZ-1

Fixes: f019f4dff2e4 ("wifi: ath11k: support 2 station interfaces")
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Closes: https://lore.kernel.org/r/D15TIIDIIESY.D1EKKJLZINMA@fairphone.com/
Signed-off-by: Carl Huang <quic_cjhuang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240520030757.2209395-1-quic_cjhuang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index c78bce19bd754..5d07585e59c17 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -595,7 +595,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.coldboot_cal_ftm = true,
 		.cbcal_restart_fw = false,
 		.fw_mem_mode = 0,
-		.num_vdevs = 16 + 1,
+		.num_vdevs = 3,
 		.num_peers = 512,
 		.supports_suspend = false,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_qcn9074),
-- 
2.43.0



