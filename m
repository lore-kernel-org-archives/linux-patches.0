Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409A439C00E;
	Thu, 30 Jul 2026 15:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423880; cv=none; b=l1slOOhbC0cgm4fMZLLnnOOKQoGMQgAssjBk1j+5lcANPPhygdePLUI6eu2gBwEkYIwz6nQviGAEZj+4c3qJFjEctPZWSMOxGcWW0qtef8BGdFg/HjLP9eEPeuvC32C1MrKfDuuyTTyQ13R3QunqdK3VM84QTsJIMxRab+QMKpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423880; c=relaxed/simple;
	bh=USeck2fAimOHCTPzX4H2qGf8chHjAYUmUaauieUcgiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzWiXG7a9PZb68uNUYDt/1LSrky6LoU0Lv44XlBPPJKbFapauupHYQJAXTs5Cm8MOmeaO4LpZ8+uMnhJsNeKmrV1plEi0V/kpORt5c6cgO0/pVTPO57bqKkOaqGNciF5KZ3/aqLNarneB2d+fBH/NG3boc+lXvgtvc2mtfE9/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PezAiL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PezAiL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4A61F000E9;
	Thu, 30 Jul 2026 15:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423878;
	bh=7NoexxN/TTxo+gYLj0x9/IxmfYrdKLQW/p82zm08NHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PezAiL7ECfEFwzo9BrNlVzyk8XYHCupWLHTmXcDvah+Pn0kSVW2fd2N0N8Gnuo08
	 3arSA+jto9C6dWZzteLC713ixgvuRR0d33nVFPnee83zCragFNw80ZG2domsMPgbWs
	 4SiN8SoXe9yO6rAaqXSiz3BrtV0EwS5vFpJIF0YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 198/675] wifi: iwlwifi: mvm: fix read in wake packet notification handler
Date: Thu, 30 Jul 2026 16:08:48 +0200
Message-ID: <20260730141449.351171757@linuxfoundation.org>
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

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

[ Upstream commit 9d7657aae8c1579584c67b0b66114a6a98db8b2f ]

In iwl_mvm_wowlan_store_wake_pkt(), packet_len was initialized from
notif->wake_packet_length before the explicit check that len >=
sizeof(*notif).

Move the assignment of packet_len to after the size check so that
notif->wake_packet_length is only accessed once the payload length
has been validated.

Fixes: 219ed58feda9 ("wifi: iwlwifi: mvm: Add support for wowlan wake packet notification")
Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.99d5cf85a528.Ic4aa736011d4fe88e0cd19723d1d48bb24642198@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 11afe373961f3d..46e95e25dcd44e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2783,7 +2783,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 					 struct iwl_wowlan_status_data *status,
 					 u32 len)
 {
-	u32 data_size, packet_len = le32_to_cpu(notif->wake_packet_length);
+	u32 data_size, packet_len;
 
 	if (len < sizeof(*notif)) {
 		IWL_ERR(mvm, "Invalid WoWLAN wake packet notification!\n");
@@ -2802,6 +2802,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 		return -EIO;
 	}
 
+	packet_len = le32_to_cpu(notif->wake_packet_length);
 	data_size = len - offsetof(struct iwl_wowlan_wake_pkt_notif, wake_packet);
 
 	/* data_size got the padding from the notification, remove it. */
-- 
2.53.0



