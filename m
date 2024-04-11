Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68E22EAE5;
	Thu, 11 Apr 2024 10:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829905; cv=none; b=VPiXFO2IAbBGcC3IwNir28J/iRDwLiCEn2ku9ib7s6mkC3jzl2Rt7wGMPIJzBiOKDJ/8ppVDtkLVYshODRw0nJsvZkGHoUEVYe06dCFEcfimoehQjCGv7E9ICVx4H5Ufs3epTzaMLPMM3H1QNohV0b3NwhQeKhkA99NNUdSvtSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829905; c=relaxed/simple;
	bh=Vyo/r5M3tDplGLGxniNFpLuWpMP0iSEkhNaPT61flMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCExr+s5ofEoe+hc03sZtaaV3oAymaN+YQ2cbGmfiv47PlqnG8A1i21i6wm3S357QnR3l2dPzU2i2/IGRz25PjWZ3p658YSUj3HGmJ1NblPM5JOt8WZ2GPQHHmsv5CGtnilgJGyQxdbzFce08wDQ7sXTgpSr410Rb505ddBezck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdWDbe66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdWDbe66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E94FC433C7;
	Thu, 11 Apr 2024 10:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829905;
	bh=Vyo/r5M3tDplGLGxniNFpLuWpMP0iSEkhNaPT61flMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdWDbe66O0VVoFLb/BR2953aPiaGpCS0gt93IrS4c8QsqLdKaXarhPDPiNgwRnI4m
	 32D1Kgx/klwX8G1/51ACOfa0dWc/MkRh9EdPBYeP82AGCkqBs48IWb4zOIu6OP+srP
	 2csqLGyRwScccBke1AWRYhBxMQZu091+fgE5p1BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/175] batman-adv: Return directly after a failed batadv_dat_select_candidates() in batadv_dat_forward_data()
Date: Thu, 11 Apr 2024 11:56:08 +0200
Message-ID: <20240411095423.928259603@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit ffc15626c861f811f9778914be004fcf43810a91 ]

The kfree() function was called in one case by
the batadv_dat_forward_data() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

* Thus return directly after a batadv_dat_select_candidates() call failed
  at the beginning.

* Delete the label “out” which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index af380dc877e31..6930d414138e1 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -648,7 +648,7 @@ static bool batadv_dat_send_data(struct batadv_priv *bat_priv,
 
 	cand = batadv_dat_select_candidates(bat_priv, ip, vid);
 	if (!cand)
-		goto out;
+		return ret;
 
 	batadv_dbg(BATADV_DBG_DAT, bat_priv, "DHT_SEND for %pI4\n", &ip);
 
@@ -692,7 +692,6 @@ static bool batadv_dat_send_data(struct batadv_priv *bat_priv,
 		batadv_orig_node_put(cand[i].orig_node);
 	}
 
-out:
 	kfree(cand);
 	return ret;
 }
-- 
2.43.0



