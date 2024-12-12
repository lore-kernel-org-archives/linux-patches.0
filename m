Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F81822A81A;
	Thu, 12 Dec 2024 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022228; cv=none; b=kl9YUyGjr+i4JRfgpRXGN+vmbEspenwSFFi418xZabe9sDwZKHnUTnSYmP/aFcCqf0b3wWZ6xii+Tw/oHwPPc8H/JrZ6qwZNm6a0c6B3FNkrI3/AE0ESI/Pz5S1/JYDZQkrcuDRmjUfkZGNS0Husd3LgXdYXqAplEYUXcMZ5hQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022228; c=relaxed/simple;
	bh=jMgPekBpSOBrTLfQux4pVcZ3Ixu3bAou0zM83q+OQKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfRT/bGXzwC7Fpf2rHCtYCRJEUResPq+h+K6rsQIAFUbJnLP37OQr9OepK2PZT2vvrn0FqAQdoJReqSTNR3vKmKdgJY0L39Tepqv2jYfK8UsIm9B3cj47tLDFrgUb8qgiTooDy/9ZQo7NA2k5ya1bzVg0G1vFA6zcJgWCyO9iRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7dFBwsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7dFBwsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F008C4CECE;
	Thu, 12 Dec 2024 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022227;
	bh=jMgPekBpSOBrTLfQux4pVcZ3Ixu3bAou0zM83q+OQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7dFBwsznLCqTnlJOX8wJ6h82tucw/OgtDPgdWM/PzomZ/rrsrivgaGCF2XQkfoor
	 OeDzDAOlLXxFrIk2TxpO4CEE54E60D7bpLRp1OEGYmJ2oHIMkWPNXQH9jXxcJQ/RHo
	 S6AF38eGEgFPsyymn1tAjvKvTCwWmuAoTHXHaFZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/565] wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss1
Date: Thu, 12 Dec 2024 15:55:50 +0100
Message-ID: <20241212144317.607223022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit d50886b27850447d90c0cd40c725238097909d1e ]

In supported_vht_mcs_rate_nss1, the rate for MCS9 & VHT20 is defined as
{780,  867}, this does not align with firmware's definition and therefore
fails the verification in ath10k_mac_get_rate_flags_vht():

	invalid vht params rate 960 100kbps nss 1 mcs 9

Change it to {865,  960} to align with firmware, so this issue could be
fixed.

Since ath10k_hw_params::supports_peer_stats_info is enabled only for
QCA6174, this change does not affect other chips.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-QCARMSWPZ-1

Fixes: 3344b99d69ab ("ath10k: add bitrate parse for peer stats info")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/lkml/fba24cd3-4a1e-4072-8585-8402272788ff@molgen.mpg.de/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240711020344.98040-2-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8208434d7d2b2..f91251770250f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9066,7 +9066,7 @@ static const struct ath10k_index_vht_data_rate_type supported_vht_mcs_rate_nss1[
 	{6,  {2633, 2925}, {1215, 1350}, {585,  650} },
 	{7,  {2925, 3250}, {1350, 1500}, {650,  722} },
 	{8,  {3510, 3900}, {1620, 1800}, {780,  867} },
-	{9,  {3900, 4333}, {1800, 2000}, {780,  867} }
+	{9,  {3900, 4333}, {1800, 2000}, {865,  960} }
 };
 
 /*MCS parameters with Nss = 2 */
-- 
2.43.0



