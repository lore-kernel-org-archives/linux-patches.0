Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92EF3806BD;
	Thu, 30 Jul 2026 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425704; cv=none; b=mlJ3yTrpnytcPJvjwacZEOLfO16l0uGWZRyzKvWuawdl+YnnjKq9d4rZLB9NubP0Ro5Y6Hl9fPHjKO8gfjsawiAudsxr5ASigyp5K/fU75n4LT+mQmsq9A57SaCth4/how8/4s17rQSgDW3APBT7UKIsljatsmLA43x0QhCoNhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425704; c=relaxed/simple;
	bh=8DU7LnRfR5ITeQghyj7dOnXVOQcNFGcVdKAsRsiDQt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khthNIzP82nTvzmha9aTGNdzWYLZwGuPshXsaui+hgU22tdCDZXs2y6q3lzLmRhsn+19K3/HYKjh2J53ptGWhZua1gGPITMU1yCp+wrK1/rvRGyUltgQyUuX4hhwmX/AXUt/zZQetcntR8Z4ShDcSqnwK5BWy72yx0M1FNxQzH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3xfU19K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3xfU19K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4979F1F000E9;
	Thu, 30 Jul 2026 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425703;
	bh=Hx2Ye/ng1SKFWM/jP+O/waYWjk30dUqSU74k4G8zDsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3xfU19KV3CljCcXGLmKJ4tvq0EC3dVuiaeKl39vosq/hHv0zyKsOzI6vb2XMYuoP
	 MoYujAZe4jz+bslS2S+siiL/yvi6zMVkAH5cpdjdce8uMJ5C75Yqiz/17lyG8oHtPL
	 oCxxpDEdXLn+59vOxSVbumwZJKRkVDN82H8wdtBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/602] wifi: iwlwifi: mvm: fix read in wake packet notification handler
Date: Thu, 30 Jul 2026 16:09:14 +0200
Message-ID: <20260730141439.376770570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 817ddc7103af27..dd31b9b2cd39bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -3144,7 +3144,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 					 struct iwl_wowlan_status_data *status,
 					 u32 len)
 {
-	u32 data_size, packet_len = le32_to_cpu(notif->wake_packet_length);
+	u32 data_size, packet_len;
 
 	if (len < sizeof(*notif)) {
 		IWL_ERR(mvm, "Invalid WoWLAN wake packet notification!\n");
@@ -3163,6 +3163,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 		return -EIO;
 	}
 
+	packet_len = le32_to_cpu(notif->wake_packet_length);
 	data_size = len - offsetof(struct iwl_wowlan_wake_pkt_notif, wake_packet);
 
 	/* data_size got the padding from the notification, remove it. */
-- 
2.53.0



