Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852861741C4;
	Wed,  3 Jul 2024 11:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005487; cv=none; b=TnDcSt1U2mF1hdaqUucu44W+8HwoA9x2A3tIt1jEjXLmm9yw0h676LdQtbzJ02A+UzU+ToTwgDmduAY1ApmkKUeQtcPSBPrk4ZQpYGtkluM617I3m5dAgbM/2ZHZ/a9QcnmYwr5zItTt76MFE4++SgXSLbuuVpwBdFb4GbB2Llo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005487; c=relaxed/simple;
	bh=K4e7LJbuF9uC5KyITjLvZRIwb070hFg3t2atGHRYJyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aPmmnmdzVOjFXhiADZRwWx5puCjVYlkz/tyFf50Yq7Qkrf2Vyc7+V2eW2XlBe+6yiOwjLMt/CdPEgzJykoqpjEvYeNm378mMt82W+CxIRQz2ZbI2HS5ch7Ql3isXdxAeTSQe+b2XFuCg8hRyrDGR/+fz6u5GFn1MASS6KAIaBR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exzuRzza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exzuRzza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093DFC2BD10;
	Wed,  3 Jul 2024 11:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005487;
	bh=K4e7LJbuF9uC5KyITjLvZRIwb070hFg3t2atGHRYJyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exzuRzzakgBXE4eKCdiM2wcdPNS91kPcUmjboruLSlm9zyzzVSk/Q91Z8zlqJbRos
	 HukK5mmAZnoSBHCxOVXHkEDIT/Muvwj+jmF4nV0e5P8QGgSgsO37LacaGROJ3PfrJW
	 XEEtfj6HBvIpONWIfq9cHImPPSfP1DaRrHG9cA7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/356] net: sfp: Always call `sfp_sm_mod_remove()` on remove
Date: Wed,  3 Jul 2024 12:37:13 +0200
Message-ID: <20240703102916.772237169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d5918605eae6f..2bb30d635bbca 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2004,8 +2004,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
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



