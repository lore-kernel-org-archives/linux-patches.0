Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A0625D546;
	Mon, 13 Oct 2025 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368558; cv=none; b=s2N7Y8bgvLYNi0KuXvdkDWxQTTtgEQSJGYKg0wvffJX1O4CSjbKJ1pzCfTxKdyj5vBKke73Eat29uQFtPkvzC1WXwwAGcFllD0Gbn5kGQxihUbIXmtWJSQwCZ0Aq9Dz2rtJQa632IGRdwaQqEz2sW2v+2226HOwBtueQFw4Pc1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368558; c=relaxed/simple;
	bh=iEd57OnTfu/dS7LAXP7b2UMBHhV1M5FwipEl3n/JfwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8MV8pFJCOxIGy+EzAT0H2nNOPHXREzXIj9VodF/M+TOBzGWk2hQL5q7m+vigs+EeLf9Zyz1G3gCGcStCW2RTKalexFIQ4YLBwqBvwMo/P4QfXEx/xOgQ+M+KQn+VHNI2WpQ2a2Bk6ecRz0SpjCoyzDwJPwX9Z2APyYJgC5uJOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXEtZUcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXEtZUcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C22CC4CEFE;
	Mon, 13 Oct 2025 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368558;
	bh=iEd57OnTfu/dS7LAXP7b2UMBHhV1M5FwipEl3n/JfwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXEtZUcfgLfBjHMUt3AJtk4WJdJRQdHM1qssuFaCigz2msFqF8AOQ/Os7Vn7a9GDp
	 CWF4omz5COFpA37eDYXLg0QPgjRppcDP9bEGB+4r9opSDKw2UATWNYcYKZk9GVqvSf
	 5yO5rTJT1bGIApEA3UpkN9OYFFgtW9Wjc3BxapS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/262] Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO
Date: Mon, 13 Oct 2025 16:45:44 +0200
Message-ID: <20251013144333.520627281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8b75647076bae..563cae4f76b0d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4412,13 +4412,11 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
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



