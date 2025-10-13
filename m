Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570430DD37;
	Mon, 13 Oct 2025 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370038; cv=none; b=X96/InJQ6zxV6DD4U8HCRIBmFqX7Qrzy2XR3DmxJ6WKqUlwbhRRz9THyLF+ndbS3Lkuo4uq6Y63KT6rhjJOL1vgWLrvaOIjB9CXfOcyUhh2IZvpYmUHsxz64Jdara9CnBpi5yMNY03MFS4srBRQhDcWwQ6YhWIlKGT7qySZ4bx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370038; c=relaxed/simple;
	bh=nGcLR6LwLtiDngUW9kmi2x2GWvm4ige/JsNBObdpP/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3YmkZMESJvHwYHLvlUM4CHFlVo5pxlXzkegylf+7/mleBIDTj0jUxNM7xtXKU3gb1fXXxBH/mUaCFCEySw+v5/1U5uBFjWliRY3GXMF21FSyjsK1V7Od4NN048I9pmLDhQFT6gToFn/DpB1yejAvU5uROR3gcXXG148FDQKuoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOmB4zV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOmB4zV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A81C4CEE7;
	Mon, 13 Oct 2025 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370038;
	bh=nGcLR6LwLtiDngUW9kmi2x2GWvm4ige/JsNBObdpP/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOmB4zV8kQ21nf5owHmex+//IZZrXep1ntb9v/+R559kPFV+tZ8Xf01Dylj1pqksm
	 xib+m8/137MG+FeIC1G+sk3B97Uiev1uYN2HTc6AmD9sOcy7UWZzqd4J+Da/v205+6
	 HkcbWnTRmZgBtGTN4BM0M4ghWfX5HxGV6MImFLCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 457/563] Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO
Date: Mon, 13 Oct 2025 16:45:18 +0200
Message-ID: <20251013144427.840255116@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 79e562a52adea4afa0601a15964498fae66c823c ]

The debug UUID was only getting set if MGMT_OP_READ_EXP_FEATURES_INFO
was not called with a specific index which breaks the likes of
bluetoothd since it only invokes MGMT_OP_READ_EXP_FEATURES_INFO when an
adapter is plugged, so instead of depending hdev not to be set just
enable the UUID on any index like it was done with iso_sock_uuid.

Fixes: e625e50ceee1 ("Bluetooth: Introduce debug feature when dynamic debug is disabled")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 225140fcb3d6c..a3d16eece0d23 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4542,13 +4542,11 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 		return -ENOMEM;
 
 #ifdef CONFIG_BT_FEATURE_DEBUG
-	if (!hdev) {
-		flags = bt_dbg_get() ? BIT(0) : 0;
+	flags = bt_dbg_get() ? BIT(0) : 0;
 
-		memcpy(rp->features[idx].uuid, debug_uuid, 16);
-		rp->features[idx].flags = cpu_to_le32(flags);
-		idx++;
-	}
+	memcpy(rp->features[idx].uuid, debug_uuid, 16);
+	rp->features[idx].flags = cpu_to_le32(flags);
+	idx++;
 #endif
 
 	if (hdev && hci_dev_le_state_simultaneous(hdev)) {
-- 
2.51.0



