Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1119BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E62C433D2;
	Tue,  7 Mar 2023 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212580;
	bh=NkhGTQjfEg3PCOniQyzM+GV8UTZR8oOJLCu/M5uuEjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLQ1I3aZ3A62Zq9Ll0Clzjk1CW0j/fynfuTczmoTBUa8IAcXjwVsm3aL08PTj+YS2
	 s+hZOy7h074jwTgoWVnrsiyBSsSRZVHyjCxtWHqkgUNso7at+pG9ZtCqZQgDBzmCiA
	 S4spNs50nK3KWuTSg46bv+3elGOXCQgEGUrZHVy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/885] wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
Date: Tue,  7 Mar 2023 17:52:43 +0100
Message-Id: <20230307170011.968243187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 3cfb7df24cee0f5fdc4cc5d3176cab9aadfcb430 ]

This code re-uses "i" to be the iterator for both the inside and outside
loops.  It means the outside loop will exit earlier than intended.

Fixes: d219b7eb3792 ("mwifiex: handle BT coex event to adjust Rx BA window size")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/Y+ERnaDaZD7RtLvX@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 4af57e6d43932..90e4011008981 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -878,7 +878,7 @@ mwifiex_send_delba_txbastream_tbl(struct mwifiex_private *priv, u8 tid)
  */
 void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
 {
-	u8 i;
+	u8 i, j;
 	u32 tx_win_size;
 	struct mwifiex_private *priv;
 
@@ -909,8 +909,8 @@ void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
 		if (tx_win_size != priv->add_ba_param.tx_win_size) {
 			if (!priv->media_connected)
 				continue;
-			for (i = 0; i < MAX_NUM_TID; i++)
-				mwifiex_send_delba_txbastream_tbl(priv, i);
+			for (j = 0; j < MAX_NUM_TID; j++)
+				mwifiex_send_delba_txbastream_tbl(priv, j);
 		}
 	}
 }
-- 
2.39.2



