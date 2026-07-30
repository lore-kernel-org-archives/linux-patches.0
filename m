Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA9C43DA26;
	Thu, 30 Jul 2026 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427316; cv=none; b=duORBv+0qCRK7tt7Wj4nEd425KGYwJVTYSHwDOelN97R0waa3kIGhEhqmj9RR2uBef/Gc8AB23BTA27vp2glxpKDneu/o3RRCZlGxXe2/GouUMavG9b7+om38lC4/4cghB2OiIyv/oIfhwZ6yXmbkoT13qUPLbjfemAZUj0GLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427316; c=relaxed/simple;
	bh=kyaUuOnHCAZKOn6CA0zcl1guhOceCFsFPJhwF5OM8qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QePrCqE44Eu79b5ZSTCiI6PqjX2xb+0fg1IzsPQgFpbdJP29MP49fuVLduv+ZDWQUj4RCMZsnLoc1UAGScZz6eLBc1mEZmdeSaVq9SykGqoam/jKEO1d54akgOYXaqK4fLzXcyjKn/Z3hrRykWpKf8bZArJjSIY817Muj2RPvAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdMRgSeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdMRgSeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FA61F00A3A;
	Thu, 30 Jul 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427314;
	bh=e7+9cn2pyQE726ND4AGmLbWEdBdfSzpFOr1AuJh6Sy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdMRgSeLbBWh50GCcrD65dynM7+xco2n339PNKYu+JBuZGjVFU7HEv8sKUFyzfltu
	 IceCW6hoUsSAF6Kywv2cN+aoJbroZDH1UyOrYg7kNO2Jo99ogZWxNwcw1Wu2lZSyIy
	 3VwgquegTdG9+33CyENYXuKIInJMnRrGCPWh+4XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/484] wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler
Date: Thu, 30 Jul 2026 16:10:22 +0200
Message-ID: <20260730141426.175349565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 3787b9fb007559..a572952dd4b903 100644
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



