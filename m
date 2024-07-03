Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB5D13D61B;
	Wed,  3 Jul 2024 11:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004498; cv=none; b=NOGo5iu4zWoVtdnOHJIUOV5NNbhAObL6Lr3YtTZJK6zlZyvK+mlaZufxJC8qlgv40f0SBVpFHU8mXSkUnvWQ4UA3ohA9SYwAaI4oyGU1h0lYdc/ASJ+OK4IOfhnKaBqetIdQmMgKY5OuDQvyPrE9cz7NppnAWXHGJgx4Ywaiyxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004498; c=relaxed/simple;
	bh=VAMgWd2OHG01JFVc9zKFWIWSXlpTNca9Hnz8WqW6cuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZF2rIaqgSPAGkS0xuWAWYwSz95SALxkOb4z/F1yzVhqKIGXJogNir8xYxwYz6eBbOlUTMrjQdVeHCcbcFMG6u71uTHmpQOwKWIW4nhkZkrrHEhWdPJXbcyf6qpYsdvzh2166N43Y3s0S2lh74phg2IJQMv44ur7sprQL4tz774=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsxZyelZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsxZyelZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F686C2BD10;
	Wed,  3 Jul 2024 11:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004497;
	bh=VAMgWd2OHG01JFVc9zKFWIWSXlpTNca9Hnz8WqW6cuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsxZyelZxZ7JD8oFrrQeOFhVhkqL9R9DD6IssY5v0jvCzco0Hip/RYaYSH/5PTXjG
	 I8plZkVG3TNQmkHWmrqa4RRGZd3GUNaf7H91JCcfrCRC4KfQulb86Sz3jXMP2W8dNJ
	 GSGo9IN+O0CXKmQ2mixNHjrSqdkqo1kCI/uWrExQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/290] net: sfp: Always call `sfp_sm_mod_remove()` on remove
Date: Wed,  3 Jul 2024 12:37:23 +0200
Message-ID: <20240703102906.543164058@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit e96b2933152fd87b6a41765b2f58b158fde855b6 ]

If the module is in SFP_MOD_ERROR, `sfp_sm_mod_remove()` will
not be run. As a consequence, `sfp_hwmon_remove()` is not getting
run either, leaving a stale `hwmon` device behind. `sfp_sm_mod_remove()`
itself checks `sfp->sm_mod_state` anyways, so this check was not
really needed in the first place.

Fixes: d2e816c0293f ("net: sfp: handle module remove outside state machine")
Signed-off-by: "Csókás, Bence" <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240605084251.63502-1-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 6a5f40f11db3f..d08990437f3e7 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1952,8 +1952,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
 	/* Handle remove event globally, it resets this state machine */
 	if (event == SFP_E_REMOVE) {
-		if (sfp->sm_mod_state > SFP_MOD_PROBE)
-			sfp_sm_mod_remove(sfp);
+		sfp_sm_mod_remove(sfp);
 		sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
 		return;
 	}
-- 
2.43.0



