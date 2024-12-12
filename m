Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AF2748A;
	Thu, 12 Dec 2024 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017210; cv=none; b=U69eLt74xTW+PPMM0EejyPfHqCwOs19DUNMCL2Le2LlV+pahwQ2kv1NDMtnnz4k3f+bb8p6/exNhmlbm2y1qoMu3H45KgwdJyjMigslxMNxQ8KmVcWfUc2QPHMhTpG1oGbzzA28EwcXL/NAFQLsd2gUK2/Xrpjff+cSdxiEzvYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017210; c=relaxed/simple;
	bh=ndYsC6+L760ohEsfPvWsoLNpyK1FZ2obiPASGZQ/hxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwQXqtDyuW2DLWMSwzh2BRrys9/sgEkySdYGy3OJPImW/vbtgDet6VlUF/3GTNX8DcgH5QQ5Yu4UIMRnkSzTerwRVt9gI+g/ymYVyiiL6V2IHxRvYTa4cwHBhJuvn9iLob7gHeu9KygBK4zc1975i/cSSAB0cUpd/upn+gG3xk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLgRCYBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLgRCYBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AC7C4CECE;
	Thu, 12 Dec 2024 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017210;
	bh=ndYsC6+L760ohEsfPvWsoLNpyK1FZ2obiPASGZQ/hxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLgRCYBQH//xMEOFF1dBpFYuUgOGyEsvt8SkGAZfNTYMeBj0qCwbtV8j/SAY0uosK
	 UXtneJD3cG4AN+E2DhTJIU3kMpSgBc55cbcyUsUISKYV+CoeGS3yMhdSABI186Tpdi
	 sKOVaoa1Nbh2bm9GAQAAfnSxtc06Hr+0mW4aGvts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Saranya Gopal <saranya.gopal@intel.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 413/466] usb: typec: ucsi: Do not call ACPI _DSM method for UCSI read operations
Date: Thu, 12 Dec 2024 15:59:42 +0100
Message-ID: <20241212144323.075341493@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saranya Gopal <saranya.gopal@intel.com>

[ Upstream commit fa48d7e81624efdf398b990a9049e9cd75a5aead ]

ACPI _DSM methods are needed only for UCSI write operations and for reading
CCI during RESET_PPM operation. So, remove _DSM calls from other places.
While there, remove the Zenbook quirk also since the default behavior
now aligns with the Zenbook quirk. With this change, GET_CONNECTOR_STATUS
returns at least 6 seconds faster than before in Arrowlake-S platforms.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
Reviewed-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://lore.kernel.org/r/20240830084342.460109-1-saranya.gopal@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 56 +++---------------------------
 1 file changed, 5 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 7a5dff8d9cc6c..accf15ff1306a 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -61,9 +61,11 @@ static int ucsi_acpi_read_cci(struct ucsi *ucsi, u32 *cci)
 	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
 	int ret;
 
-	ret = ucsi_acpi_dsm(ua, UCSI_DSM_FUNC_READ);
-	if (ret)
-		return ret;
+	if (UCSI_COMMAND(ua->cmd) == UCSI_PPM_RESET) {
+		ret = ucsi_acpi_dsm(ua, UCSI_DSM_FUNC_READ);
+		if (ret)
+			return ret;
+	}
 
 	memcpy(cci, ua->base + UCSI_CCI, sizeof(*cci));
 
@@ -73,11 +75,6 @@ static int ucsi_acpi_read_cci(struct ucsi *ucsi, u32 *cci)
 static int ucsi_acpi_read_message_in(struct ucsi *ucsi, void *val, size_t val_len)
 {
 	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
-	int ret;
-
-	ret = ucsi_acpi_dsm(ua, UCSI_DSM_FUNC_READ);
-	if (ret)
-		return ret;
 
 	memcpy(val, ua->base + UCSI_MESSAGE_IN, val_len);
 
@@ -102,42 +99,6 @@ static const struct ucsi_operations ucsi_acpi_ops = {
 	.async_control = ucsi_acpi_async_control
 };
 
-static int
-ucsi_zenbook_read_cci(struct ucsi *ucsi, u32 *cci)
-{
-	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
-	int ret;
-
-	if (UCSI_COMMAND(ua->cmd) == UCSI_PPM_RESET) {
-		ret = ucsi_acpi_dsm(ua, UCSI_DSM_FUNC_READ);
-		if (ret)
-			return ret;
-	}
-
-	memcpy(cci, ua->base + UCSI_CCI, sizeof(*cci));
-
-	return 0;
-}
-
-static int
-ucsi_zenbook_read_message_in(struct ucsi *ucsi, void *val, size_t val_len)
-{
-	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
-
-	/* UCSI_MESSAGE_IN is never read for PPM_RESET, return stored data */
-	memcpy(val, ua->base + UCSI_MESSAGE_IN, val_len);
-
-	return 0;
-}
-
-static const struct ucsi_operations ucsi_zenbook_ops = {
-	.read_version = ucsi_acpi_read_version,
-	.read_cci = ucsi_zenbook_read_cci,
-	.read_message_in = ucsi_zenbook_read_message_in,
-	.sync_control = ucsi_sync_control_common,
-	.async_control = ucsi_acpi_async_control
-};
-
 static int ucsi_gram_read_message_in(struct ucsi *ucsi, void *val, size_t val_len)
 {
 	u16 bogus_change = UCSI_CONSTAT_POWER_LEVEL_CHANGE |
@@ -190,13 +151,6 @@ static const struct ucsi_operations ucsi_gram_ops = {
 };
 
 static const struct dmi_system_id ucsi_acpi_quirks[] = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
-		},
-		.driver_data = (void *)&ucsi_zenbook_ops,
-	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
-- 
2.43.0



