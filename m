Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930491ABED9;
	Mon, 14 Oct 2024 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919585; cv=none; b=W70QtfX8tCR+Q1c+jHuuS10GAAIxqNfY/ZUTfjBru6G1ezUoxocxOLxq/D25R2T7S3Jr1K6bBT4M7Sed2q7TpTL6rlk6xr1Di6PE9V1a5yKYupGoiB5MLV8amhFOxqIwXlmfVwZBf45rKsuqyIuBaLoP1GC0QSrJuRGdPHUpG7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919585; c=relaxed/simple;
	bh=3ylmk6bUHZWi0kNHJZwfavyZn7Ty412doigiViyvUqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTdCZnOkF8YD8b2NVQQFcOd0UPaB086OsPneMmGPyCXjpNRUrIOuGKSUMBSgy0hIzVCCfkmeOXq9+DU+/M4iTsx9v7iEeOQmFOuFmkV++KPniYSYQ4z0bCVDer7XGtiAWlYPYC8VtqRyQDqmwTN9tCEYC0LAWUzl9g7/LV/PBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1aPWp6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1aPWp6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4225C4CEC3;
	Mon, 14 Oct 2024 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919585;
	bh=3ylmk6bUHZWi0kNHJZwfavyZn7Ty412doigiViyvUqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1aPWp6OkLn2ib3aYJotBtT7yEZKzRwsTtsfo65Ch6qFp58RSP39kAnV2D34Yv/BN
	 F6v1BbjovbxTwMTu70tR1LI3CaoDeAK0WnYo+GVHRctiAwVRNW50WCrXDtaZtz9mJP
	 BgcxJpU9tMfrps0Wbnh+8ugRdJzESq6gyQz0TINo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 649/798] r8169: add tally counter fields added with RTL8125
Date: Mon, 14 Oct 2024 16:20:03 +0200
Message-ID: <20241014141243.549182966@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ced8e8b8f40accfcce4a2bbd8b150aa76d5eff9a ]

RTL8125 added fields to the tally counter, what may result in the chip
dma'ing these new fields to unallocated memory. Therefore make sure
that the allocated memory area is big enough to hold all of the
tally counter values, even if we use only parts of it.

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/741d26a9-2b2b-485d-91d9-ecb302e345b5@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 27 +++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index beebb2dcd00f5..8b35e14fba3a8 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -564,6 +564,33 @@ struct rtl8169_counters {
 	__le32	rx_multicast;
 	__le16	tx_aborted;
 	__le16	tx_underrun;
+	/* new since RTL8125 */
+	__le64 tx_octets;
+	__le64 rx_octets;
+	__le64 rx_multicast64;
+	__le64 tx_unicast64;
+	__le64 tx_broadcast64;
+	__le64 tx_multicast64;
+	__le32 tx_pause_on;
+	__le32 tx_pause_off;
+	__le32 tx_pause_all;
+	__le32 tx_deferred;
+	__le32 tx_late_collision;
+	__le32 tx_all_collision;
+	__le32 tx_aborted32;
+	__le32 align_errors32;
+	__le32 rx_frame_too_long;
+	__le32 rx_runt;
+	__le32 rx_pause_on;
+	__le32 rx_pause_off;
+	__le32 rx_pause_all;
+	__le32 rx_unknown_opcode;
+	__le32 rx_mac_error;
+	__le32 tx_underrun32;
+	__le32 rx_mac_missed;
+	__le32 rx_tcam_dropped;
+	__le32 tdu;
+	__le32 rdu;
 };
 
 struct rtl8169_tc_offsets {
-- 
2.43.0



