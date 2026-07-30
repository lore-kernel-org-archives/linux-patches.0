Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF62831E831;
	Thu, 30 Jul 2026 14:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421871; cv=none; b=X+boKXt+wW4uN1zFTQf50JDLSTuJb7ErWTH+t8JXHSKv/cK6IT4NN0Lk6nYf2Cz3O1F9os1YRCvqGRct3YAYkNHKSGZBNAM1lYl2I8dpqfeuONar3EadVpuIgkxs2rHuIitTCMaP6GP00fet85pTGT1qOjsjJA5JiY3aD7Akulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421871; c=relaxed/simple;
	bh=PCTTDaBaUvbQoPJQOGkqXhGjXLHmmFbgG/i2d6A9Wtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShHk9xPeWqBjOQx6kEHTap8IXXnu4m09xs6hDxTf7KRtnzDXJMVic1RPVrTva1syePW7H5QTFShJLnpn3DlmqxESo/0waBX12IdwABJZaS5HMcl33+ngU/2DKJ5f0MwbjXhH6z5CmPlv50ZpPDlUUr4x6wk8GaADuK7FB570vZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlikdtD7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlikdtD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1273F1F000E9;
	Thu, 30 Jul 2026 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421870;
	bh=9xSAtdQ/T7etjgIzLcZKhGtUXcfmmxm32xlPjz30IYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlikdtD7X0MdCdyIaNrTBW6Ea2hZ9f7noRHMP0xSepJYdiP1+LtH50UB0wLds6BPP
	 rcfb2KzhgSsNVUjqTWlKPnMEdyWypJ9kIlJi68euapPuaQrDZ/q23NRF9cWermfMeP
	 tciKTGIA/VyiZgZYk5wu7rwwBjo1mXowj6/0xmog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 248/744] wifi: mac80211: copy aggregation information
Date: Thu, 30 Jul 2026 16:08:41 +0200
Message-ID: <20260730141449.564019954@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 0fe2d5be7ab59717adb3f9cfab3832c6c4dd770c ]

This information can be considered part of the capabilities and should
also be copied to the NAN data station.

Fixes: 27e9b326b674 ("wifi: mac80211: support NAN stations")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260714141038.15620aa5324b.I049254b854ac91c32e0768eb7c819f32eda34218@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0bc10136b816ef..80210ef4cbc843 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2414,6 +2414,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		memcpy(&sta->deflink.pub->supp_rates,
 		       &nmi_sta->deflink.pub->supp_rates,
 		       sizeof(sta->deflink.pub->supp_rates));
+
+		sta->deflink.pub->agg = nmi_sta->deflink.pub->agg;
+		__ieee80211_sta_recalc_aggregates(sta, 0);
 	}
 
 	/* set the STA state after all sta info from usermode has been set */
-- 
2.53.0



