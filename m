Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5770C2D7393;
	Thu, 30 Jul 2026 15:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423774; cv=none; b=OYkLnhyOahMmTJFHGQIDoHmi3Mq0QMFiTuSwtRH1u6F3HCQf9CMjQKhqvMkmclPozbsFAYQj5/7BmsL4FE6lUcJEOOn/rNd48tlJ8/B18n6PptmrmPr23tCVN4mwqifmsws2pxSgrkqpt7fMhW8VplEwJzG5TfvZ0tag6hRYYfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423774; c=relaxed/simple;
	bh=tPXDPGjR9V2M5uPC2f2O+Ii5B0pMXgJlnvFJzXAJyxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgILSB9prj7+963JRT+nPNT75IUxvDCWPRAofQS/0skw9z2b6ijtu7fVd5KHMBIjNZUlngJq3qwTmAOKeyahywKF2YXuxyAOIWpEYvpItkacGlveIMk2PtLjX/Xabh/itwR41fpzUOPH4y7JwiesvOPy2lfi6WmRbL82C2BgQ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkNgEFQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkNgEFQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD61F1F000E9;
	Thu, 30 Jul 2026 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423773;
	bh=oGzjDC4oMMBIYlC9UgGkRo6q5F0bAuHOERlo6QgnoGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkNgEFQWoNF1C5QAiWdT9e5xzhYytcvPtKY1OJP4/BGpUiBJae2E8GaLezv/uZqhp
	 isINCDV23tDJd/i5O71RxjIiygSoU+rMRT/IZGuPDYfJNj+b8YYEELu8Adcq5YT69G
	 VVU9JCxRCrEClG3My8TbOYRoRZKtWn9HKs7Lw15s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgi Valkov <gvalkov@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/675] wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware
Date: Thu, 30 Jul 2026 16:08:10 +0200
Message-ID: <20260730141448.535658958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgi Valkov <gvalkov@gmail.com>

[ Upstream commit 121a96c5a0db8d18e2ba2cb89660cca8a40508fe ]

Fix regression in rgpower table loading, caused by using
request_firmware(): when the requested firmware does not exist, e.g.
nxp/rgpower_WW.bin does not exist on OpenWRT builds for WRT3200ACM,
request_firmware() falls back to firmware_fallback_sysfs(), which expects
the firmware to be provided by user space using SYSFS. No such utility is
provided in this configuration, so the entire system locks up for 60
seconds, until the request times out. During this time, no other log
messages are observed, and the device does not respond to commands over
UART.

The request_firmware() call is performed in the following context:
current->comm kworker/1:2  in_task 1  irqs_disabled 0  in_atomic 0

Fixed by using request_firmware_direct(). This prevents fallback to SYSFS,
and avoids delay. The rgpower table is optional. The driver falls back
to the device tree power table if the firmware is not present.

The error code is printed for debugging and returned to the caller,
which only cares for success or failure, so there are no side effects.

Fixes: 7b6f16a25806 ("wifi: mwifiex: add rgpower table loading support")
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260712221709.7099-1-gvalkov@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index ef6722ffdc74d8..358de94eeb5ed9 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -196,6 +196,7 @@ static int mwifiex_request_rgpower_table(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	char rgpower_table_name[30];
 	char country_code[3];
+	int ret;
 
 	strscpy(country_code, domain_info->country_code, sizeof(country_code));
 
@@ -214,16 +215,17 @@ static int mwifiex_request_rgpower_table(struct mwifiex_private *priv)
 		adapter->rgpower_data = NULL;
 	}
 
-	if ((request_firmware(&adapter->rgpower_data, rgpower_table_name,
-			      adapter->dev))) {
+	ret = request_firmware_direct(&adapter->rgpower_data, rgpower_table_name,
+				      adapter->dev);
+
+	if (ret) {
 		mwifiex_dbg(
 			adapter, INFO,
-			"info: %s: failed to request regulatory power table\n",
-			__func__);
-		return -EIO;
+			"info: %s: failed to request regulatory power table: %d\n",
+			__func__, ret);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mwifiex_dnld_rgpower_table(struct mwifiex_private *priv)
-- 
2.53.0



