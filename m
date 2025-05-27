Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E583327D784;
	Tue, 27 May 2025 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366813; cv=none; b=JOcrmHOReKp9w9vDtgvSQhVwjOS9nPpHjMowd+objH1U9qn4fSatmcgX1Cak7+wpGXCx2cW4vo2Ow7UZX3YFx9vYBxvWhzzmo752qaA+nEPDpP6aanHa9BFrkBYMi+Z7mgEA+aCFRZYrOpDCmjEl81vfHjhVNiBE253Sv9BW5IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366813; c=relaxed/simple;
	bh=NwWBT6Teq5rTg82/YIE5E8SC7goWhwlkcNMcMj4/jtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMuPVdde+pvzTHAOMpIgjNWysmU6myvH7y8If6L83C/ZnLsDbkEHWQ5Q2sUbuqYsdRdBBULitok6qQWWtOWHnuRsCri3nPD1LNiC2ttN9jHWRBpsZjsXgIO5WRL9OzCIaOEs6Xn9vO75+Nr6hIzIpP8f7xbGIePpw5j3Nm2DAb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BspJ+t/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BspJ+t/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B78C4CEE9;
	Tue, 27 May 2025 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366812;
	bh=NwWBT6Teq5rTg82/YIE5E8SC7goWhwlkcNMcMj4/jtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BspJ+t/hgy13o29Y2nd622UNdGfXb1yE2fclaq6yMlCrn75cHBoOw9hHgjXi8JteW
	 tuCt0eN8IeP3lhLFZ+eWvW5p+GGIbmdWqmupuovdH6j6ZnpT3VCco1ma3Z26yT55B/
	 O8xqhXoJi24IPldcttSZ0g1/oY8GifkC+vPd1X7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 153/783] wifi: mwifiex: Fix HT40 bandwidth issue.
Date: Tue, 27 May 2025 18:19:10 +0200
Message-ID: <20250527162519.391817566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Chen <jeff.chen_1@nxp.com>

[ Upstream commit 4fcfcbe457349267fe048524078e8970807c1a5b ]

This patch addresses an issue where, despite the AP supporting 40MHz
bandwidth, the connection was limited to 20MHz. Without this fix,
even if the access point supports 40MHz, the bandwidth after
connection remains at 20MHz. This issue is not a regression.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20250314094238.2097341-1-jeff.chen_1@nxp.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 66f0f5377ac18..738bafc3749b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -403,12 +403,14 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 
 		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
 		    bss_desc->bcn_ht_oper->ht_param &
-		    IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)
+		    IEEE80211_HT_PARAM_CHAN_WIDTH_ANY) {
+			chan_list->chan_scan_param[0].radio_type |=
+				CHAN_BW_40MHZ << 2;
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
 					  radio_type,
 					  (bss_desc->bcn_ht_oper->ht_param &
 					  IEEE80211_HT_PARAM_CHA_SEC_OFFSET));
-
+		}
 		*buffer += struct_size(chan_list, chan_scan_param, 1);
 		ret_len += struct_size(chan_list, chan_scan_param, 1);
 	}
-- 
2.39.5



