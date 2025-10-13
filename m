Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806FF30DED1;
	Mon, 13 Oct 2025 14:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367414; cv=none; b=Wbulk+kULVRjwmGymqNuY6Anskg+ko0APxZzU0cq4FkVV9fInIvNPD3AQSp+7P2Fj4zosYGa8mHy28qA4AE79XXu/ZghhkLZyhjAwfLkKT3ttWXV8i/x7p/lEWyp0IvPCQqOYxlBtkotVOdmqshlqOCg1lk1Kl/D4ks0+GtF2tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367414; c=relaxed/simple;
	bh=LPSoChytQXcG257U3t3ySbJ0YppEvpfcMCw+5OCVldA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYdEEKFLy+MckyX2ibkek63+I8FKJAgMqtwZNSPP/4YeB45tWXthK1BXAxUJitSSYnc4l4Ozm5gHpwh+qRN9+ALgfn6ful96PaAYGQNeAEkyg/2wvMPGX6fV5yZgnO+eqDqw2KcVXQwyqb0LIB4NT21kk0NN53BdkfJ9rVR8UXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oabWaaj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oabWaaj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096A9C4CEE7;
	Mon, 13 Oct 2025 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367414;
	bh=LPSoChytQXcG257U3t3ySbJ0YppEvpfcMCw+5OCVldA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oabWaaj/GxZON3TMBiqdtxv90ERwW87HGbQQpAjuhpsHVybH1TjQFWnWjhbVotmg2
	 w53l5c/txA+RVPfSMUq6Ss/0iIt734AyfqevAVHxVvLUFH70n1D10aP2e8M9+IYNJI
	 f3XpTu54cfoLMFaFZVgsBqaR/l2RDsTLgu30h6Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/196] Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO
Date: Mon, 13 Oct 2025 16:45:30 +0200
Message-ID: <20251013144320.378844435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index 27876512c63a4..a11d25c389f8f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4483,13 +4483,11 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
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



