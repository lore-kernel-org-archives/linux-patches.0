Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1EB37FF60;
	Sat, 12 Sep 2026 16:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229633; cv=none; b=gXCeGq/ftAad8iUk/1/icx0lUBtg1M74k2UmKrbp0OxoEet/L9ZR94OukhapqLQ6VqRkuD44gGFD2ztM4k23siu5g8Ezf6wBGqBvh9KOSlJr2aD60FfZQFP4JDSeyatzQM2TVaClZTk0LvkSsg5AyEMAglaoUvbU3JA9HHykIiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229633; c=relaxed/simple;
	bh=jWTfefTaBaO6QM/25tYGCpk4E0igFnu+7ygwIdPvIks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj3lrK4/LVrAmg2lpDVLiA3z8vAHwFwV1Me9PuC8sZcxK7iedMGq+7W64HRnkDoD/x6ZtpqcEkvqlSleTDr6FM5+Rh2LvZ1qc30ffilI2W6vQ2CDjGwcKvpVPUy7sZOTv138g4oJu/kZH42w8INELSh0yVSTdsj/kpxY1+bEvIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzbepATm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzbepATm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61791F000FF;
	Sat, 12 Sep 2026 16:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229629;
	bh=iSkWVVHyzD1b2AtaiOjRyl2h33qnto/uJyE6GjnAXmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzbepATm8nYiKrWeHIlgl53jJfcmY87DZMXzJynQL0zptXZNJJPzK8yF61n/ZMbsK
	 di0N4cGfFOOkJCBMhuhNDOE1yBBnSEeJ0r3kxI7Y7PydZeQS4o3FgNxU8yA4hRP6yf
	 9o51ImHTyMHIHwS46pRvJ2bTVphv9hByaBb3rA5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0628/1191] wifi: iwlwifi: mei: check SAP message length before reading it
Date: Sat, 12 Sep 2026 08:55:56 +0200
Message-ID: <20260912065602.359040634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 7d8cc301bcba233f31b589a45f4c1c97f2bb90d6 ]

Verify the SAP message size is not larger than the local buffer before
reading the message to avoid buffer overflow.

Fixes: bcd68b3dbe78 ("wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.f0026ce26218.I00a856d3aacae1caac605c708f7362689b734234@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 91e30bf7a56e6..56d4b16ad4888 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2021-2024 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 
 #include <linux/etherdevice.h>
@@ -1118,6 +1119,11 @@ static void iwl_mei_handle_sap_rx_cmd(struct mei_cl_device *cldev,
 		iwl_mei_read_from_q(q_head, q_sz, &rd, wr, hdr, sizeof(*hdr));
 		valid_rx_sz -= sizeof(*hdr);
 		len = le16_to_cpu(hdr->len);
+		if (len + sizeof(*hdr) > PAGE_SIZE) {
+			dev_err(&cldev->dev,
+				"SAP message is too big: %u\n", len);
+			break;
+		}
 
 		if (valid_rx_sz < len)
 			break;
-- 
2.53.0



