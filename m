Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B21422B8;
	Wed, 19 Jun 2024 13:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802774; cv=none; b=CVm5O0yYmaY+pXyft0MRDb0vUq6K5Sl5/OP9yv8cBBat/lVzb/3k2n7rmmndMrEQ9ORDfQLeoV3ra0Inm05dqLxfasw/e0pgTB91anKwdCJEyrgUM09Ojsiome3OMRsuIlg1/7OmcmwJGVL6dhRBIt9x+ZBzOvsiEq3Whw9e2aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802774; c=relaxed/simple;
	bh=7cleDlm7Vjdxqa1DyB5CnDWcV3IUwCXZrBWDiWhYctc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiNZqIjlVc2OfA2s3GrXhZ3pOb22nFZ2bfMeD5sQ617Pbg+6jYLdtk627YsScUAsU0rmRrcRVyAxfha8CyTOeZpBEZ+E8FqjjN6hoOIE81eFSdT4I/MHEkixj8zksawr6pznvHjgNPwwStAEOZZeLtOF8nWgLRLo0Uy/HQdSK1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3LUUApa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3LUUApa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F4C2BBFC;
	Wed, 19 Jun 2024 13:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802774;
	bh=7cleDlm7Vjdxqa1DyB5CnDWcV3IUwCXZrBWDiWhYctc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3LUUApaZQMFRs2r7I35xiVTlsZg7Ypp8VK974cbx1FsmkzksUr92iUf3evpf8qCg
	 A7a/JrWVslttW/YAteyjauMheZ4Ye1sA/sbTrMpPAjZggQ+gjMM2nZ0bgQXovxVzGQ
	 CzjyvGihzRc82GmcO8ONa3t4YkTVSheCHnkl/7Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 011/281] wifi: mac80211: pass proper link id for channel switch started notification
Date: Wed, 19 Jun 2024 14:52:50 +0200
Message-ID: <20240619125610.280896762@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit 8ecc4d7a7cd3e9704b63b8e4f6cd8b6b7314210f ]

Original changes[1] posted is having proper changes. However, at the same
time, there was chandef puncturing changes which had a conflict with this.
While applying, two errors crept in -
   a) Whitespace error.
   b) Link ID being passed to channel switch started notifier function is
      0. However proper link ID is present in the function.

Fix these now.

[1] https://lore.kernel.org/all/20240130140918.1172387-5-quic_adisi@quicinc.com/

Fixes: 1a96bb4e8a79 ("wifi: mac80211: start and finalize channel switch on link basis")
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Link: https://msgid.link/20240509032555.263933-1-quic_adisi@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 07abaf7820c56..51dc2d9dd6b84 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4012,7 +4012,7 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		goto out;
 	}
 
-	link_data->csa_chanreq = chanreq; 
+	link_data->csa_chanreq = chanreq;
 	link_conf->csa_active = true;
 
 	if (params->block_tx &&
@@ -4023,7 +4023,7 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	cfg80211_ch_switch_started_notify(sdata->dev,
-					  &link_data->csa_chanreq.oper, 0,
+					  &link_data->csa_chanreq.oper, link_id,
 					  params->count, params->block_tx);
 
 	if (changed) {
-- 
2.43.0



