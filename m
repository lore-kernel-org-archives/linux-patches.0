Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D148732549E;
	Mon, 27 Oct 2025 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591236; cv=none; b=LrX/PP1MpgQlh458WHsx+oKPNFEnEWMVibcdhIGscLiAQUg4nPx1xvTTTQZJtKTXSUYsoX2clLKI9PXiwasO4PZuVDoZ+sCcLMQczWmTqWB1++socbZwpZMwheGhYFjHd7EeTskWxd8g5pXmuX7TmKxEZJUhLBhT9h/TE2hWu88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591236; c=relaxed/simple;
	bh=eAOGOu7+3WX8bo3hox2o2uBTfpdhNINy1yUEzAsCVoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cp9M58vTbIG2dUUNo5gBOf7+1cKuqZex48pV6iZk4EClU27Eq6fkftGk26d7uCiOxRwt/CwOBaPXpHb6G4wFvMzccavA3d+9CIockq4+zy1CqoY7d2SEmtyBImhYucbGkIV7lDNWfI6Anqn44qnc5j/4sTwFziR7IHP+LbzHmQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRQA8x6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRQA8x6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7EFC4CEF1;
	Mon, 27 Oct 2025 18:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591236;
	bh=eAOGOu7+3WX8bo3hox2o2uBTfpdhNINy1yUEzAsCVoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRQA8x6ANx4OcSSW6V9HVeDW1ib/w6KNSlH1/h5XfPPJkDVFCcHkyvnwSeiv6E3g7
	 zHHOTCu5lNynuu82jeOHXDOTc19BuEwsGL+UMmsIFIQuEbQfc6OLVwJXAO94qWisQU
	 hJPiwsrvGsPlYoCubVtjaD+tJFZqSouECgSrH2oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/332] Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO
Date: Mon, 27 Oct 2025 19:32:13 +0100
Message-ID: <20251027183526.733180960@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 51b16c2a279f4..fda0bd990dcb7 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3801,13 +3801,11 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 	memset(&buf, 0, sizeof(buf));
 
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
 
 	if (hdev) {
-- 
2.51.0



