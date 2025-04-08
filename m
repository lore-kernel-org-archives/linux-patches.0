Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCDF374C4;
	Tue,  8 Apr 2025 11:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110491; cv=none; b=M8ITnM6HVBhQT85jXKi9IeEDQqrMdQyXE5o5uzfTnjRwCpwYUdtT47B9bIllMrnxPv9Zr6Md7m9zti7ESDjHh1dKN0DFmX+a9ISQlxWaeKNQJdIhWGgFaaCupMam6lZ/IU96aiarxvduBpfseqEfnNEUFTFFiLiSkbBd11tnovI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110491; c=relaxed/simple;
	bh=dbEvDSLAHIWQj8QljCHLTp6/jSLBw3Ozk8tLBsl6Fl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdmwTd7l+1U+OTrCFDVoC+v+gIbSDrUnrKUszIAklEgl8npl9Ezf32buM28K21b/OF+MfGWgeB5psp0lRkGJvXBbsIvtvPruJqmrhYPh53YETIjPP3h3cdT0uxhOX6AiBxIyqVPKKEt8WNYf9T8sLxqOvU7pEt0HU2B5ZyIIIVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+1mzhw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+1mzhw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65D6C4CEE5;
	Tue,  8 Apr 2025 11:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110490;
	bh=dbEvDSLAHIWQj8QljCHLTp6/jSLBw3Ozk8tLBsl6Fl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+1mzhw7kkBgFDF86b7x+arYbqIT9rfyO1bACQBDtIAM/1xQPCVLj4gDhgRj0IyLk
	 Qli3lm8Z1YU27mBp+AamtnXgvXec9olbhL0sKN7vJoUvBmB/AABK68AMIR8en3IBfT
	 9VkWM+OsOsZebht4qQHHSlM/fbwmK/iRTyu/3rlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yu Zhang (Yuriy)" <quic_yuzha@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 081/731] wifi: ath11k: fix wrong overriding for VHT Beamformee STS Capability
Date: Tue,  8 Apr 2025 12:39:38 +0200
Message-ID: <20250408104916.154729039@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhang(Yuriy) <quic_yuzha@quicinc.com>

[ Upstream commit 9d13950acb2a51342c93c69f1a5bf285adb90d88 ]

Current code in ath11k_mac_set_txbf_conf overrides nsts, which is
incorrect as it confuses nss and nsts. nss is Number of Spatial
Streams，nsts is Number of Space-Time Streams.

As mentioned in Fixes: 55b5ee3357d7, the nss used when acting as a
beamformee in VHT mode should be reported by the firmware and should not
be greater than the number of receiving antennas - 1. The num_rx_chains
related nss rather than nsts.

If STBC is enabled, nsts is greater than nss. About nss are mapped to
nsts, refer to IEEE Std 802.11-2020: 19.3.11.9.2 Space-time block coding
(STBC), Table 19-18—Constellation mapper output to spatial mapper input
for STBC.

Remove wrong overriding for nsts of VHT Beamformee STS Capability,
acting DL MU-MIMO in VHT mode is working properly.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-04479-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Fixes: 55b5ee3357d7 ("wifi: ath11k: fix number of VHT beamformee spatial streams")
Signed-off-by: Yu Zhang (Yuriy) <quic_yuzha@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250124075953.2282354-1-quic_yuzha@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1556392f7ad48..1298a3190a3c5 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5336,8 +5336,6 @@ static int ath11k_mac_set_txbf_conf(struct ath11k_vif *arvif)
 	if (vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)) {
 		nsts = vht_cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 		nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
-		if (nsts > (ar->num_rx_chains - 1))
-			nsts = ar->num_rx_chains - 1;
 		value |= SM(nsts, WMI_TXBF_STS_CAP_OFFSET);
 	}
 
@@ -5421,9 +5419,6 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 
 	/* Enable Beamformee STS Field only if SU BF is enabled */
 	if (subfee) {
-		if (nsts > (ar->num_rx_chains - 1))
-			nsts = ar->num_rx_chains - 1;
-
 		nsts <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
 		nsts &=  IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 		*vht_cap |= nsts;
-- 
2.39.5



