Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CA0522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A18C433C8;
	Sun,  9 Jul 2023 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901619;
	bh=/cbw91GvUaxkY+uphb9z/G+ChWUnLk4wExz/DElnENc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiEiDaHmqK3sKTLEcTCF0UQC/F+ytPmZL7x4RrcwcN7IoRcw64qNdEg8U+VV3xYym
	 Hw4awtHFlbs62vy9kyGbPBawpuba7Anmp79iv4AF+Fe7yaGV4p3kxu25/KJ6V0kiLs
	 H4JjsJjKpU2o5VWlzzcCkzciYCT9sZ7z+fBrmE3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 084/431] wifi: mwifiex: Fix the size of a memory allocation in mwifiex_ret_802_11_scan()
Date: Sun,  9 Jul 2023 13:10:32 +0200
Message-ID: <20230709111453.120270980@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d9aef04fcfa81ee4fb2804a21a3712b7bbd936af ]

The type of "mwifiex_adapter->nd_info" is "struct cfg80211_wowlan_nd_info",
not "struct cfg80211_wowlan_nd_match".

Use struct_size() to ease the computation of the needed size.

The current code over-allocates some memory, so is safe.
But it wastes 32 bytes.

Fixes: 7d7f07d8c5d3 ("mwifiex: add wowlan net-detect support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/7a6074fb056d2181e058a3cc6048d8155c20aec7.1683371982.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index ac8001c842935..644b1e134b01c 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2187,9 +2187,9 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 	if (nd_config) {
 		adapter->nd_info =
-			kzalloc(sizeof(struct cfg80211_wowlan_nd_match) +
-				sizeof(struct cfg80211_wowlan_nd_match *) *
-				scan_rsp->number_of_sets, GFP_ATOMIC);
+			kzalloc(struct_size(adapter->nd_info, matches,
+					    scan_rsp->number_of_sets),
+				GFP_ATOMIC);
 
 		if (adapter->nd_info)
 			adapter->nd_info->n_matches = scan_rsp->number_of_sets;
-- 
2.39.2



