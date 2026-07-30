Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0433A5433;
	Thu, 30 Jul 2026 14:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421758; cv=none; b=J7gHH6+z2gycaHf7u9VT3fb+YSrN3EATb8eiEhB+cQYjdD0V5B5wDymeIz1FU1RRB6DcQwCSWzYXYm/WU5lhMpWLcZrCcK78rb897A/iVJT690+9ns42ey5Voaff+Q9rdGdwgvWwjEeU9Ox6BgBu/o86MbhjHpTyvenAnTTiGNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421758; c=relaxed/simple;
	bh=c+Hn9GyFlDwupJs0LmKrtwg9AjjTQ3BhGVwAUwXWVYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILGdFWLpDm2/OPVwfHkas8DICn2Iz2UnPalFxbRvaJpdC/JE3Jzj8epPsFxGIZWeg+gTK5Kn0mk3xkGd6KdLq3Bl0hwSowP2D+AXVC1PfmkV3+zzXBx1Ti9cy9EKTRABhUi4xbd7OK8dG+La22RAb8SH+fAi6gwqZDayzyUoBjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJtFXXT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJtFXXT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F341F000E9;
	Thu, 30 Jul 2026 14:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421757;
	bh=UAvuHd6jTcAmCJbU8xIAlnHtrk53DmADLkYkK30AUXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJtFXXT5JKLF5znqrCrB+ne7Vq1xkoCFW+ThXug7BATfbUL29qMM0qngPVgVuz0Ed
	 FVzVJ7/aA3z6zXIaJr5ehFdTBxRbFaMAS/gBqOe2Rhu/ufSFoI0f7FSfAboKEi5UXM
	 G+hYpVn4k/ShLE6P2jICcRfKQwQL7En6or57DUe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 210/744] wifi: iwlwifi: mvm: fix read in wake packet notification handler
Date: Thu, 30 Jul 2026 16:08:03 +0200
Message-ID: <20260730141448.744626484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a74f60c91850f..72d7403de04d82 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2756,7 +2756,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 					 struct iwl_wowlan_status_data *status,
 					 u32 len)
 {
-	u32 data_size, packet_len = le32_to_cpu(notif->wake_packet_length);
+	u32 data_size, packet_len;
 
 	if (len < sizeof(*notif)) {
 		IWL_ERR(mvm, "Invalid WoWLAN wake packet notification!\n");
@@ -2775,6 +2775,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 		return -EIO;
 	}
 
+	packet_len = le32_to_cpu(notif->wake_packet_length);
 	data_size = len - offsetof(struct iwl_wowlan_wake_pkt_notif, wake_packet);
 
 	/* data_size got the padding from the notification, remove it. */
-- 
2.53.0



