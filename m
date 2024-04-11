Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8219113FD94;
	Thu, 11 Apr 2024 10:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831134; cv=none; b=E7S5M4F3YrJYJr+OIjKTkbRPgtx7G4pyUUPLl8yDkerWeIodCO9/wt45SDqsVaQ1QWfQtPq17XePw562XJYFSSP/DbxjKtQlvxnxJQmzLp8s5zTpa/J+mptEi2cN+B8MuOT2dJvz9P3X1LVPfcTNIj0+jEBBBYJlmEHSy7wiS1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831134; c=relaxed/simple;
	bh=FWqtL5aYxHRvCd9vHicFiYYjW1hHV3sLx/gpEZ0715c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkoejvuOC59Ct8WvgqphiBpt2/K70c/ADZIXdfRCJvIUh7n31kF8ANArbvFycW0mfaNB6tPUFY0g0fXkTS8Qss50WkP8oJcsGlYRRZpOibNq6XQesOiz3kXiKECTaYB4sml1NN7Uoc4FPILWcADzSSzDNo5tMXQ9UMgqijzzEF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPaSOJfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPaSOJfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B76C433F1;
	Thu, 11 Apr 2024 10:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831134;
	bh=FWqtL5aYxHRvCd9vHicFiYYjW1hHV3sLx/gpEZ0715c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPaSOJfbRyj69PsDAtPriy+5YqJYi334i9u5gtGlq/rMLECAsTkM/ZR8LH+Mp45xp
	 77PrxK78ghFILgRRePY3A+eivydk2Zqr3a5ND9ad4vDTh0eVgmw4bQ0ekVeblgT9Yj
	 rQ098H0V0+cJuHxfE21rSJ9T3CF889xKTxfzt6Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ariel Elior <aelior@marvell.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/114] bnx2x: Fix firmware version string character counts
Date: Thu, 11 Apr 2024 11:55:30 +0200
Message-ID: <20240411095416.962680849@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 5642c82b9463c3263c086efb002516244bd4c668 ]

A potential string truncation was reported in bnx2x_fill_fw_str(),
when a long bp->fw_ver and a long phy_fw_ver might coexist, but seems
unlikely with real-world hardware.

Use scnprintf() to indicate the intent that truncations are tolerated.

While reading this code, I found a collection of various buffer size
counting issues. None looked like they might lead to a buffer overflow
with current code (the small buffers are 20 bytes and might only ever
consume 10 bytes twice with a trailing %NUL). However, early truncation
(due to a %NUL in the middle of the string) might be happening under
likely rare conditions. Regardless fix the formatters and related
functions:

- Switch from a separate strscpy() to just adding an additional "%s" to
  the format string that immediately follows it in bnx2x_fill_fw_str().
- Use sizeof() universally instead of using unbound defines.
- Fix bnx2x_7101_format_ver() and bnx2x_null_format_ver() to report the
  number of characters written, not including the trailing %NUL (as
  already done with the other firmware formatting functions).
- Require space for at least 1 byte in bnx2x_get_ext_phy_fw_version()
  for the trailing %NUL.
- Correct the needed buffer size in bnx2x_3_seq_format_ver().

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401260858.jZN6vD1k-lkp@intel.com/
Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20240126041044.work.220-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  9 +++++----
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   | 14 +++++++-------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e9c1e1bb55806..528441b28c4ef 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -147,10 +147,11 @@ void bnx2x_fill_fw_str(struct bnx2x *bp, char *buf, size_t buf_len)
 
 		phy_fw_ver[0] = '\0';
 		bnx2x_get_ext_phy_fw_version(&bp->link_params,
-					     phy_fw_ver, PHY_FW_VER_LEN);
-		strscpy(buf, bp->fw_ver, buf_len);
-		snprintf(buf + strlen(bp->fw_ver), 32 - strlen(bp->fw_ver),
-			 "bc %d.%d.%d%s%s",
+					     phy_fw_ver, sizeof(phy_fw_ver));
+		/* This may become truncated. */
+		scnprintf(buf, buf_len,
+			 "%sbc %d.%d.%d%s%s",
+			 bp->fw_ver,
 			 (bp->common.bc_ver & 0xff0000) >> 16,
 			 (bp->common.bc_ver & 0xff00) >> 8,
 			 (bp->common.bc_ver & 0xff),
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index bda3ccc28eca6..f920976c36f0c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1132,7 +1132,7 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 	}
 
 	memset(version, 0, sizeof(version));
-	bnx2x_fill_fw_str(bp, version, ETHTOOL_FWVERS_LEN);
+	bnx2x_fill_fw_str(bp, version, sizeof(version));
 	strlcat(info->fw_version, version, sizeof(info->fw_version));
 
 	strscpy(info->bus_info, pci_name(bp->pdev), sizeof(info->bus_info));
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 02808513ffe45..ea310057fe3af 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -6163,8 +6163,8 @@ static void bnx2x_link_int_ack(struct link_params *params,
 
 static int bnx2x_null_format_ver(u32 spirom_ver, u8 *str, u16 *len)
 {
-	str[0] = '\0';
-	(*len)--;
+	if (*len)
+		str[0] = '\0';
 	return 0;
 }
 
@@ -6173,7 +6173,7 @@ static int bnx2x_format_ver(u32 num, u8 *str, u16 *len)
 	u16 ret;
 
 	if (*len < 10) {
-		/* Need more than 10chars for this format */
+		/* Need more than 10 chars for this format */
 		bnx2x_null_format_ver(num, str, len);
 		return -EINVAL;
 	}
@@ -6188,8 +6188,8 @@ static int bnx2x_3_seq_format_ver(u32 num, u8 *str, u16 *len)
 {
 	u16 ret;
 
-	if (*len < 10) {
-		/* Need more than 10chars for this format */
+	if (*len < 9) {
+		/* Need more than 9 chars for this format */
 		bnx2x_null_format_ver(num, str, len);
 		return -EINVAL;
 	}
@@ -6208,7 +6208,7 @@ int bnx2x_get_ext_phy_fw_version(struct link_params *params, u8 *version,
 	int status = 0;
 	u8 *ver_p = version;
 	u16 remain_len = len;
-	if (version == NULL || params == NULL)
+	if (version == NULL || params == NULL || len == 0)
 		return -EINVAL;
 	bp = params->bp;
 
@@ -11546,7 +11546,7 @@ static int bnx2x_7101_format_ver(u32 spirom_ver, u8 *str, u16 *len)
 	str[2] = (spirom_ver & 0xFF0000) >> 16;
 	str[3] = (spirom_ver & 0xFF000000) >> 24;
 	str[4] = '\0';
-	*len -= 5;
+	*len -= 4;
 	return 0;
 }
 
-- 
2.43.0



