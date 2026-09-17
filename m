Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6E14E021D;
	Thu, 17 Sep 2026 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659894; cv=none; b=rgmn67G4xDppuPyua02/jLpSrX9OVDvcx5smk3jZtSzUtmEyLMS8UffNj7K1xTLjqVxFY0jsqtwtqQnV3e+pHntj858yztb6P48pPBnNOKU+bKEODDh9/lSSx15gt/ArfQZN/mlOU2Os+8zSew2+xdyDdjJI0kSxvzbqcSg1LbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659894; c=relaxed/simple;
	bh=lOkjPxYPzDHDxW1TMa3cop9BdialBt8DC8BTgsrsDaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3YtDIAxO4r5Hd10MS9ttN4xaBfX977dLt2RXBLhIhEOlSlEtTrsdQKSsHM2fMnFz1PJFysglQC2kjtAA4SGfBgKyZm1KwgW4P4QDvmLOissYlv2K4/x2p0tHdpkI3j+8DFhgcYuVzD+FzPBNvTbECggnU0ieWK03KrMBQwlu74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d94XhGET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d94XhGET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4825F1F000FF;
	Thu, 17 Sep 2026 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659890;
	bh=NMRpCW/3gUgJ/W3oeIvplQn6ZpMeBBuOwuqpFT9u1rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d94XhGETcli/9MPJqyiOneHF+zS2OSoygFjpQAWKEtbsiEfMiNnqUueI8EAPlfEa6
	 l2jGKgMcf1tz5NCraYa5dj5Ub3u+DZJYy+sHoMCtNBCyROawv/kW5WSPXqLh+iDlBd
	 Y+TvhwGn2ZuxsGDgApNoda66G81DsBd9RaROAGyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 407/733] net: phylink: initialise link_state before a forced major config
Date: Thu, 17 Sep 2026 16:11:55 +0100
Message-ID: <20260917151401.901502074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Sviridkin <f@lex.la>

[ Upstream commit 113998aa372f4869bf62cfc75c28a2849e8487be ]

phylink_resolve() leaves link_state on the stack unpopulated on its
disable and link-failed branches, which set only link_state.link.
phylink_apply_manual_flow() then reads the struct's advertising on
every mode but MLO_AN_FIXED, and has done so since long before
force_major_config existed.

force_major_config turns that into a write to the hardware. It is the
only trigger for the major-config block that does not require
mac_config, so phylink_major_config() programs the MAC for whatever
the stack held, a zeroed interface is PHY_INTERFACE_MODE_NA, and the
write-back stores it in pl->link_config.interface.

phylink_replay_link_end() is the only in-tree setter, and
sja1105_static_config_reload() calls it for every port that has a
phylink instance, regardless of admin state. On a stopped port
phylink_run_resolve() no-ops, so the flag outlives the call. The next
resolve consumes it whatever branch it takes; an unpopulated branch is
where that does damage.

Found while developing a series that attaches a late PHY from a
delayed work item and sets this flag there, so the PHY attached after
its port was already up. The link stayed down until the port was
cycled 29 minutes later. With this patch on the same board the same
attach programs the MAC for 2500base-x rather than unknown, and the
PHY's interrupt fires without a port bounce where it had stayed at
zero throughout the failure.

Fixes: 96969b132bf1 ("net: phylink: introduce helpers for replaying link callbacks")
Signed-off-by: Aleksei Sviridkin <f@lex.la>
Link: https://patch.msgid.link/20260904185540.2844261-1-f@lex.la
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7397169236fdf..27fd9aa2027a4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1630,8 +1630,10 @@ static void phylink_resolve(struct work_struct *w)
 
 	if (pl->phylink_disable_state) {
 		pl->link_failed = false;
+		link_state = pl->link_config;
 		link_state.link = false;
 	} else if (pl->link_failed) {
+		link_state = pl->link_config;
 		link_state.link = false;
 		retrigger = true;
 	} else if (pl->act_link_an_mode == MLO_AN_FIXED) {
-- 
2.53.0



