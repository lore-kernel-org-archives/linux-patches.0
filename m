Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB9822E3F0;
	Wed,  4 Feb 2026 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218058; cv=none; b=H8XbJU0D0/SENc1Q+w0hj9NU9xQU/1INe9ZXx+R2PFhKX6AV29gbMeowPaGPRunJVsnHzSUTBIvZHXGaiT5MPo2VRI8q8KRMDKuFEomMlwrZ+rsn7PnXUMgUBgmy24+Ps+B9K1amcEICmAgeLlIel9evXq1T/bA2vhR7O08P9BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218058; c=relaxed/simple;
	bh=/l0yiVSv+desXB/jgjOZ6qIYyN568z2XvoQ//DzukMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZHDzjdFIOpZlx1gqJmTE+HTpdz5KfvVZLMgmeq9AeowTpu0X5RDiFRfJgVeEVsQkBJ0gMgA4QyFjxCPKX/S6CKkcwjl6QwiNG1s+IKVNcmBxExsoGyUWvJOrHTvuxpiO7n+L40r2aAO/RXnMNd4dghEDqGBIn8XTUGoc1qxscU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xw7Ztvbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xw7Ztvbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48430C4CEF7;
	Wed,  4 Feb 2026 15:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218058;
	bh=/l0yiVSv+desXB/jgjOZ6qIYyN568z2XvoQ//DzukMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xw7ZtvbxyNgS5fvvnqmzar2MPrFnxOyWTtdhpLpW2ikRYZfYGoYR5GfdrFQBdvClg
	 tyMqYGOnss3H2omVo4MiO+fKJx2p/Q5ZnZc6VUSFpy0kXWCYI6jYbrgNlyWW42Ai//
	 BMVcaDUzHNwr0Uh9K/2yqt/d6s3zhnqtBUvkZbNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 165/280] wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()
Date: Wed,  4 Feb 2026 15:38:59 +0100
Message-ID: <20260204143915.561437980@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -827,7 +827,7 @@ void mwifiex_update_rxreor_flags(struct
 static void mwifiex_update_ampdu_rxwinsize(struct mwifiex_adapter *adapter,
 					   bool coex_flag)
 {
-	u8 i;
+	u8 i, j;
 	u32 rx_win_size;
 	struct mwifiex_private *priv;
 
@@ -867,8 +867,8 @@ static void mwifiex_update_ampdu_rxwinsi
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


