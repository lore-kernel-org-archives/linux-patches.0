Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9780D23AB9D;
	Mon, 17 Aug 2026 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979233; cv=none; b=ahH4SDlHmu+XHeORlbCgRMLEoaUSqdUJMneD3lJe1e3CogDS+wikSWxDweiJA4XBbZXmZY7mOqZGGtT0EuIZ61tMHAcDghDNDFMzKN1NEhPwtY8MYP3PqRzpezg9udXBOl7aRqnY+nEKpSvg1UQkoQNNnjOJh1rt/k+CFaI3FOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979233; c=relaxed/simple;
	bh=NRICjN1zI39mVH1+BgNvts4QDaKAqeg4m/hSIgzAAX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJU3X/2y3uwtZI68GuwyAflAUJupv7XM9a4ZjRO6V9p73OLfVY1s7lLkxKxr4tlxvVgJS0TMSKXWh1H24flGz+f71C75acxPODLlSID0nqAqugOSG8ZxbN58P87dI8689DGUTbplWAxMmewlJb7GDinTeS8G/ATrLy/BJ4fuAtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSXuwOnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSXuwOnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3E71F000E9;
	Mon, 17 Aug 2026 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979232;
	bh=HI62uB0+HS1w7MoG7zC373a1FOEp2NCF4Zbo+DJD8D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSXuwOnxLdeW4GeuX3rVhuYk+L7XPVfONk8dxBuuWBO1+WFUDGCsHdzFQS7Lvo09w
	 sZVy2OlFTYHCp6ZyBa5hB5lr7C5HPe5fEvIDN7hVRDsaX5QkQ2spBfd+H3JhM/EaWj
	 lZafanMRczjl87MhLs8cWDeWpq8dxkoTkO00kjbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/609] wifi: iwlwifi: mvm: fix read in wake packet notification handler
Date: Mon, 17 Aug 2026 15:26:51 +0200
Message-ID: <20260817132547.610384965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 1425763fec4ea1..d7b2781a1eeaf1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2627,7 +2627,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 					 struct iwl_wowlan_status_data *status,
 					 u32 len)
 {
-	u32 data_size, packet_len = le32_to_cpu(notif->wake_packet_length);
+	u32 data_size, packet_len;
 
 	if (len < sizeof(*notif)) {
 		IWL_ERR(mvm, "Invalid WoWLAN wake packet notification!\n");
@@ -2646,6 +2646,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 		return -EIO;
 	}
 
+	packet_len = le32_to_cpu(notif->wake_packet_length);
 	data_size = len - offsetof(struct iwl_wowlan_wake_pkt_notif, wake_packet);
 
 	/* data_size got the padding from the notification, remove it. */
-- 
2.53.0



