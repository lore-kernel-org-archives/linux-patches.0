Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB79B213E99;
	Thu, 12 Dec 2024 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022242; cv=none; b=eYIwEoVttPPSSr80m8l71JkEj9pG4B3a/hzdiwL/3F4eyE7q+CqBOk/3oEgTLqPNiW1PB1aFJVLO3eK3gkt8x9v9l+V6N+NFqRjWe3d1qHbQIU64C+6edu4pOav0Nyl2JhIvK3g3YEkyXCYOqbt7mh+9CVJvlWbzLWx+jxdSIpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022242; c=relaxed/simple;
	bh=3lMzk6nRlFrS1uC7rUq4MzFwIbodf8uJSwFzlgUnQ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW2uwUKr0B7jB/VmwYtx2hZQWboYcU8kRbKFkokYL8jRdmTBblLLQiNDi7/22Vfr+Utr3YRQZfgtFkie6ktZGR9vvCksTtgs83CHqSb6d9gNjPOWvVXAPMOYs8ZVVi5i8npGyG4a2MKli549HiQwisyL+ggW75GV4e6BHlo8Bcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqokpd6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqokpd6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F9EC4CECE;
	Thu, 12 Dec 2024 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022241;
	bh=3lMzk6nRlFrS1uC7rUq4MzFwIbodf8uJSwFzlgUnQ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqokpd6zvJ+tsW4YItL1vy4DMu/+c4X3d8rcRvslzcgtojvboLSGfVPH9b67e3VkE
	 +KkMNADwVALP2s7j8xYnYUViCsNuADi6sPSqOzoxHyAMMoRzf+eEGbcgGmCm842G6n
	 nWUfkGwEnEXswaQEvGaVWy3xbFBwELn8XwKcVZ3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/565] wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss2
Date: Thu, 12 Dec 2024 15:55:51 +0100
Message-ID: <20241212144317.645869778@linuxfoundation.org>
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

[ Upstream commit 52db16ec5bae7bd027804265b968259d1a6c3970 ]

In supported_vht_mcs_rate_nss2, the rate for MCS9 & VHT20 is defined as
{1560, 1733}, this does not align with firmware's definition and therefore
fails the verification in ath10k_mac_get_rate_flags_vht():

	invalid vht params rate 1730 100kbps nss 2 mcs 9

and:

	invalid vht params rate 1920 100kbps nss 2 mcs 9

Change it to {1730,  1920} to align with firmware to fix the issue.

Since ath10k_hw_params::supports_peer_stats_info is enabled only for
QCA6174, this change does not affect other chips.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-QCARMSWPZ-1

Fixes: 3344b99d69ab ("ath10k: add bitrate parse for peer stats info")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/lkml/fba24cd3-4a1e-4072-8585-8402272788ff@molgen.mpg.de/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de> # Dell XPS 13 9360
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240711020344.98040-3-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f91251770250f..2b4c694b0fbbe 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9081,7 +9081,7 @@ static const struct ath10k_index_vht_data_rate_type supported_vht_mcs_rate_nss2[
 	{6,  {5265, 5850}, {2430, 2700}, {1170, 1300} },
 	{7,  {5850, 6500}, {2700, 3000}, {1300, 1444} },
 	{8,  {7020, 7800}, {3240, 3600}, {1560, 1733} },
-	{9,  {7800, 8667}, {3600, 4000}, {1560, 1733} }
+	{9,  {7800, 8667}, {3600, 4000}, {1730, 1920} }
 };
 
 static void ath10k_mac_get_rate_flags_ht(struct ath10k *ar, u32 rate, u8 nss, u8 mcs,
-- 
2.43.0



