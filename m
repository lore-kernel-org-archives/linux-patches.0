Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDE7313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301090; cv=none; b=JogMwh9At2iT5dJhVSwKoxAH6DowvPdtOFtGXgUTUJTIqCNbruoPS9wMiZ8y60cGgOwqfcyIbNkQvQ/c33ZKiteMHYD+bxUSvp4jUcaTMIuu3GQko0Mp7WEoaD1Y5n4f1Y60gunVrpElUYjDgOa97QpdfnGdCYDCw12ZpcHF3/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301090; c=relaxed/simple;
	bh=JKLgXofhNpt7vNqQzIkqinwzRafpahfOCG8WwoyiWq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9dMzSWqodKuNP/0+8x4sj6UgPWTNSgxSMjBwyOF6VT5Ttch8oAIFVnCUWAkDz+W9tycZF8hN7PXWMYK9lJGghBiMB8ymsO/AJf3Qioq3XXgUybh75O96NOdF1DiovqjAGItXmFr0UdI8bI25+YYTrMPwr3yiGWOdbby6gMecxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EY6vhO/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EY6vhO/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962AEC19423;
	Sat, 28 Feb 2026 17:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301090;
	bh=JKLgXofhNpt7vNqQzIkqinwzRafpahfOCG8WwoyiWq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EY6vhO/JJK1j7VykVpFsz41qjqGUh8gqNBGwug+mCUg0mwUR5tNoHJ/CNUoCfDtGk
	 hJ8/9lPbsvtoHizu3CWg6fAdSHHsG32Np+eBKjvayWr/89DDFdAr6dgRr1Dc57mfWl
	 CrLVM/jIIaR4EmI43CvrbnBqt1pY6Hpbu+yHA5S/3rv5nSgDWuaAtYJ7W4Rb2G9pV8
	 oHIsL6AGy1t1rhp/Gzf0miS6wJa7Dmr+xcbHDZfkUThCLbB30ilGtcAPY5zWyLsarP
	 k/kWgddu8ZxRVU/fqx7WOYDUVPPeXaSL/AZBuLZCzzDGcR0+jYy4VeZad0K5vNS9SJ
	 GuLwfaH7IiCkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/752] wifi: ath12k: fix preferred hardware mode calculation
Date: Sat, 28 Feb 2026 12:39:11 -0500
Message-ID: <20260228174750.1542406-240-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 7f852de0003219c431a6f2ffd951fd82a4673660 ]

For single pdev device like WCN7850/QCC2072, preferred_hw_mode is
initialized to WMI_HOST_HW_MODE_SINGLE. Later when firmware sends
supported modes to host, each mode is compared with the initial one
and if the priority of the new mode is higher, update the parameter
and store mode capability.

For WCN7850, this does not result in issue, as one of the supported
mode indeed has a higher priority. However the only available mode of
QCC2072 at this stage is WMI_HOST_HW_MODE_SINGLE, which fails the
comparison, hence mode capability is not stored. Subsequently driver
initialization fails.

Fix it by accepting a mode with the same priority.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260112-ath12k-support-qcc2072-v2-4-fc8ce1e43969@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 44e99b47e445d..6dd95bcaf2436 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4490,7 +4490,7 @@ static int ath12k_wmi_hw_mode_caps(struct ath12k_base *soc,
 
 		pref = soc->wmi_ab.preferred_hw_mode;
 
-		if (ath12k_hw_mode_pri_map[mode] < ath12k_hw_mode_pri_map[pref]) {
+		if (ath12k_hw_mode_pri_map[mode] <= ath12k_hw_mode_pri_map[pref]) {
 			svc_rdy_ext->pref_hw_mode_caps = *hw_mode_caps;
 			soc->wmi_ab.preferred_hw_mode = mode;
 		}
-- 
2.51.0

