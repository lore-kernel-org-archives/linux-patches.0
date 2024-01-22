Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B885768F0;
	Tue, 23 Jan 2024 02:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975487; cv=none; b=ShwN4P8HVfakIIdZJHnymU5nv3g0RB5b//9DiJ4udvjvmlEBr7Em3hEu8jziNsD8FU9kwFOtadULlvOIIMMxDSk538yEXRtDVKxJ3GXzJgW31kN5Z2orYC4ICCXoTjhtluKRC4rg/yLAQetA2oq40PxqTewmLm26rRkZ+kzvxIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975487; c=relaxed/simple;
	bh=lPzTddU6Myl1Trz+s7b5grwcqoY+UwVJ3Nh435uzSe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+DsUP7S5Bk064gi3+/67r753v+BMmYzmNfv+p7ajljWpysA5v73Z+ewSOzcUkA/ps2LHkapzxDyJ3gqqifl5PVlFnXP7gAFcZj8Pi5Z9kh4Ynu1JeokJsRc8JF8IEXb9eYl7BKMR/Vw2I/qtkvQEYL/hSYTF+6MqQ8sRyEn/qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNasDJYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNasDJYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6129CC433B2;
	Tue, 23 Jan 2024 02:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975487;
	bh=lPzTddU6Myl1Trz+s7b5grwcqoY+UwVJ3Nh435uzSe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNasDJYpbb377FtnIg7Nf7wc9z7ZZO7raEUuw3iflG0wu6Pdi6JfGgPzE1QOxMdZ1
	 6d8dcn3sWud8rhNqvFLMGi0sqWQqWjuJZerPM2dQwK1xN4rnGyG41umH1t4bO/NMz/
	 GanasZmaxXBRRTAx+A3QOcU4C1/gsom+PdSmYNak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lin <yu-hao.lin@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>
Subject: [PATCH 6.6 416/583] wifi: mwifiex: add extra delay for firmware ready
Date: Mon, 22 Jan 2024 15:57:47 -0800
Message-ID: <20240122235824.693143249@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lin <yu-hao.lin@nxp.com>

commit 1c5d463c0770c6fa2037511a24fb17966fd07d97 upstream.

For SDIO IW416, due to a bug, FW may return ready before complete full
initialization. Command timeout may occur at driver load after reboot.
Workaround by adding 100ms delay at checking FW status.

Signed-off-by: David Lin <yu-hao.lin@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Tested-by: Marcel Ziswiler <marcel.ziswiler@toradex.com> # Verdin AM62 (IW416)
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231208234029.2197-1-yu-hao.lin@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c |   19 +++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.h |    2 ++
 2 files changed, 21 insertions(+)

--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -331,6 +331,7 @@ static const struct mwifiex_sdio_device
 	.can_dump_fw = false,
 	.can_auto_tdls = false,
 	.can_ext_scan = false,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
@@ -346,6 +347,7 @@ static const struct mwifiex_sdio_device
 	.can_dump_fw = false,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
@@ -361,6 +363,7 @@ static const struct mwifiex_sdio_device
 	.can_dump_fw = false,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
@@ -376,6 +379,7 @@ static const struct mwifiex_sdio_device
 	.can_dump_fw = true,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
@@ -392,6 +396,7 @@ static const struct mwifiex_sdio_device
 	.fw_dump_enh = true,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8978 = {
@@ -408,6 +413,7 @@ static const struct mwifiex_sdio_device
 	.fw_dump_enh = true,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = true,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
@@ -425,6 +431,7 @@ static const struct mwifiex_sdio_device
 	.fw_dump_enh = true,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
@@ -440,6 +447,7 @@ static const struct mwifiex_sdio_device
 	.can_dump_fw = false,
 	.can_auto_tdls = true,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
@@ -456,6 +464,7 @@ static const struct mwifiex_sdio_device
 	.fw_dump_enh = true,
 	.can_auto_tdls = true,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
@@ -471,6 +480,7 @@ static const struct mwifiex_sdio_device
 	.can_dump_fw = false,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
+	.fw_ready_extra_delay = false,
 };
 
 static struct memory_type_mapping generic_mem_type_map[] = {
@@ -563,6 +573,7 @@ mwifiex_sdio_probe(struct sdio_func *fun
 		card->fw_dump_enh = data->fw_dump_enh;
 		card->can_auto_tdls = data->can_auto_tdls;
 		card->can_ext_scan = data->can_ext_scan;
+		card->fw_ready_extra_delay = data->fw_ready_extra_delay;
 		INIT_WORK(&card->work, mwifiex_sdio_work);
 	}
 
@@ -766,6 +777,7 @@ mwifiex_sdio_read_fw_status(struct mwifi
 static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 				   u32 poll_num)
 {
+	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
 	u16 firmware_stat;
 	u32 tries;
@@ -783,6 +795,13 @@ static int mwifiex_check_fw_status(struc
 		ret = -1;
 	}
 
+	if (card->fw_ready_extra_delay &&
+	    firmware_stat == FIRMWARE_READY_SDIO)
+		/* firmware might pretend to be ready, when it's not.
+		 * Wait a little bit more as a workaround.
+		 */
+		msleep(100);
+
 	return ret;
 }
 
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -258,6 +258,7 @@ struct sdio_mmc_card {
 	bool fw_dump_enh;
 	bool can_auto_tdls;
 	bool can_ext_scan;
+	bool fw_ready_extra_delay;
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
@@ -281,6 +282,7 @@ struct mwifiex_sdio_device {
 	bool fw_dump_enh;
 	bool can_auto_tdls;
 	bool can_ext_scan;
+	bool fw_ready_extra_delay;
 };
 
 /*


