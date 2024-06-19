Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180501E492;
	Wed, 19 Jun 2024 13:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803983; cv=none; b=jkIwzusit/d26OiJE5ENKOGpuWiPprYTJzas/jEg2OImtNY++QvvjQJaV4/Hmd514wj5GxpgrZUZi8SmfITWoRYWJhq1I9z+AjGwlHmcCxRa6RmmtMSW/PeEmFZsG3MNweWkJs8HCz3z6eAT7jPVVkVxQXXJPXA6asaM9IGOAdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803983; c=relaxed/simple;
	bh=y+8m7EM/zrG88ooWzF1pxqgI5ITNgbFVFAuU3bygFDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AtfyYDhnQHsROttcahGOB9O2dB2Qo9vpxP8vygoAvKbadH2xn/Bbt7mOfQtxvmixe/Pyr67YQVDc/UEyjMJlA5lsnRJKoimw6sIyIpG8L/SN4VHoZjHBxDEmQiwyKwx7GBbNn9pDQFI6Ujs+ehS3buPWokS0Me6vrXMGtaJOGbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8TgxYCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8TgxYCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCFEC2BBFC;
	Wed, 19 Jun 2024 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803983;
	bh=y+8m7EM/zrG88ooWzF1pxqgI5ITNgbFVFAuU3bygFDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8TgxYCmm6CPFYMe6nj0q78khFxfaRXK3ZReuxBGe90Lqvdx7CRQV/LNv2MbWpbH4
	 zkV1cFhc9H6686rkJyn579WwuqFuh0r8Kz6xnkhCQg7pWs32vvH2gQjYqKoiCGx1NO
	 WlKgeDqaa89bvRUH31rZEHfrPqRbBSX4hve3Fdg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/217] net: sfp: Always call `sfp_sm_mod_remove()` on remove
Date: Wed, 19 Jun 2024 14:56:21 +0200
Message-ID: <20240619125602.015739519@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b1403291d921..06dce78d7b0c9 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2150,8 +2150,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
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



