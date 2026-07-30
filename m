Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD502D0602;
	Thu, 30 Jul 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423823; cv=none; b=BjOgKPlq9Skrnn1c0vKu2+Gw77UO/70ei/jiHY8QPKo2G0vvj2dESIlA+BQrGm+0fGXKXZHgLJWP3feMIMAkHQZ/r3812kbB0hydTMFL9mvBLJtOsG2TUMnZiOgxuWrh/N6lknEeLzvGUU7fix7dSAhXL9iiBYv7Xaj+OHCYAGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423823; c=relaxed/simple;
	bh=iad+CZXd0BZf65hn+GwaqUTn4VP3lX16Xyn4KzvbaqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdIuGXJZjoMVZCfgIgNufcev0HsjwaKtp4f+1qFrEhoBmcft73ibQQYv62WKlFx5H5B2PJ+4afdUNtnJkKJhrp+35gmxqKBl9ZK2awyJpa6QF9gMLLaP9F8H0qxO4sBog3MhQunegUnP4XM7LrfH44A0L4CDkUIrpbsnSr/WXho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7kp8HyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7kp8HyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583091F000E9;
	Thu, 30 Jul 2026 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423821;
	bh=nfo86nuBHuwZCz5wi+RxzFf1naUGVcfuf/O6IGnMIE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7kp8HySSIPHP9L6Hrkd51zpPChU+wHzYqcKRnFf/1HU/yOa0FJ/eZjxn1luI9LKn
	 rXCX++mRolyRQoYKqpsNFZm1Zwxka9mWB3sAJN7AP3eEytcqjo9g2eKP9lxi6Jfkka
	 6YumA5yYNmfQNyypmlYZ12w4Sy9fdPcaOWc3pUns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/675] wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler
Date: Thu, 30 Jul 2026 16:08:29 +0200
Message-ID: <20260730141448.943716214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 3a21c89215cc18f1a97c5e5bfd1da6d4f3d44495 ]

The firmware-controlled num_msg field (u8, 0-255) drives the loop in
ath6kl_wmi_tx_complete_event_rx() without validation against the buffer
length. This allows out-of-bounds reads of up to 1020 bytes past the
WMI event buffer when the firmware sends an inflated num_msg.

Add a check that the buffer is large enough to hold the fixed struct
and the num_msg variable-length entries.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260625232907.3620746-1-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 08a154bce1396e..aab1ad80a8b6c2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -484,6 +484,18 @@ static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 
 	evt = (struct wmi_tx_complete_event *) datap;
 
+	if (len < sizeof(*evt)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d\n",
+			   len);
+		return -EINVAL;
+	}
+
+	if (len < sizeof(*evt) + evt->num_msg * sizeof(struct tx_complete_msg_v1)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d for %u msgs\n",
+			   len, evt->num_msg);
+		return -EINVAL;
+	}
+
 	ath6kl_dbg(ATH6KL_DBG_WMI, "comp: %d %d %d\n",
 		   evt->num_msg, evt->msg_len, evt->msg_type);
 
-- 
2.53.0



