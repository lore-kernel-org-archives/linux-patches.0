Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1335D218AAB;
	Mon, 18 Aug 2025 13:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522230; cv=none; b=rjZ+nfUDUafuoItQLRUxKPijqfE0zEec4HpMJsduFA5PD7WcvYQUga65+6yyV4ZAV/XQK7FqeQ+dHvSENW+xeDWE11gaalQAyC0zO0Ssx+15u5ka2ejYRRMUMFU7ul42ICFxhP761tGHfeNkROCE9UtPiNbAlBa4fjtjWa3dK+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522230; c=relaxed/simple;
	bh=9Zv/WiEsGq4YCtKU4C7W3tdMn2rmwgew4Xh02x1/Z9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS+Xr0iVYFJwLumgre7tL2zGw8BSTElHEguiQjCiG8MssmVykofBC5R8Ar0iNseeEsLGF773pbD2i1faggzNATvdO5tRVVujHTz/1p7yXnPdmmablW/CWK7QhLI1ODGzm8Ei7kBTUty3311O3RMNJ4O+QmEy2vb9lt6SrqC3+WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKikqzIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKikqzIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B87C4CEEB;
	Mon, 18 Aug 2025 13:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522229;
	bh=9Zv/WiEsGq4YCtKU4C7W3tdMn2rmwgew4Xh02x1/Z9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKikqzISmCaACOjAw1F2/AKMctVSd3n1riEBn7xvPXbVnmxEiOu//+8ezc11pTnN6
	 Fa4vx7kQ7vjzQPcugHmayB48dXSFftOQ15Ms0yKNITdTwknkvHsrm7NxzF+5LmCX+c
	 oGp/eFh4Axw/B1PqwpcKDM0FWJ3DV3o5uIV2faUw=
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
Subject: [PATCH 6.12 221/444] net: atlantic: add set_power to fw_ops for atl2 to fix wol
Date: Mon, 18 Aug 2025 14:44:07 +0200
Message-ID: <20250818124457.132950857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f010bda61c96..2cd0352a11f4 100644
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
index 52e2070a4a2f..7370e3f76b62 100644
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



