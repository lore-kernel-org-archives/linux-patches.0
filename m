Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCF9374C4;
	Tue,  8 Apr 2025 11:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110817; cv=none; b=Z/y9LMh0U/LUe5sQnTLHgTExwXBDC/zFYM/KD5Wcj+HBQLPh8rlElPxg5KF+0+SMYGg8HwGGLqpHB0wcEqqnZXYxoA9/L0NE1nrvqQiO/2yxIwYUeEhi3rbNQTYnlU/C0ueosFS8M6IBF1WL3/dWyIYrXt/WrlrIRjno9wlCtwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110817; c=relaxed/simple;
	bh=LQBE6+b4vl6inxUTL8qXEW93M8NcphrVy/Ie6KCtpOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5AW5JC2jQNxAr4rzB/+5xA4uGjpaRCwMpPEhCkm799gclAHzT5yjILT1m29gUnWqxEj8g0ccTJSYo5dMV7x9YZeh7oYkFqPRdljEDPcwgB5tdiq17O2p2XyskSqQyREm0+VRkHhFu1oXzITC5qNKCa69/GIm77hbfs2ChZblWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbXtZgkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbXtZgkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D838C4CEE5;
	Tue,  8 Apr 2025 11:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110817;
	bh=LQBE6+b4vl6inxUTL8qXEW93M8NcphrVy/Ie6KCtpOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbXtZgkZeAigytjCeV65tRfkY750GN4U0ZqOTG/bySZuQJHbRwc09F9mJkZvNCl/Z
	 5k29Zp4ZZs6Xs5dGhsmmR0R+tMwVNHYwGAIsQmDBjyIPGGdm6GAQpQAHrWiXXaemXT
	 XOsLRSQqm0ZHHR3UnEl3ptwpz8r1WG+V7HybNWnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 204/731] wifi: mwifiex: Fix premature release of RF calibration data.
Date: Tue,  8 Apr 2025 12:41:41 +0200
Message-ID: <20250408104919.025619561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Chen <jeff.chen_1@nxp.com>

[ Upstream commit 69ae7e1f73abae20f26e3536ca4a980b90eafeb7 ]

This patch resolves an issue where RF calibration data was being
released before the download process. Without this fix, the
external calibration data file would not be downloaded
at all.

Fixes: d39fbc88956e ("mwifiex: remove cfg_data construction")
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/20250318050739.2239376-2-jeff.chen_1@nxp.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c    | 4 ----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 6 +++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 855019fe54858..80fc6d5afe860 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -691,10 +691,6 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 	init_failed = true;
 done:
-	if (adapter->cal_data) {
-		release_firmware(adapter->cal_data);
-		adapter->cal_data = NULL;
-	}
 	if (adapter->firmware) {
 		release_firmware(adapter->firmware);
 		adapter->firmware = NULL;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index e2800a831c8ed..c0e6ce1a82fed 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2293,9 +2293,13 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 						"marvell,caldata");
 		}
 
-		if (adapter->cal_data)
+		if (adapter->cal_data) {
 			mwifiex_send_cmd(priv, HostCmd_CMD_CFG_DATA,
 					 HostCmd_ACT_GEN_SET, 0, NULL, true);
+			release_firmware(adapter->cal_data);
+			adapter->cal_data = NULL;
+		}
+
 
 		/* Read MAC address from HW */
 		ret = mwifiex_send_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
-- 
2.39.5



