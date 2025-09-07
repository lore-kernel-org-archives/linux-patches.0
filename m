Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916414315A;
	Sun,  7 Sep 2025 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277638; cv=none; b=DxbAcUNYDbM6Vyd5di4sL0QgDzLfofjQTd8xtV+S+CXRKSQpcuVETvpK1iImMhzn2p8v/RRR1BM/14KGotjGI6ir9XAK0XVJ7p2gDOr4T2vwyNn2TqPae2nZ5iD1wxi3pGC5oj8QeHrvG7xWmw3JtfvHyvsGLGrw7SE5HDrV0tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277638; c=relaxed/simple;
	bh=59nwwKuokVUsOAH5sHeVZXnvbQjaXk+h8vT69nSsWkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8TxBK/YK2u37bvm4BmJP/P7k8wK3u8rbj9cr/+Nygh/TAshqWvqLe1VEL+mQ9lBmNmi97f3xlI5Msc3A+WfxPC2hbKw/CsnrYhMptS7ICP13R78FNhKJthDMvhcT8b+kioEHfwt4Apg6mC9p6guSSJIevfYT5k1qA4+kvKsQHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUcCyf46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUcCyf46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC3DC4CEF0;
	Sun,  7 Sep 2025 20:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277638;
	bh=59nwwKuokVUsOAH5sHeVZXnvbQjaXk+h8vT69nSsWkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUcCyf46emsE8LNNKprZK04QCuao/8I42D10aurfg2PR7ZWh7pfR246xZw4L6v51b
	 5xhIcfdAuguraJPCN4OOBoIec1h5K/YfjExuSTvhEDoDkEr7ZiaYeTdocfEeTKWdCr
	 aDQM+Kn9gjzpkFbgrymwRql/57VSiEpq77A0X/xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 078/183] wifi: libertas: cap SSID len in lbs_associate()
Date: Sun,  7 Sep 2025 21:58:25 +0200
Message-ID: <20250907195617.648194865@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c786794bd27b0d7a5fd9063695df83206009be59 ]

If the ssid_eid[1] length is more that 32 it leads to memory corruption.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/2a40f5ec7617144aef412034c12919a4927d90ad.1756456951.git.dan.carpenter@linaro.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 2e2c193716d96..309556541a83e 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1151,10 +1151,13 @@ static int lbs_associate(struct lbs_private *priv,
 	/* add SSID TLV */
 	rcu_read_lock();
 	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
-	if (ssid_eid)
-		pos += lbs_add_ssid_tlv(pos, ssid_eid + 2, ssid_eid[1]);
-	else
+	if (ssid_eid) {
+		u32 ssid_len = min(ssid_eid[1], IEEE80211_MAX_SSID_LEN);
+
+		pos += lbs_add_ssid_tlv(pos, ssid_eid + 2, ssid_len);
+	} else {
 		lbs_deb_assoc("no SSID\n");
+	}
 	rcu_read_unlock();
 
 	/* add DS param TLV */
-- 
2.50.1



