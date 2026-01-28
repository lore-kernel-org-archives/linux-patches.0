Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF6D2DF155;
	Wed, 28 Jan 2026 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615346; cv=none; b=Sdh4cDNnIFiPjxGGB2LfaoojXIz0u6i1Xq1kGFR3Ke576KdDYreMJCjuYcCSl0VKaekUWSXdz/Egy5Xbs+h1lMEtqyNl+iL0kM6/LCXSFbaEawu2JyIhAGr4p1/ScdeFC2NjGyA57AbLSjYiPKOLORQxt9C3oT+KaTaCQ2b/DQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615346; c=relaxed/simple;
	bh=a1lHlJowBxJE89BW1RAC4RBIdXwkq3rOVd7B2tw1CfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5Z/P5u8dAkO+jjGDsJupZ/GgLsMJtFc6O8teQCDLofFt3nF2A8oZXpTKwUfn3TwmWAZgfZd+0QnuaAAgC7dfav3eXgMer9uL7qzuvh3kaorXJktO1oX9nDwjkkHwy1vIiKMoVz71dHuT2r8juS+Z7IfedGXoyFZtJ2kmaJh/dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7ouoDVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7ouoDVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F839C4CEF1;
	Wed, 28 Jan 2026 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615346;
	bh=a1lHlJowBxJE89BW1RAC4RBIdXwkq3rOVd7B2tw1CfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7ouoDVBPI0deOLlVoK57KBapfT8YDzFwWj78/LFOWra+CngbUTX622tpahdOYdZX
	 fLxjN2C2EcAefpT2JjTTflx+8duct91fgQoLvbcw6E94WwRDTyq41vWKIhoY3isLBw
	 vQbVe5bVa0YWn4hjWgtoGOb5pb57PIB11D+pe/aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 119/169] wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()
Date: Wed, 28 Jan 2026 16:23:22 +0100
Message-ID: <20260128145338.286314027@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 2120f3a3738a65730c81bf10447b1ff776078915 upstream.

The "i" iterator variable is used to count two different things but
unfortunately we can't store two different numbers in the same variable.
Use "i" for the outside loop and "j" for the inside loop.

Cc: stable@vger.kernel.org
Fixes: d219b7eb3792 ("mwifiex: handle BT coex event to adjust Rx BA window size")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/aWAM2MGUWRP0zWUd@stanley.mountain
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -825,7 +825,7 @@ void mwifiex_update_rxreor_flags(struct
 static void mwifiex_update_ampdu_rxwinsize(struct mwifiex_adapter *adapter,
 					   bool coex_flag)
 {
-	u8 i;
+	u8 i, j;
 	u32 rx_win_size;
 	struct mwifiex_private *priv;
 
@@ -863,8 +863,8 @@ static void mwifiex_update_ampdu_rxwinsi
 		if (rx_win_size != priv->add_ba_param.rx_win_size) {
 			if (!priv->media_connected)
 				continue;
-			for (i = 0; i < MAX_NUM_TID; i++)
-				mwifiex_11n_delba(priv, i);
+			for (j = 0; j < MAX_NUM_TID; j++)
+				mwifiex_11n_delba(priv, j);
 		}
 	}
 }


