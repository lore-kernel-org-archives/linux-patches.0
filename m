Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C36B2D5408;
	Wed, 28 Jan 2026 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614642; cv=none; b=lmClrket2jmd1LZ/7z3zYeI5M2wJ78D9ml47gmVV30YhH9KfrrvhwTBA9QjdVUvymENHIqGIXWZDZLJVpJakjPZzwgFeaVhfDhWUe/4LFsllJ9tFJ0xQSKkS+BBc9aoZ3kUqIgaZm7Hb7vNeXJgC9vx/w77xZ/EDw9zoKQ1/q08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614642; c=relaxed/simple;
	bh=r3Fycf1cLe30nU09bLkTw1irrT1NK/FPld6zleRiuW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mm15+iPpnoeiBgxTK77JujxE6mf2vvOM1IyE9uN2D3m8Mjm+9eTTRqjShuFbxUG7nifDbJr1UbCuh5nZkI2fe0rZQxi0As2SsNEFBjHyuU7kE5vvz7VT8c4wW32skQOL6UtzcC2wH4QEzVezSGTuKnVFcCGBwrZTcB6NJ3T69Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNr3Wdhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNr3Wdhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F336DC4CEF1;
	Wed, 28 Jan 2026 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614642;
	bh=r3Fycf1cLe30nU09bLkTw1irrT1NK/FPld6zleRiuW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNr3WdhuJunIH8m+lLiXa9OASaVPU8QYuQ3tXPOyOftHnz0UtMmos5gFrEk/BtEGd
	 bd5n19MFIGAToVbhxYP26TXEzXgb6VoilRww1g4LsrR60a3ORmbnDAfQjLpqEUEiYN
	 RtPlwnFvNLsDU2qeqlGbXvmHOnULT4vHtSXR6/GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 198/254] wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()
Date: Wed, 28 Jan 2026 16:22:54 +0100
Message-ID: <20260128145351.921535272@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


