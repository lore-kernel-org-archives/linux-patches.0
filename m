Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B0A25C717;
	Tue, 25 Mar 2025 12:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906318; cv=none; b=mmHZfvE/XmBMi+9WIfiiMkWootIpQybrDqsEe5Knf2OBH+yofb//+FwfLtRr5NT7N7yHxLWgX4V5mrnnXjgfgeI2UHmrjfNqi7Mp3lBUp+JzAsXbiS/5QjRQHNwI4hAnpDhNrOoLozYPMXcEN3tkub5Pykn2h5wnVque1Qnm94s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906318; c=relaxed/simple;
	bh=EA/mjAFEAQgPmvUOcw170FQf6H2tCAURAvmFs56Ru44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmXNUi2qPZHta5UDVJLo6nYEj0Pgsa/jz23PEETztLghw//6ksTzg24dfxngJeg32f5tr4iDwjzfftLyCV+tJ25RwO/kndqsC7zeFf3TAL+UgC27kx1FAObLZgJgQ7WSNepHUhnVH6Mr615qpp2NqaYhY5hcsKp+gzGUNNsL5uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTtXmzSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTtXmzSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0E1C4CEE4;
	Tue, 25 Mar 2025 12:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906317;
	bh=EA/mjAFEAQgPmvUOcw170FQf6H2tCAURAvmFs56Ru44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTtXmzSeOxSNX0oIZUx9XmnFSD30XisKOjGuSracE+PlOBywQQjDrAhkgLMB+d7CH
	 zLFmwZ8+Mo1QLqAVcoQhOphC9m53AajMqoi/VZMfotqEu8jYPe9Yfw8q4KZ76tcEXJ
	 Ch/1IlRS5l4fxwwalXVUZH3XoO4fC6/P/zC09+Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Shradha Gupta <shradhagupta@microsoft.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 053/116] net: mana: Support holes in device list reply msg
Date: Tue, 25 Mar 2025 08:22:20 -0400
Message-ID: <20250325122150.562121158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 2fc8a346625eb1abfe202062c7e6a13d76cde5ea upstream.

According to GDMA protocol, holes (zeros) are allowed at the beginning
or middle of the gdma_list_devices_resp message. The existing code
cannot properly handle this, and may miss some devices in the list.

To fix, scan the entire list until the num_of_devs are found, or until
the end of the list.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Reviewed-by: Shradha Gupta <shradhagupta@microsoft.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/1741723974-1534-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c |   14 ++++++++++----
 include/net/mana/gdma.h                         |   11 +++++++----
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -131,9 +131,10 @@ static int mana_gd_detect_devices(struct
 	struct gdma_list_devices_resp resp = {};
 	struct gdma_general_req req = {};
 	struct gdma_dev_id dev;
-	u32 i, max_num_devs;
+	int found_dev = 0;
 	u16 dev_type;
 	int err;
+	u32 i;
 
 	mana_gd_init_req_hdr(&req.hdr, GDMA_LIST_DEVICES, sizeof(req),
 			     sizeof(resp));
@@ -145,12 +146,17 @@ static int mana_gd_detect_devices(struct
 		return err ? err : -EPROTO;
 	}
 
-	max_num_devs = min_t(u32, MAX_NUM_GDMA_DEVICES, resp.num_of_devs);
-
-	for (i = 0; i < max_num_devs; i++) {
+	for (i = 0; i < GDMA_DEV_LIST_SIZE &&
+	     found_dev < resp.num_of_devs; i++) {
 		dev = resp.devs[i];
 		dev_type = dev.type;
 
+		/* Skip empty devices */
+		if (dev.as_uint32 == 0)
+			continue;
+
+		found_dev++;
+
 		/* HWC is already detected in mana_hwc_create_channel(). */
 		if (dev_type == GDMA_DEVICE_HWC)
 			continue;
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -406,8 +406,6 @@ struct gdma_context {
 	struct gdma_dev		mana_ib;
 };
 
-#define MAX_NUM_GDMA_DEVICES	4
-
 static inline bool mana_gd_is_mana(struct gdma_dev *gd)
 {
 	return gd->dev_id.type == GDMA_DEVICE_MANA;
@@ -554,11 +552,15 @@ enum {
 #define GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECONFIG BIT(3)
 #define GDMA_DRV_CAP_FLAG_1_VARIABLE_INDIRECTION_TABLE_SUPPORT BIT(5)
 
+/* Driver can handle holes (zeros) in the device list */
+#define GDMA_DRV_CAP_FLAG_1_DEV_LIST_HOLES_SUP BIT(11)
+
 #define GDMA_DRV_CAP_FLAGS1 \
 	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX | \
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECONFIG | \
-	 GDMA_DRV_CAP_FLAG_1_VARIABLE_INDIRECTION_TABLE_SUPPORT)
+	 GDMA_DRV_CAP_FLAG_1_VARIABLE_INDIRECTION_TABLE_SUPPORT | \
+	 GDMA_DRV_CAP_FLAG_1_DEV_LIST_HOLES_SUP)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
@@ -619,11 +621,12 @@ struct gdma_query_max_resources_resp {
 }; /* HW DATA */
 
 /* GDMA_LIST_DEVICES */
+#define GDMA_DEV_LIST_SIZE 64
 struct gdma_list_devices_resp {
 	struct gdma_resp_hdr hdr;
 	u32 num_of_devs;
 	u32 reserved;
-	struct gdma_dev_id devs[64];
+	struct gdma_dev_id devs[GDMA_DEV_LIST_SIZE];
 }; /* HW DATA */
 
 /* GDMA_REGISTER_DEVICE */


