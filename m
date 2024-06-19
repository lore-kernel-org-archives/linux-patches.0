Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B1D82495;
	Wed, 19 Jun 2024 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803173; cv=none; b=HBVEVAT060vw49YcncTaHUKt2KHHWRqFW3WcZdZQeTbgRNk3HkKMFqL6dnJA0Rg02DpX7hI35H4uYbxbY9cKdROgUsalkpNIuPxC5lXOkdn/MaR4WcVVVil5fL+u5FHKmfZlSfCYku6Uk7KFmkYTyey9uNKppM6uh3niv9vB3tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803173; c=relaxed/simple;
	bh=c8IXpsAll02yFIkZD8WE422lpBln71daATatUyEVylA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkI1+NGJ31ajdMXgWeqX3gy3Dsnm6oTWfqophvtxyZrpKmIkCg1Enom5wBh72EheCX88yR16AFzExMjcurxZ/ceE2Xw+pv9kNYRQbFBMo1iZKCaD8g5Pkf0iZAEPBT/ctY9vIs0b6nnXAiC3kkbyF9TL4C2leIhnCgilLO+9CSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaC5fZVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaC5fZVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67262C2BBFC;
	Wed, 19 Jun 2024 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803172;
	bh=c8IXpsAll02yFIkZD8WE422lpBln71daATatUyEVylA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaC5fZVTgs3dDwala3JBcEvp7KA22dq4c6cJ6976LlsSRPy7CeVVW0ycwLL3+1giC
	 MWii3p0V4lk+Z4tCgeZ9EYexm/SDSlBa98wsxsfJ+7aB5GL23itVLmySO6bDYsmSO7
	 d0cmi9h6wRicNlWwTTxAfdO1KBvgk1jcpTbQMDy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 146/281] net: sfp: Always call `sfp_sm_mod_remove()` on remove
Date: Wed, 19 Jun 2024 14:55:05 +0200
Message-ID: <20240619125615.458434739@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index f75c9eb3958ef..d999d9baadb26 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2418,8 +2418,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
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



