Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68796330B04;
	Fri, 17 Oct 2025 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716175; cv=none; b=Hk3nvwcqdSVSZiNenSivWYqg/zcMqyX03yZ/vjeino8ItvKLCdcwOgOmuXrkBMKgIE/Hglv5nkf7tAMGlFxmg12x+l1ZQgMQDRM3YOeTtCiJPsf9cR8b1j7K2ewDoDIuyfbEndchXf7mqySzSaG62vj0kAxI9k+69VZTn3IaRzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716175; c=relaxed/simple;
	bh=q29TcENOki7WR7IKTnNwK0cbHPKq7wxe/nlXvStrmEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfXYSNYWml606fZ47LfksPS2nneqKtv9zMo0961RSt/ys+4cMCEh2NGJ7ERrxwkbRF6hxQEPDUNtWY7gFePR9ZvqZnw6RkFb5OflEFFlIjiennyctFjCoTeUscMMBJ1EqDndkAGzRojARwxWrAm6koZ0+qVrbKLg0FEWePEPJ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5VD4Zfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5VD4Zfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA745C4CEE7;
	Fri, 17 Oct 2025 15:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716175;
	bh=q29TcENOki7WR7IKTnNwK0cbHPKq7wxe/nlXvStrmEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5VD4Zfwickq8ZlChBtAY0r3qZMGIeueq/GCiqVcVOO5lL/f2Gb7ERRYCrGAm9Q/U
	 cik++2ryM4glFjRoxXb6UzUndyqrGmsSEDpCOfLUJGlMxRQgUVlHTAHxtzVY4VEXEU
	 ijilRaljUaTJaVUPPKnOYbClhwsUeZm2PedAuggw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/276] Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO
Date: Fri, 17 Oct 2025 16:53:12 +0200
Message-ID: <20251017145146.098170803@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a54eb754e9a70..1d04fb42f13f2 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3824,13 +3824,11 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
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



