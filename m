Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E30274B35;
	Tue, 21 Oct 2025 20:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077323; cv=none; b=VvWkCUlLS+fDmLx0y3CUln0f+7LZQJ66u7PP8zt4iOM2t0bOY0XLPFx7IEhIG5AjGsPBwUKhH/mpCLaFFn8N1qs4X3Ere91FUY+dJRxLQ9RKOpxn8AElFpOqaBkGgOS46tC6Z07luR3+ADJe/CgKetdQ7bQHzB9B9zPDDluKSVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077323; c=relaxed/simple;
	bh=m6IrAL2QNFekNd05qrTpwSuzLKNjxrXMkbTK7GDCJS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYks6rMjM9f1AmI+YEObamnH+/XfrRHyngVMzcqBmd32btmjcEGRRH+61QaT3tKg3PMf1uiIhPhIiPjUK3Y+atnpf4ypBblDWiGhs/gpfOrhrZDia5zqQluaa6PJLIdb4f/xSekVtx4h+EImjAJOo5rZ/fqKMfDT8jcC13mMCN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlE1kyxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlE1kyxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471DCC4CEF7;
	Tue, 21 Oct 2025 20:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077322;
	bh=m6IrAL2QNFekNd05qrTpwSuzLKNjxrXMkbTK7GDCJS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlE1kyxyf3nzIcTjpuI7N1b1eQWZMif3vAW0NEgIyojn2G6Bk1Af/mzcjcXygml7X
	 5BKrXUHtrqfiGrnBsovAsUi9ShvYugWL+6roEP0dRmzjTGviN8mw91DP7eusmv5Qxc
	 Z34+OzJVLXp40Yup40jzDbfQhbCHQax0HxEh+bgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 069/159] dpll: zl3073x: Handle missing or corrupted flash configuration
Date: Tue, 21 Oct 2025 21:50:46 +0200
Message-ID: <20251021195044.866855085@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit fcb8b32a68fd40b0440cb9468cf6f6ab9de9f3c5 ]

If the internal flash contains missing or corrupted configuration,
basic communication over the bus still functions, but the device
is not capable of normal operation (for example, using mailboxes).

This condition is indicated in the info register by the ready bit.
If this bit is cleared, the probe procedure times out while fetching
the device state.

Handle this case by checking the ready bit value in zl3073x_dev_start()
and skipping DPLL device and pin registration if it is cleared.
Do not report this condition as an error, allowing the devlink device
to be registered and enabling the user to flash the correct configuration.

Prior this patch:
[   31.112299] zl3073x-i2c 1-0070: Failed to fetch input state: -ETIMEDOUT
[   31.116332] zl3073x-i2c 1-0070: error -ETIMEDOUT: Failed to start device
[   31.136881] zl3073x-i2c 1-0070: probe with driver zl3073x-i2c failed with error -110

After this patch:
[   41.011438] zl3073x-i2c 1-0070: FW not fully ready - missing or corrupted config

Fixes: 75a71ecc24125 ("dpll: zl3073x: Register DPLL devices and pins")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251008141445.841113-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/core.c | 21 +++++++++++++++++++++
 drivers/dpll/zl3073x/regs.h |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/drivers/dpll/zl3073x/core.c b/drivers/dpll/zl3073x/core.c
index 0df210cec08da..59c75b470efbf 100644
--- a/drivers/dpll/zl3073x/core.c
+++ b/drivers/dpll/zl3073x/core.c
@@ -864,8 +864,29 @@ zl3073x_dev_phase_meas_setup(struct zl3073x_dev *zldev)
 int zl3073x_dev_start(struct zl3073x_dev *zldev, bool full)
 {
 	struct zl3073x_dpll *zldpll;
+	u8 info;
 	int rc;
 
+	rc = zl3073x_read_u8(zldev, ZL_REG_INFO, &info);
+	if (rc) {
+		dev_err(zldev->dev, "Failed to read device status info\n");
+		return rc;
+	}
+
+	if (!FIELD_GET(ZL_INFO_READY, info)) {
+		/* The ready bit indicates that the firmware was successfully
+		 * configured and is ready for normal operation. If it is
+		 * cleared then the configuration stored in flash is wrong
+		 * or missing. In this situation the driver will expose
+		 * only devlink interface to give an opportunity to flash
+		 * the correct config.
+		 */
+		dev_info(zldev->dev,
+			 "FW not fully ready - missing or corrupted config\n");
+
+		return 0;
+	}
+
 	if (full) {
 		/* Fetch device state */
 		rc = zl3073x_dev_state_fetch(zldev);
diff --git a/drivers/dpll/zl3073x/regs.h b/drivers/dpll/zl3073x/regs.h
index 614e33128a5c9..bb9965b8e8c75 100644
--- a/drivers/dpll/zl3073x/regs.h
+++ b/drivers/dpll/zl3073x/regs.h
@@ -67,6 +67,9 @@
  * Register Page 0, General
  **************************/
 
+#define ZL_REG_INFO				ZL_REG(0, 0x00, 1)
+#define ZL_INFO_READY				BIT(7)
+
 #define ZL_REG_ID				ZL_REG(0, 0x01, 2)
 #define ZL_REG_REVISION				ZL_REG(0, 0x03, 2)
 #define ZL_REG_FW_VER				ZL_REG(0, 0x05, 2)
-- 
2.51.0



