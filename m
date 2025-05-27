Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604821B6D08;
	Tue, 27 May 2025 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364673; cv=none; b=NSAeFkrs9NDrBif2AXSXh8dXDF9espHfEKU1w5klCzCVfSQ7aRlyxiPqqSh+7kUKuPxj2YSf/GwXOkx8Z+DyNQR/g8HrSGR5phr1KDBlFkhAp3ITxaYI0nPY7V0/G1YAdDQbJ9t6Mn0OqAIx5cHYsPfB9qu4MlpsQ+h6mxPJzE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364673; c=relaxed/simple;
	bh=+PH5NxP6kRtwmvzWd1fXTZ0f5FeQJPI3A1ResxLxpOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xs7XvVmeGKTOmqMlHW+37E3YLj6CqU9V8eYnjS5gSEYvppgZGl/Jg4oKdDftezkhHtPd2ncnwre7Da89XHfqzCzIBAQVvz/lEdg8vjEinon5Z9Rm0taOb7ytNlDXa8FLBqkZYTn5CTILQRCg5zsLIboDmLdLgVBybAmQJgvmSLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APPkOiOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APPkOiOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C65C4CEE9;
	Tue, 27 May 2025 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364673;
	bh=+PH5NxP6kRtwmvzWd1fXTZ0f5FeQJPI3A1ResxLxpOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APPkOiORoMh5nWRfP1tFozGdauUKpTc4gjEvVWLkG1dRt1Wjrsk0ORNOykrXy3HSQ
	 TMKz07uoh0NAOgdg0eM/ZQtAj4ExRe28dXk39B+hRQ9XI/2tn48nkcReEC9sW9vJuk
	 ilMdMsl01n8IVhEZjQLKAGRLv8i6W9P57EF6iNeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/626] wifi: mwifiex: Fix HT40 bandwidth issue.
Date: Tue, 27 May 2025 18:20:23 +0200
Message-ID: <20250527162450.311998747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



