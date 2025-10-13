Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56E030BF4E;
	Mon, 13 Oct 2025 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367832; cv=none; b=quPCDVB8PIJ6t5kfI3LGLYNWeaI7LLmKpO4R9Pdi+wR4q0NSf7uN9XRS/Jf7vzDbDxAlKmPiESrwYq2UCfS06f6yufDpCW2bqWNueoNq0F90zs3CKb2UilTNBwnX3JA/0tFoIYgcFFpLEfuoolGz/lXW9m1HW2rXieZtOLV00zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367832; c=relaxed/simple;
	bh=gjNIs6WYlG+3HccoDIDj3/uDhx0weW+uBG390mqRGYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sd69fz4mbXsAj2kFmkXH2qwEht1f51AJ5jWUETIkTAJsjGfYfYLAVQR1ywibBhUcTBnWgRvjjInK2BqcU8Xxy8KYi89H5NiCGxdDf1+2ozUBMxUAm+i0gRTyIw2EJ50xyWu02j+q9dwfkAm/9aASbJzmPyMQgesNFxgc0w4y+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxynRJbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxynRJbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99B8C4CEE7;
	Mon, 13 Oct 2025 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367832;
	bh=gjNIs6WYlG+3HccoDIDj3/uDhx0weW+uBG390mqRGYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxynRJbCTk5tXq5u0eGyOVJ9ZQl4pZOO3JdQPubuiXGj+yIJvaV6BamojFBizuXoK
	 LgeSonSdq00pRjAQ9rtoogopx1ZznlRyqw6qbXkqdbuaxMEc/TkskOOE2OZRMU0dEw
	 Q/WC2P0+pCd9Kxza1KTCcK2/1aAeF2x2zFiu7Nn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/196] Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO
Date: Mon, 13 Oct 2025 16:45:41 +0200
Message-ID: <20251013144320.737160341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9b01eaaa0eb2d..54ddbb2635e2f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4405,13 +4405,11 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
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



