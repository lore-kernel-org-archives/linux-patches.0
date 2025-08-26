Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE90350D66;
	Tue, 26 Aug 2025 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216297; cv=none; b=EG3CPLp7FOx62AEGw/D2vm31kwVZwNdTLuQQDuWycjv7q6tyRfzUuG0pSFQ6opCkEK8gsFXHb0ST4vncuFjzc8TroimSVQSyAP+UI9uKaafVXdh5ImSAmsQul07HeR4S9WuJyU6dcjpWAc3FRBbwKkq3VW4rvTMC+3gAklvs1GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216297; c=relaxed/simple;
	bh=b1N/2ISG+h443SYYJ9MRdcFHXxwuzaYaP35m/1IYV6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMDvi4mfvf0i7sH6E/DEs4vBGe4yLNs0BMaYXq5VBn1EvX1GA0GzMRWoWmvxSlqxUvA0IKCTA5m/d0HGGA04qIFz3CXXr+df9fRbS/ZBzyOuyYnrIoHiSjazcbpErvH5lZSIlRADpNdhXu1Vio7q23oyv0vo3WhVw6289ON7Zr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8VIRGfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8VIRGfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BC0C4CEF1;
	Tue, 26 Aug 2025 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216297;
	bh=b1N/2ISG+h443SYYJ9MRdcFHXxwuzaYaP35m/1IYV6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8VIRGfb5xMk6VXwprAF4VYdE4QsIDhF/BQReD4AY81h6X+CHujjb0zoZQ3X0KAth
	 JbK5cWZIFAB9SgzplEzXYXaY8d6YRbk3rEEyQuDix7qiq0pOmgwpZD0yjWDh/CFkf8
	 DuuHOlwzALPheIWw4wxjzOi5mmKo1SW6iYU5U3Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Work <work.eric@gmail.com>,
	Igor Russkikh <irusskikh@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Mark Starovoitov <mstarovoitov@marvell.com>,
	Dmitry Bogdanov <dbogdanov@marvell.com>,
	Pavel Belous <pbelous@marvell.com>,
	Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH 5.15 359/644] net: atlantic: add set_power to fw_ops for atl2 to fix wol
Date: Tue, 26 Aug 2025 13:07:30 +0200
Message-ID: <20250826110955.304489384@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Work <work.eric@gmail.com>

[ Upstream commit fad9cf216597a71936ac87143d1618fbbcf97cbe ]

Aquantia AQC113(C) using ATL2FW doesn't properly prepare the NIC for
enabling wake-on-lan. The FW operation `set_power` was only implemented
for `hw_atl` and not `hw_atl2`. Implement the `set_power` functionality
for `hw_atl2`.

Tested with both AQC113 and AQC113C devices. Confirmed you can shutdown
the system and wake from S5 using magic packets. NIC was previously
powered off when entering S5. If the NIC was configured for WOL by the
Windows driver, loading the atlantic driver would disable WOL.

Partially cherry-picks changes from commit,
https://github.com/Aquantia/AQtion/commit/37bd5cc

Attributing original authors from Marvell for the referenced commit.

Closes: https://github.com/Aquantia/AQtion/issues/70
Co-developed-by: Igor Russkikh <irusskikh@marvell.com>
Co-developed-by: Mark Starovoitov <mstarovoitov@marvell.com>
Co-developed-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Co-developed-by: Pavel Belous <pbelous@marvell.com>
Co-developed-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Eric Work <work.eric@gmail.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Link: https://patch.msgid.link/20250629051535.5172-1-work.eric@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 +
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 39 +++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index dbd284660135..7f616abd3db2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -113,6 +113,8 @@ struct aq_stats_s {
 #define AQ_HW_POWER_STATE_D0   0U
 #define AQ_HW_POWER_STATE_D3   3U
 
+#define	AQ_FW_WAKE_ON_LINK_RTPM BIT(10)
+
 #define AQ_HW_FLAG_STARTED     0x00000004U
 #define AQ_HW_FLAG_STOPPING    0x00000008U
 #define AQ_HW_FLAG_RESETTING   0x00000010U
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index 58d426dda3ed..1c5c27a9f30d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -462,6 +462,44 @@ static int aq_a2_fw_get_mac_temp(struct aq_hw_s *self, int *temp)
 	return aq_a2_fw_get_phy_temp(self, temp);
 }
 
+static int aq_a2_fw_set_wol_params(struct aq_hw_s *self, const u8 *mac, u32 wol)
+{
+	struct mac_address_aligned_s mac_address;
+	struct link_control_s link_control;
+	struct wake_on_lan_s wake_on_lan;
+
+	memcpy(mac_address.aligned.mac_address, mac, ETH_ALEN);
+	hw_atl2_shared_buffer_write(self, mac_address, mac_address);
+
+	memset(&wake_on_lan, 0, sizeof(wake_on_lan));
+
+	if (wol & WAKE_MAGIC)
+		wake_on_lan.wake_on_magic_packet = 1U;
+
+	if (wol & (WAKE_PHY | AQ_FW_WAKE_ON_LINK_RTPM))
+		wake_on_lan.wake_on_link_up = 1U;
+
+	hw_atl2_shared_buffer_write(self, sleep_proxy, wake_on_lan);
+
+	hw_atl2_shared_buffer_get(self, link_control, link_control);
+	link_control.mode = AQ_HOST_MODE_SLEEP_PROXY;
+	hw_atl2_shared_buffer_write(self, link_control, link_control);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
+static int aq_a2_fw_set_power(struct aq_hw_s *self, unsigned int power_state,
+			      const u8 *mac)
+{
+	u32 wol = self->aq_nic_cfg->wol;
+	int err = 0;
+
+	if (wol)
+		err = aq_a2_fw_set_wol_params(self, mac, wol);
+
+	return err;
+}
+
 static int aq_a2_fw_set_eee_rate(struct aq_hw_s *self, u32 speed)
 {
 	struct link_options_s link_options;
@@ -605,6 +643,7 @@ const struct aq_fw_ops aq_a2_fw_ops = {
 	.set_state          = aq_a2_fw_set_state,
 	.update_link_status = aq_a2_fw_update_link_status,
 	.update_stats       = aq_a2_fw_update_stats,
+	.set_power          = aq_a2_fw_set_power,
 	.get_mac_temp       = aq_a2_fw_get_mac_temp,
 	.get_phy_temp       = aq_a2_fw_get_phy_temp,
 	.set_eee_rate       = aq_a2_fw_set_eee_rate,
-- 
2.39.5



